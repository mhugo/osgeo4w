::--------- Package settings --------
:: package name
set P=python3-pytempus
:: version
set V=1.0.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

c:\osgeo4w64\bin\osgeo4w-setup.exe -s http://hekla.oslandia.net/osgeo4w -k -q -P tempus-core -P boost-devel
wget --progress=bar:force https://gitlab.com/Oslandia/pytempus/repository/archive.tar.bz2?ref=master -O pytempus.tar.bz2
tar xjf pytempus.tar.bz2
cd pytempus-*
call ci\windows\build_gitlab.bat
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar -C c:\OSGeo4W64 --exclude="__pycache__" -cjvf %PKG_BIN% apps\python36\lib\site-packages\pytempus-%V%-py3.6-win-amd64.egg

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
call %HERE%\..\inc\install_archives.bat