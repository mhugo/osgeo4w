::--------- Package settings --------
:: package name
set P=gmp
:: version
set V=5.0.1
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set HERE=%CD%

wget --progress=bar:force https://cgal.geometryfactory.com/CGAL/precompiled_libs/auxiliary/x64/GMP/5.0.1/gmp-all-CGAL-3.9.zip || goto :err
unzip gmp-all-CGAL-3.9.zip || goto :error

:: binary archive
tar  -cvjf %PKG_BIN% lib include gmp.* || goto :error

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
  
  
