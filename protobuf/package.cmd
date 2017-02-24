::--------- Package settings --------
:: package name
set P=protobuf
:: version
set V=3.1.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

::--------- Build script
wget --progress=bar:force https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.zip
unzip -q protobuf-cpp-3.1.0.zip

cd protobuf-3.1.0\cmake
mkdir build
cd build
:: make sure the install dir is empty before installing
rd /s /q c:\install
cmake -G "NMake Makefiles" -Dprotobuf_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=C:\install -Dprotobuf_BUILD_TESTS=OFF ..
nmake && nmake install
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: binary archive
tar -C c:\install -cvjf %PKG_BIN% include lib bin

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint

::--------- Installation
call %HERE%\..\inc\install_archives.bat

