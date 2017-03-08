::--------- Package settings --------
:: package name
set P=osm2tempus
:: version
set V=1.0.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

c:\osgeo4w64\bin\osgeo4w-setup.exe -s http://hekla.oslandia.net/osgeo4w -k -q -P tempus-core -P boost-devel -P protobuf
wget --progress=bar:force https://gitlab.com/Oslandia/osm2tempus/repository/archive.tar.bz2?ref=master -O osm2tempus.tar.bz2
tar xjf osm2tempus.tar.bz2
cd osm2tempus-*
call ci\windows\build_gitlab.bat
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
call %HERE%\..\inc\install_archives.bat
