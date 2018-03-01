::--------- Package settings --------
:: package name
set P=python3-fourmy
:: version
set V=0.0.1
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P boost-devel-vc14 || goto :error
c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P cgal || goto :error


:: python2 package
call %OSGEO4W_ROOT%\bin\py3_env.bat || goto :error
python3 -m pip install --upgrade setuptools || goto :error

wget -O fourmy.zip https://github.com/Oslandia/fourmy/archive/r%V%.zip || goto :error
::wget -O fourmy.zip  https://github.com/Oslandia/fourmy/archive/master.zip
unzip fourmy.zip || goto :error
cd fourmy* || goto :error

set INCLUDE_PATH=%OSGEO4W_ROOT%\include;%OSGEO4W_ROOT%\include\boost-1_63
set LIBRARY_PATH=%OSGEO4W_ROOT%\lib
set CGAL_LIBNAME=CGAL-vc140-mt-4.11.1-I-900
set GMP_LIBNAME=libgmp-10
set MPFR_LIBNAME=libmpfr-4
set BOOSTPYTHON_LIBNAME=boost_python3-vc140-mt-1_63
python3 setup.py build || goto :error
python3 setup.py install || goto :error

cd %HERE%

:: binary archive
dir %OSGEO4W_ROOT%\apps\Python36\Lib\site-packages

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% ^
  apps/Python36/Lib/site-packages/fourmy ^
  apps/Python36/Lib/site-packages/fourmy-%V%-py3.6.egg-info || goto :error
:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
