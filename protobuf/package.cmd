call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
set PATH=%PATH%;C:\Program Files\CMake\bin;C:\Program Files\PostgreSQL\9.6\bin;C:\cygwin64\bin

set P=protobuf
set V=3.1.0
set B=1
set H=ci@hekla.oslandia.net
set D=/home/storage/osgeo4w/x86_64/release/%P%
set R=%H%:%D%
ssh %H% "mkdir -p %D%"

wget --progress=bar:force https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.zip
unzip -q protobuf-cpp-3.1.0.zip
cd protobuf-3.1.0\cmake
mkdir build
cd build
rd /s /q c:\install
cmake -G "NMake Makefiles" -Dprotobuf_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=C:\install -Dprotobuf_BUILD_TESTS=OFF ..
nmake
nmake install
tar -C c:\install -cjf %P%-%V%-%B%.tar.bz2 include lib bin

scp %P%-%V%-%B%.tar.bz2 %R%
