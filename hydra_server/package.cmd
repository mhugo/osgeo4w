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

scp ci@hekla.oslandia.net:/home/storage/ci/hydra_server.tar.bz2 .
tar -xvjf hydra_server.tar.bz2

:: binary archive
tar --transform 's,build/lib,apps/Python36/Lib/site-packages,' --transform 's,build/hydra,share/extension/hydra,' -cvjf %PKG_BIN% build

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
