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

mkdir mt3dms
cd mt3dms
wget https://hydro.geo.ua.edu/mt3d/mt3dms_530.exe
unzip mt3dms_530.exe
cd %HERE%

wget https://water.usgs.gov/ogw/mt3d-usgs/mt3d-usgs_1.0.zip
unzip mt3d-usgs_1.0.zip

:: binary archive
tar --transform 's,MF2005.1_12/,,' -cvjf %PKG_BIN% MF2005.1_12/bin
tar --transform 's,mt3dms/,,' -cvjf %PKG_BIN% mt3dms/bin/mt3dms5b.exe %PKG_BIN% mt3dms/bin/mt3dms5s.exe
tar --transform 's,mt3d-usgs_Distribution/,,' -cvjf %PKG_BIN% mt3d-usgs_Distribution/bin/MT3D-USGS_64.exe

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
