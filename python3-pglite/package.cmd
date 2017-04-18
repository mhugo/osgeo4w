::--------- Package settings --------
:: package name
set P=python3-pglite
:: version
set V=1.0.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python3 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

python3 -m pip install pglite

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/pglite

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%