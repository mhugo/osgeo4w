::--------- Package settings --------
:: package name
set P=cgal
:: version
set V=4.11.1
:: package version
set B=2

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

set HERE=%CD%

rd /s /q c:\install
mkdir c:\install

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P boost-devel-vc14 || goto :error
c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P gmp || goto :error
c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P mpfr || goto :error

::dir c:\osgeo4w64\include
::dir c:\osgeo4w64\lib

wget --progress=bar:force https://github.com/CGAL/cgal/archive/releases/CGAL-4.11.1.tar.gz  || goto :err
tar xzf CGAL-4.11.1.tar.gz  || goto :error
cd cgal-releases-CGAL-4.11.1  || goto :error
mkdir build
cd build
cmake -G "NMake Makefiles" ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCMAKE_INSTALL_PREFIX=C:\install ^
    -DGMP_INCLUDE_DIR=c:\osgeo4w64\include ^
    -DGMP_LIBRARIES=c:\osgeo4w64\lib\libgmp-10.lib ^
    -DMPFR_INCLUDE_DIR=c:\osgeo4w64\include ^
    -DMPFR_LIBRARIES=c:\osgeo4w64\lib\libmpfr-4.lib ^
    -DBOOST_INCLUDEDIR=c:\osgeo4w64\include\boost-1_63 ^
    -DBOOST_LIBRARYDIR=c:\osgeo4w64\lib ^
    -DWITH_CGAL_ImageIO=OFF ^
    .. || goto :error
::    -DCMAKE_VERBOSE_MAKEFILE=ON ^
::    -DZLIB_ROOT=c:\osgeo4w64 ^
nmake || goto :error
nmake install || goto :error

move c:\inslall\lib\*.dll c:\inslall\bin

:: binary archive
tar -C c:\install -cjvf %PKG_BIN% lib share include bin || goto :error

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
  
  
