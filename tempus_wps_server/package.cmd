::--------- Package settings --------
:: package name
set P=tempus-wps-server
:: version
set V=1.0.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P tempus-core -P boost-devel -P fcgi -P libxml2
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_wps_server/repository/archive.tar.bz2?ref=v1.0.0 -O tempus_wps_server.tar.bz2
tar xjf tempus_wps_server.tar.bz2
cd tempus_wps_server-*
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
