::--------- Package settings --------
:: package name
set P=qt4-devel
:: version
set V=4.8.7
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

rd /s /q c:\subinstall
mkdir c:\subinstall
mkdir c:\subinstall\apps
mkdir c:\subinstall\apps\Qt4
mkdir c:\subinstall\apps\Qt4\mkspecs
mkdir c:\subinstall\apps\Qt4\phrasebooks
mkdir c:\subinstall\bin
mkdir c:\subinstall\include
mkdir c:\subinstall\include\Qt4
mkdir c:\subinstall\lib

for /R c:\install\bin %%f in (*.exe) do copy %%f c:\subinstall\bin\
xcopy c:\install\mkspecs c:\subinstall\apps\Qt4\mkspecs /S
xcopy c:\install\phrasebooks c:\subinstall\apps\Qt4\phrasebooks /S
xcopy c:\install\include c:\subinstall\include\Qt4 /S
for /R c:\install\lib %%f in (*.lib) do copy %%f c:\subinstall\lib\
for /R c:\install\lib %%f in (*.prl) do copy %%f c:\subinstall\lib\

:: binary archive
tar -C c:\subinstall -cvjf %PKG_BIN% lib bin apps include || goto :error

rd /s /q c:\subinstall

::--------- Installation
xcopy %2 %PKG_SRC%*
call ..\__inc__\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
