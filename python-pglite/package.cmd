::--------- Package settings --------
:: package name
set P=python-pglite
:: version
set V=1.0.2
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat || goto :error

wget https://github.com/Oslandia/pglite/archive/master.zip || goto :error
unzip master.zip || goto :error
cd pglite-master || goto :error
python setup.py install || goto :error

cd %HERE%

copy pglite.conf %OSGEO4W_ROOT%\etc || goto :error
mkdir %OSGEO4W_ROOT%\etc\postinstall || goto :error
copy set_pglite_python_path.bat %OSGEO4W_ROOT%\etc\postinstall || goto :error

tar -C %OSGEO4W_ROOT% --transform 's,pglite-1.0.2-py2.7.egg/,,' -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/pglite-1.0.2-py2.7.egg/pglite etc/pglite.conf etc/postinstall || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
