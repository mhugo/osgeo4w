::--------- Package settings --------
:: package name
set P=hydra_server
:: version
set V=0.0.23
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

scp ci@hekla.oslandia.net:/home/storage/ci/hydra_server.tar.bz2 .
tar -xvjf hydra_server.tar.bz2

:: binary archive
tar --transform 's,build/lib,apps/Python36/Lib/site-packages,' --transform 's,build/hydra,share/extension/hydra,' -cvjf %PKG_BIN% build

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
