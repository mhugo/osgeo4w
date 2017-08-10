::--------- Package settings --------
:: package name
set P=freewat
:: version
set V=0.5
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

:: create an empty archive since this is a meta package (dependencies only)
copy empty.tar.bz2 %PKG_BIN%

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
