::--------- Package settings --------
:: package name
set P=python-pglite
:: version
set V=1.0.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

pip install pglite

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/pglite

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%