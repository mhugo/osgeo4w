::--------- Package settings --------
:: package name
set P=python3-pglite
:: version
set V=1.0.2
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python3 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

wget https://github.com/Oslandia/pglite/archive/master.zip || goto :error
unzip master.zip || goto :error
cd pglite-master || goto :error
python3 setup.py install || goto :error

cd %HERE%

copy pglite.conf %OSGEO4W_ROOT%\etc || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/pglite-%V%-py36.egg etc/pglite.conf || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
