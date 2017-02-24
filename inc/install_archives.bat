:: Install generated archives to the release path
scp %PKG_BIN% %PKG_SRC% %R%
cd %HERE%
scp setup.hint %R%
