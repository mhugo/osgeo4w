::--------- Package settings --------
:: package name
set P=python-tempus-loader
:: version
set V=1.0.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

set OSGEO4W_ROOT=C:\osgeo4w64
call c:\osgeo4w64\etc\ini\python-core.bat
set PATH=%PATH%;c:\osgeo4w64\bin;c:\cygwin64\bin

wget --progress=bar:force https://gitlab.com/Oslandia/tempus_loader/repository/archive.tar.bz2?ref=master -O tempus_loader.tar.bz2
tar xjf tempus_loader.tar.bz2
cd tempus_loader-*
python setup.py install
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar -C c:\OSGeo4W64 -cjvf %PKG_BIN% apps/python27/lib/site-packages/tempusloader-%V%-py2.7.egg

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
call %HERE%\..\inc\install_archives.bat