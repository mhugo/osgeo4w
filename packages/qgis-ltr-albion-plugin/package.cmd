::--------- Package settings --------
:: package name
set P=qgis-ltr-albion-plugin
:: version
set V=3.0.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
set BUILD_DEPS=python-core

call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%
set PYTHONPATH=%PYTHONPATH%;%HERE%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat || goto :error

python -m pip install sphinx

git clone --depth 1 https://github.com/Oslandia/albion.git || goto :error
::wget https://github.com/Oslandia/albion/archive/v%V%.zip -O albion.zip || goto :error
::unzip albion.zip
mkdir install
python -m albion.package -i install
dir install
dir install\albion

echo --transform 's,install/,apps/qgis-ltr/python/plugins/,' -cvjf %PKG_BIN% install
tar --transform 's,install/,apps/qgis-ltr/python/plugins/,' -cvjf %PKG_BIN% install || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
