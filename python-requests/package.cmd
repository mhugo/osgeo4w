::--------- Package settings --------
:: package name
set P=python-requests
:: version
set V=2.10.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

pip install requests==%V% || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/requests apps/Python27/Lib/site-packages/requests-%V%.dist-info || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1

