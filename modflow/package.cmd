::--------- Package settings --------
:: package name
set P=modflow
:: version
set V=1.12.00
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

wget https://water.usgs.gov/ogw/modflow/MODFLOW-2005_v1.12.00/MF2005.1_12.zip
unzip MF2005.1_12.zip

:: binary archive
tar --transform 's,MF2005.1_12/,,' -cvjf %PKG_BIN% MF2005.1_12/bin

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
