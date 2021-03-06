::--------- Package settings --------
:: package name
set P=python3-pillow
:: version
set V=4.0.0
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
call %OSGEO4W_ROOT%\bin\py3_env.bat
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

python3 -m pip install pillow==4.0.0

:: binary archive
tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/PIL

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
