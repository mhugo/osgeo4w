::--------- Package settings --------
:: package name
set P=python3-pyshp
:: version
set V=1.2.10
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

python3 -m pip install pyshp==1.2.10

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/pyshp

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
