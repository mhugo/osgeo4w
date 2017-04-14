::--------- Package settings --------
:: package name
set P=gmsh
:: version
set V=3.0.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

wget http://gmsh.info/bin/Windows/gmsh-3.0.0-Windows64.zip
unzip gmsh-3.0.0-Windows64.zip


:: binary archive
tar --transform 's,gmsh-3.0.0-Windows,bin,' -cvjf %PKG_BIN% install gmsh-3.0.0-Windows/gmsh.exe

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
