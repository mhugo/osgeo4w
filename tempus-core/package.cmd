::--------- Package settings --------
:: package name
set P=tempus-core
:: version
set V=2.3.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

c:\osgeo4w64\bin\osgeo4w-setup.exe -s http://hekla.oslandia.net/osgeo4w -k -q -P boost-devel
wget --progress=bar:force https://gitlab.com/Oslandia/tempus_core/repository/archive.tar.bz2?ref=v2.3.0 -O tempus.tar.bz2
tar xjf tempus.tar.bz2
cd tempus_core*
call ci\windows\build_gitlab.bat
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
  
  
