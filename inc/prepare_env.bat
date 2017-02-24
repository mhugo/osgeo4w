:: Used environement variables
:: %P% package name
:: %V% version
:: %B% package version

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
set PATH=%PATH%;C:\Program Files\CMake\bin;C:\cygwin64\bin;C:\Program Files\PostgreSQL\9.6\bin
set RELEASE_HOST=ci@hekla.oslandia.net
set RELEASE_PATH=/home/storage/osgeo4w

::--------- Prepare the environment
set PKG_BIN=%P%-%V%-%B%.tar.bz2
set PKG_SRC=%P%-%V%-%B%-src.tar.bz2
set D=%RELEASE_PATH%/%P%
set R=%RELEASE_HOST%:%D%
ssh %RELEASE_HOST% "mkdir -p %D%"
set HERE=%CD%

