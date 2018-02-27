::--------- Package settings --------
:: package name
set P=cgal
:: version
set V=4.11.1
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set HERE=%CD%

rd /s /q c:\install
mkdir c:\install

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P boost-devel-vc14 || goto :error

wget --progress=bar:force https://github.com/CGAL/cgal/archive/releases/CGAL-4.11.1.tar.gz  || goto :err
tar xzf CGAL-4.11.1.tar.gz  || goto :error
cd cgal-releases-CGAL-4.11.1  || goto :error
mkdir build
cd build
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=C:\install .. || goto :error
nmake || goto :error
nmake install || goto :error

:: binary archive
tar -C c:\install -cjvf %PKG_BIN% lib share include || goto :error

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
  
  
