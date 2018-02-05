::--------- Package settings --------
:: package name
set P=qt4-libs
:: version
set V=4.8.7
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

rd /s /q c:\subinstall
mkdir c:\subinstall
mkdir c:\subinstall\apps
mkdir c:\subinstall\apps\Qt4
mkdir c:\subinstall\apps\Qt4\plugins
mkdir c:\subinstall\apps\Qt4\imports
mkdir c:\subinstall\apps\Qt4\translations
mkdir c:\subinstall\bin

for /R c:\install\bin %%f in (*.dll) do copy %%f c:\subinstall\bin\
xcopy c:\install\plugins c:\subinstall\apps\Qt4\plugins /S
xcopy c:\install\imports c:\subinstall\apps\Qt4\imports /S
xcopy c:\install\translations c:\subinstall\apps\Qt4\translations /S

:: binary archive
tar -C c:\subinstall -cvjf %PKG_BIN% apps bin || goto :error

rd /s /q c:\subinstall

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1
