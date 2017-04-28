::--------- Package settings --------
:: package name
set P=tempus-wps-server
:: version
set V=1.1.0
:: package version
set B=2

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P tempus-core -P boost-devel -P fcgi -P libxml2 || goto :error
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_wps_server/repository/archive.tar.bz2?ref=v1.1.0 -O tempus_wps_server.tar.bz2 || goto :error
tar xjf tempus_wps_server.tar.bz2
cd tempus_wps_server-*
call ci\windows\build_gitlab.bat || goto :error

mkdir install\bin\nginx
mkdir install\bin\nginx\conf
mkdir install\bin\nginx\logs
mkdir install\bin\nginx\temp
copy %HERE%\local_tempus_wps.bat install\bin || goto :error
copy %HERE%\nginx\tempus.conf install\bin\nginx\conf || goto :error
copy %HERE%\nginx\mime.types install\bin\nginx\conf || goto :error

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint local_tempus_wps.bat nginx || goto :error

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1
