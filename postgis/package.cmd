::--------- Package settings --------
:: package name
set P=postgis
:: version
set V=2.4.0dev
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

set OSGEO4W_HOME=c:\osgeo4w64
%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P postgresql geos 

::-- Cygwin has its own Perl which won't work, put our perl in front
set PATH=C:\strawberry\perl\bin;%PATH%
::-- Add osgeo4w to the path, we need it to be before strawberry in order to avoid pg_config.exe there
set PATH=c:\osgeo4w64\bin;%PATH%

git clone https://gitlab.com/Oslandia/postgis.git
::wget --progress=bar:force http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz
::tar xzvf postgis-2.3.2.tar.gz
wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz
tar -xvzf proj-4.9.3.tar.gz
cd proj-4.9.3
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake

cd %HERE%

:: copy the config file
cd postgis
git checkout cmake
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake

cd %HERE%

if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: make sure the install dir is empty before installing

rd /s /q c:\install
mkdir c:\install\lib
mkdir c:\install\share
mkdir c:\install\share\extension

copy postgis\build\postgis\postgis-2.4.dll c:\install\lib
copy postgis\build\extensions\postgis\postgis.control c:\install\share\extension
copy postgis\build\extensions\postgis\postgis--2.4.0dev.sql c:\install\share\extension

tar -C c:\install -cjvf %PKG_BIN% lib share

if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
:: call %HERE%\..\inc\install_archives.bat

