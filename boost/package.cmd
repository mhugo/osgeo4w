::--------- Package settings --------
:: package name
set P=boost
:: version
set V=1.63.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

wget --progress=bar:force https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.bz2
tar xjf boost_1_63_0.tar.bz2

cd boost_1_63_0
call bootstrap.bat
copy /Y ..\project-config-py3.jam .\project-config.jam
:: add python36.dll in the path
set PATH=%PATH%;c:\osgeo4w64\bin
.\b2 --prefix=C:\install link=static,shared architecture=x86 address-model=64 variant=release,debug install ^
  --with-python ^
  --with-atomic ^
  --with-chrono ^
  --with-date_time ^
  --with-exception ^
  --with-filesystem ^
  --with-graph ^
  --with-graph_parallel ^
  --with-iostreams ^
  --with-locale ^
  --with-log ^
  --with-program_options ^
  --with-regex ^
  --with-serialization ^
  --with-system ^
  --with-test ^
  --with-thread ^
  --with-timer

md c:\install\pkg
md c:\install\pkg\bin
copy c:\install\lib\*.dll c:\install\pkg\bin
tar -C c:\install\pkg -cjvf boost-%V%-%B%.tar.bz2 bin
del c:\install\lib\*.dll

tar -C c:\install -cjvf boost-devel-%V%-%B%.tar.bz2 include lib

tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint setup-devel.hint project-config-py3.jam

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%

::-- -devel package
ssh %RELEASE_HOST% "mkdir -p %RELEASE_PATH%/boost-devel"
scp boost-devel-%V%-%B%.tar.bz2 %RELEASE_HOST%:%RELEASE_PATH%/boost-devel

cd %HERE%
scp setup.hint %R%
scp setup-devel.hint %RELEASE_HOST%:%RELEASE_PATH%/boost-devel/setup.hint


  
  
