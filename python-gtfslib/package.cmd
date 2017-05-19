::--------- Package settings --------
:: package name
set P=python-gtfslib
:: version
set V=1.0.1
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

pip install gtfslib

cd %OSGEO4W_ROOT%\apps\python27\lib\site-packages
patch -p1 < %HERE%\do_not_prefetch.patch
cd %HERE%

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/gtfslib apps/Python27/Lib/site-packages/gtfslib-%V%-py2.7.egg-info

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
