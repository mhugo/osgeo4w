::--------- Package settings --------
:: package name
set P=nginx
:: version
set V=1.13.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

wget http://nginx.org/download/nginx-1.13.0.zip || goto :error
unzip nginx-1.13.0.zip || goto :error
ren nginx-1.13 nginx || goto :error

:: binary archive
tar --transform 's,^,apps/,' -cvjf %PKG_BIN% nginx || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1
