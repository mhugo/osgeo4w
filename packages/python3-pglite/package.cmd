::--------- Package settings --------
:: package name
set P=python3-pglite
:: version
set V=1.0.8
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python3 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

wget -O pglite.zip https://github.com/Oslandia/pglite/archive/v%V%.zip || goto :error
unzip pglite.zip || goto :error
cd pglite-%V% || goto :error
:: WARNING: pglite.exe contains a reference to %OSGEO4W_ROOT%\bin\python.exe
:: so it will only works if the install dir of OSGEO4W matches the one
:: used during the construction of the pkg
pip install . || goto :error

cd %HERE%

copy pglite.conf %OSGEO4W_ROOT%\etc || goto :error
copy set_pglite_python_path.bat %OSGEO4W_ROOT%\etc\postinstall || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% ^
  apps/Python36/Lib/site-packages/pglite ^
  apps/Python36/Lib/site-packages/pglite-%V%.dist-info ^
  apps/Python36/Scripts/pglite.bat ^
  etc/pglite.conf ^
  etc/postinstall/set_pglite_python_path.bat || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
