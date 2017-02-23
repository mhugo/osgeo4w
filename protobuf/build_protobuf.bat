call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
set PATH=%PATH%;C:\Program Files\CMake\bin;C:\Program Files\PostgreSQL\9.6\bin
wget --progress=bar:force https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.zip
unzip -q protobuf-cpp-3.1.0.zip
cd protobuf-3.1.0\cmake
mkdir build
cd build
rd /s /q c:\libs
cmake -G "NMake Makefiles" -Dprotobuf_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=C:\libs -Dprotobuf_BUILD_TESTS=OFF ..
nmake
nmake install
cd c:\libs
xcopy /s bin x:\x86_64\release\protobuf\
xcopy /s lib x:\x86_64\release\protobuf\
xcopy /s include x:\x86_64\release\protobuf\
