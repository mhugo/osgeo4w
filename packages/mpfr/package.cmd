::--------- Package settings --------
:: package name
set P=mpfr
:: version
set V=3.9.0
:: package version
set B=2

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set HERE=%CD%

wget --progress=bar:force https://cgal.geometryfactory.com/CGAL/precompiled_libs/auxiliary/x64/MPFR/3.0.0/mpfr-all-CGAL-3.9.zip || goto :err
unzip mpfr-all-CGAL-3.9.zip || goto :error


:: binary archive
tar -cvjf %PKG_BIN% include lib mpfr.* || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error
goto :EOF

:error
echo Build failed
exit /b 1
  
  
