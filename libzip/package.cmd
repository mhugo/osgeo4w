::--------- Package settings --------
:: package name
set P=libzip
:: version
set V=1.2.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

::c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P boost-devel-vc14 || goto :error
wget --progress=bar:force https://nih.at/libzip/libzip-1.2.0.tar.gz || goto :error
tar xjf libzip-1.2.0.tar.gz
cd libzip-1.2.0
cmake -G "NMake Makefiles" -D "CMAKE_INSTALL_PREFIX=C:\install" .. || goto :error

nmake || goto :error
nmake install || goto :error

:: binary archive
tar -C c:\install -cvjf %PKG_BIN% lib/libzip/include/zipconf.h include/zip.h lib/zip.lib bin/zip.dll

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
  
  
