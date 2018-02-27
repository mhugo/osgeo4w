::--------- Package settings --------
:: package name
set P=gmp
:: version
set V=6.1.2
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set HERE=%CD%

wget --progress=bar:force https://cgal.geometryfactory.com/CGAL/precompiled_libs/auxiliary/x64/GMP/5.0.1/gmp-all-CGAL-3.9.zip || goto :err
unzip gmp-all-CGAL-3.9.zip || goto :error


:: binary archive
tar -C c:\install -cjvf %PKG_BIN% lib share include || goto :error
tar --transform 's,gmp-all-CGAL-3.9,,' -cvjf %PKG_BIN% gmp-all-CGAL-3.9

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
  
  
