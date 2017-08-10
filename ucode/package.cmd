::--------- Package settings --------
:: package name
set P=ucode
:: version
set V=2014
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

wget http://igwmc.mines.edu/freeware/ucode/ucode_2014_1.004.exe
unzip ucode_2014_1.004.exe

:: binary archive
tar --transform 's,ucode_2014_1.004_and_more/ucode_2014_1.004/,,' -cvjf %PKG_BIN% ucode_2014_1.004_and_more/ucode_2014_1.004/bin/ucode_2014.exe 
tar --transform 's,ucode_2014_1.004_and_more/opr-ppr_1.01/BIN/,bin/,' -Avjf %PKG_BIN% ucode_2014_1.004_and_more/opr-ppr_1.01/BIN/opr-ppr.exe
tar --transform 's,ucode_2014_1.004_and_more/sim_adjust_1.000/,,' -cAjf %PKG_BIN% ucode_2014_1.004_and_more/sim_adjust_1.000/bin/sim_adjust.exe

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
