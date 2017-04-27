::--------- Package settings --------
:: package name
set P=tempus-core
:: version
set V=2.4.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P boost-devel || goto :error
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_core/repository/archive.tar.bz2?ref=master -O tempus.tar.bz2 || goto :error
tar xjf tempus.tar.bz2
cd tempus_core*
call ci\windows\build_gitlab.bat || goto :error

copy install\lib\tempus.dll install\bin || goto :error

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error
goto :EOF

:error
echo Build failed
exit /b 1
  
  
