::--------- Package settings --------
:: package name
set P=proj
:: version
set V=4.9.3
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

::--------- Build script
wget --progress=bar:force https://github.com/OSGeo/proj.4/archive/4.9.3.zip || goto :error
unzip -q 4.9.3.zip || goto :error

cd proj.4-4.9.3
:: make sure the install dir is empty before installing
rd /s /q c:\install
set INSTDIR=C:\install
nmake /f makefile.vc || goto :error
nmake /f makefile.vc install-all || goto :error

:: binary archive
tar -C c:\install -cvjf %PKG_BIN% include lib bin share || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

