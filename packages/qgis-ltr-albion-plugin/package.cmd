::--------- Package settings --------
:: package name
set P=qgis-ltr-albion-plugin
:: version
set V=1.04.16
:: package version
set B=3

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%
set PYTHONPATH=%PYTHONPATH%;%HERE%


%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P python-core

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat || goto :error

git clone --depth 1 https://github.com/Oslandia/albion.git || goto :error
cd albion
python -m albion.package -i %OSGEO4W_ROOT%\apps\qgis-ltr\python\plugins

cd %HERE%

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% ^
  apps/qgis-ltr/python/plugins/albion || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
