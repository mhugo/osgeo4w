::--------- Package settings --------
:: package name
set P=tempus-core
:: version
set V=2.2.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

wget --progress=bar:force https://gitlab.com/Oslandia/Tempus/repository/archive.tar.bz2?ref=test-ci -O tempus.tar.bz2
tar xjf tempus.tar.bz2
cd Tempus-*
mkdir build
cd build
cmake -G "NMake Makefiles" ^
  -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
  -DCMAKE_INSTALL_PREFIX=c:\install ^
  "-DPOSTGRESQL_PG_CONFIG=C:\Program Files\Postgresql\9.6\bin\pg_config.exe" ^
  -DBOOST_LIBRARYDIR=C:\osgeo4w64\lib ^
  -DBOOST_INCLUDEDIR=C:\osgeo4w64\include\boost-1_63 ^
  -DBoost_COMPILER=-vc140 ^
  -DLIBXML2_INCLUDE_DIR=C:\osgeo4w64\include ^
  -DLIBXML2_LIBRARIES=C:\osgeo4w64\lib\libxml2.lib ^
  -DFCGI_INCLUDE_DIR=C:\osgeo4w64\include ^
  -DFCGI_LIBRARIES=C:\osgeo4w64\lib\libfgci.lib ^
  -DBUILD_WPS=ON ^
  -DBUILD_QGIS_PLUGIN=OFF ^
  -DBUILD_OSM2TEMPUS=OFF ^
  -DBUILD_DOC=OFF ^
  ..
nmake && nmake install
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar -C c:\ --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
call %HERE%\..\inc\install_archives.bat
  
  
