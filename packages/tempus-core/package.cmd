::--------- Package settings --------
:: package name
set P=tempus-core
:: version
set V=2.6.2
:: package version
set B=1
:: build dependencies
set BUILD_DEPS=boost-devel-vc14

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

if "%1"=="test" (
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_core/repository/master/archive.tar.bz2 -O tempus.tar.bz2 || goto :error
) else (
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_core/repository/archive.tar.bz2?ref=v%V% -O tempus.tar.bz2 || goto :error
)
tar xjf tempus.tar.bz2
cd tempus_core*
call ci\windows\build_gitlab.bat || goto :error

copy lib\tempus.dll bin || goto :error

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install bin/tempus.dll lib/tempus.pdb lib/tempus.lib || goto :error

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
  
  
