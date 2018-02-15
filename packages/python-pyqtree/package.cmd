::--------- Package settings --------
:: package name
set P=python-pyqtree
:: version
set V=0.24
:: package version
set B=3

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat || goto :error

pip install Pyqtree==0.24 || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/pyqtree.py apps/Python27/Lib/site-packages/Pyqtree-0.24.dist-info || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

