::--------- Package settings --------
:: package name
set P=ucode
:: version
set V=2014
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

wget http://igwmc.mines.edu/freeware/ucode/ucode_2014_1.004.exe
unzip ucode_2014_1.004.exe

:: binary archive
tar --transform 's,ucode_2014_1.004_and_more/ucode_2014_1.004/,,' -cvf tmp.tar ucode_2014_1.004_and_more/ucode_2014_1.004/bin/ucode_2014.exe 
tar --transform 's,ucode_2014_1.004_and_more/opr-ppr_1.01/BIN/,bin/,' -rvf tmp.tar ucode_2014_1.004_and_more/opr-ppr_1.01/BIN/opr-ppr.exe
tar --transform 's,ucode_2014_1.004_and_more/sim_adjust_1.000/,,' -rvf tmp.tar ucode_2014_1.004_and_more/sim_adjust_1.000/bin/sim_adjust.exe
bzip2 -c tmp.tar > %PKG_BIN%

tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint 

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
