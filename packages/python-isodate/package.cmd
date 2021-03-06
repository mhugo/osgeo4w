::--------- Package settings --------
:: package name
set P=python-isodate
:: version
set V=0.5.4
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

pip install isodate==%V%

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/isodate*

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
