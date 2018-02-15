::--------- Package settings --------
:: package name
set P=protobuf
:: version
set V=3.1.0
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

::--------- Build script
wget --progress=bar:force https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.zip || goto :error
unzip -q protobuf-cpp-3.1.0.zip || goto :error

cd protobuf-3.1.0\cmake
mkdir build
cd build
:: make sure the install dir is empty before installing
rd /s /q c:\install
cmake -G "NMake Makefiles" -Dprotobuf_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=C:\install -Dprotobuf_BUILD_TESTS=OFF ..
nmake && nmake install || goto :error

:: binary archive
tar -C c:\install -cvjf %PKG_BIN% include lib bin || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\__inc__\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

