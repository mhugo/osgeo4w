::--------- Package settings --------
:: package name
set P=postgis
:: version
set V=2.5.0dev
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set OSGEO4W_HOME=c:\osgeo4w64
%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P postgresql 
%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P geos 
%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P libxml2

::-- Cygwin has its own Perl which won't work, put our perl in front
set PATH=C:\strawberry\perl\bin;%PATH%
::-- Add osgeo4w to the path, we need it to be before strawberry in order to avoid pg_config.exe there
set PATH=c:\osgeo4w64\bin;%PATH%

git clone https://gitlab.com/Oslandia/postgis.git --depth 1 --branch cmake_update || goto :error

::
:: local build of proj4 in static
::
wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz || goto :error
tar -xvzf proj-4.9.3.tar.gz
cd proj-4.9.3
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "NMake Makefiles" .. || goto :error
nmake || goto :error

cd %HERE%

::
:: local build of iconv in static
::
git clone https://github.com/winlibs/libiconv.git --depth 1 --branch master || goto :error
cd libiconv\MSVC14\libiconv_static
msbuild libiconv_static.vcxproj /p:Configuration=Release || goto :error
dir x64\Release
 
cd %HERE%

:: copy the config file
cd postgis
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
      -DPROJ4_LIBRARY=%HERE%\proj-4.9.3\build\lib\proj_4_9.lib ^
      -DPROJ4_INCLUDE_DIR=%HERE%\proj-4.9.3\src\ ^
      -DPOSTGRESQL_LIBRARIES=c:\osgeo4w64\lib\postgres.lib ^
      -DLIBPQ_LIBRARY=c:\osgeo4w64\lib\libpq.lib ^
      -DLIBXML2_LIBRARY=c:\osgeo4w64\lib\libxml2.lib ^
      -DICONV_INCLUDE_DIR=%HERE%\libiconv\source\include ^
      -DICONV_LIBRARY=%HERE%\libiconv\MSVC14\x64\lib\libiconv_a.lib ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE ^
      -G "NMake Makefiles" .. || goto :error
cmake --build . -- VERBOSE=1 || goto :error

cd %HERE%

:: make sure the install dir is empty before installing

rd /s /q c:\install
mkdir c:\install\lib
mkdir c:\install\share
mkdir c:\install\share\extension
mkdir c:\install\bin

copy postgis\build\postgis\postgis-2.5.dll c:\install\lib || goto :error
copy postgis\build\extensions\postgis\postgis.control c:\install\share\extension || goto :error
copy postgis\build\extensions\postgis\postgis--2.5.0dev.sql c:\install\share\extension || goto :error
copy postgis\build\loader\shp2pgsql.exe c:\install\bin || goto :error
copy postgis\build\loader\pgsql2shp.exe c:\install\bin || goto :error

tar -C c:\install -cjvf %PKG_BIN% lib share bin || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error
:: call %HERE%\..\__inc__\install_archives.bat

goto :EOF

:error
echo Build failed
exit /b 1
