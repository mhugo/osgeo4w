::--------- Package settings --------
:: package name
set P=tempus-test-data
:: version
set V=2.5.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

wget --progress=bar:force https://gitlab.com/Oslandia/tempus_core/raw/v%V%/test_data/tempus_test_db.sql.zip || goto :error

unzip tempus_test_db.sql.zip

tar --transform 's,^,apps/tempus/data' -cvjf %PKG_BIN% tempus_test_db.sql

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
scp %PKG_BIN% %PKG_SRC% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

