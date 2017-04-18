::--------- Package settings --------
:: package name
set P=python3-olefile
:: version
set V=0.44
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
call %OSGEO4W_ROOT\bin\py3_env.bat

python3 -m pip install olefile==0.44

:: binary archive
tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/olefile

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
