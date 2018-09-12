::--------- Package settings --------
:: package name
set P=osm2tempus
:: version
set V=1.1.1
:: package version
set B=2
:: dependencies
set BUILD_DEPS=tempus-core boost-devel-vc14 zlib protobuf libpq

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

wget --progress=bar:force https://gitlab.com/Oslandia/osm2tempus/repository/archive.tar.bz2?ref=v%V% -O osm2tempus.tar.bz2 || goto :error
tar xjf osm2tempus.tar.bz2
cd osm2tempus-*
call ci\windows\build_gitlab.bat || goto :error

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\__inc__\install_archives.bat || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
