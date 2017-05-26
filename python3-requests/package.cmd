::--------- Package settings --------
:: package name
set P=python3-requests
:: version
set V=2.10.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python3 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat
call %OSGEO4W_ROOT%\bin\py3_env.bat

python3 -m pip install requests==%V% || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/requests apps/Python36/Lib/site-packages/requests-%V%.dist-info || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1

