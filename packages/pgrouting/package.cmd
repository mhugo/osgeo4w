::--------- Package settings --------
:: package name
set P=pgrouting
:: version
set V=2.3
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

set A=postgis-bundle-pg96-2.3.2x64
wget http://download.osgeo.org/postgis/windows/pg96/%A%.zip || goto :error
unzip %A%.zip || goto :error
tar -C %A% -cjvf %PKG_BIN% ^
 share/extension/pgrouting--2.3.1--2.3.2.sql ^
 share/extension/pgrouting--2.3.0--2.3.2.sql ^
 share/extension/pgrouting--2.1.0--2.3.2.sql ^
 share/extension/pgrouting--2.2.1--2.3.2.sql ^
 share/extension/pgrouting--2.2.4--2.3.2.sql ^
 share/extension/pgrouting--2.3.2.sql ^
 share/extension/pgrouting.control ^
 share/extension/pgrouting--2.0.0--2.3.2.sql ^
 share/extension/pgrouting--2.2.3--2.3.2.sql ^
 share/extension/pgrouting--2.0.1--2.3.2.sql ^
 share/extension/pgrouting--2.2.0--2.3.2.sql ^
 share/extension/pgrouting--2.2.2--2.3.2.sql ^
 lib/libpgrouting-2.3.dll ^
 bin/libstdc++-6.dll ^
 bin/libgcc_s_seh-1.dll || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
