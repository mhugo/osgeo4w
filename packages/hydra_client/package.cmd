::--------- Package settings --------
:: package name
set P=hydra_client
:: version
set V=0.0.23
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1


:: binary archive
tar --transform 's,postinstall.bat,etc/postinstall/hydra_client.bat,' -cvjf %PKG_BIN% postinstall.bat

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
