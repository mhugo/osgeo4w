::--------- Package settings --------
:: package name
set P=python3-pyshp
:: version
set V=1.2.10
:: package version
set B=3

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

python3 -m pip install pyshp==1.2.10 || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/shapefile.py apps/Python36/Lib/site-packages/pyshp-1.2.10.dist-info || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
