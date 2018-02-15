::--------- Package settings --------
:: package name
set P=boost-vc14
:: version
set V=1.63.0
:: package version
set B=3

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

:: install patch.exe
%HOME%\setup-x86_64.exe -s http://cygwin.mirror.constant.com -W -q -P patch

wget --progress=bar:force https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.bz2 || goto :error
tar xjf boost_1_63_0.tar.bz2 || goto :error

cd boost_1_63_0

:: apply patch
c:\cygwin64\bin\patch -p1 < ../msvc2015_numpy_build.patch || goto :error

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
  --with-timer || goto :error

md c:\install\pkg || goto :error
md c:\install\pkg\bin || goto :error
copy c:\install\lib\*.dll c:\install\pkg\bin || goto :error
tar -C c:\install\pkg -cjvf boost-vc14-%V%-%B%.tar.bz2 bin || goto :error
del c:\install\lib\*.dll || goto :error

tar -C c:\install -cjvf boost-devel-vc14-%V%-%B%.tar.bz2 include lib || goto :error

tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint setup-devel.hint project-config-py3.jam || goto :error

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R% || goto :error

::-- -devel package
ssh %RELEASE_HOST% "mkdir -p %RELEASE_PATH%/boost-devel-vc14" || goto :error
scp boost-devel-vc14-%V%-%B%.tar.bz2 %RELEASE_HOST%:%RELEASE_PATH%/boost-devel-vc14 || goto :error

cd %HERE%
scp setup.hint %R% || goto :error
scp setup-devel.hint %RELEASE_HOST%:%RELEASE_PATH%/boost-devel-vc14/setup.hint || goto :error

goto :EOF

:error
echo Build failed
exit /b 1


  
  
