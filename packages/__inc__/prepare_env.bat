:: Arguments
:: %1 name of the environment
:: Used environement variables
:: %P% package name
:: %V% version
:: %B% package version

call c:\osgeo4w64\bin\o4w_env.bat
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
set PATH=%PATH%;C:\Program Files\CMake\bin;C:\cygwin64\bin

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
:: launch the setup and wait for the exit code
echo Installing OSGeo4W dependencies ...
start /wait c:\osgeo4w64\bin\osgeo4w-setup.exe --upgrade-also -O -s %OSGEO4W_REPO% -k -q %BUILD_DEPS_P%
:: other error codes (including 117 - reboot needed) are ignored
if %errorlevel% == 1 (
  echo Problem installing dependencies %BUILD_DEPS_P%
  exit /b 1
)
endlocal

::--------- Prepare the environment
:nodeps
set PKG_BIN=%P%-%V%-%B%.tar.bz2
set PKG_SRC=%P%-%V%-%B%-src.tar.bz2
set D=%RELEASE_PATH%/%P%
set R=%RELEASE_HOST%:%D%
ssh %RELEASE_HOST% "mkdir -p %D%"
set HERE=%CD%


