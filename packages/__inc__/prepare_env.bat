:: Arguments
:: %1 name of the environment
:: Used environement variables
:: %P% package name
:: %V% version
:: %B% package version

call c:\osgeo4w64\bin\o4w_env.bat
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
set PATH=%PATH%;C:\Program Files\CMake\bin;C:\cygwin64\bin;C:\Program Files\PostgreSQL\9.6\bin
echo "Deploy = %1"
if "%1"=="release" (
set RELEASE_HOST=ci@hekla.oslandia.net
set RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra/x86_64/release/extra
set OSGEO4W_REPO=http://osgeo4w-oslandia.com/extra
)
if "%1"=="test" (
set RELEASE_HOST=ci@hekla.oslandia.net
set RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra.test/x86_64/release/extra
set OSGEO4W_REPO=http://osgeo4w-oslandia.com/extra.test
)

::--- install needed dependencies
if "%BUILD_DEPS%" == "" goto nodeps
:: add -P in front of each dependency
setlocal enabledelayedexpansion
set BUILD_DEPS_P=
for %%d in (%BUILD_DEPS%) do (
  set BUILD_DEPS_P=!BUILD_DEPS_P! -P %%d
)
c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q %BUILD_DEPS_P% || goto deperror

goto nodeps
:deperror
echo Problem installing dependencies %BUILD_DEPS_P%
exit /b 1
:nodeps

::--------- Prepare the environment
set PKG_BIN=%P%-%V%-%B%.tar.bz2
set PKG_SRC=%P%-%V%-%B%-src.tar.bz2
set D=%RELEASE_PATH%/%P%
set R=%RELEASE_HOST%:%D%
ssh %RELEASE_HOST% "mkdir -p %D%"
set HERE=%CD%

