::--------- Package settings --------
:: package name
set P=python-dxfwrite
:: version
set V=1.2.1
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat || goto :error

pip install dxfwrite==%V% || goto :error

cd %HERE%

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% ^
  apps/Python27/Lib/site-packages/dxfwrite ^
  apps/Python27/Lib/site-packages/dxfwrite-%V%.dist-info || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
