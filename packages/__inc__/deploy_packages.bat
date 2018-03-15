@echo off
:: %1 target (test|release)
:: %2 arch (x86|x86_64)
:: %3 local absolute path to be deployed
setlocal
set ARCH=%2
set P=%3
if "%1"=="release" (
set RELEASE_HOST=ci@hekla.oslandia.net
set RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra/%ARCH%/release/extra
)
if "%1"=="test" (
set RELEASE_HOST=ci@hekla.oslandia.net
set RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra/%ARCH%/release/extra
)

:: call cygpath on the given path
for /F "tokens=* USEBACKQ" %%F in (`cygpath %P%`) do (set PP=%%F)
scp -r %PP%/* %RELEASE_HOST%:%RELEASE_PATH%