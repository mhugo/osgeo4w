::--------- Package settings --------
:: package name
set P=osm2tempus
:: version
set V=1.1.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P tempus-core -P boost-devel-vc14 -P protobuf || goto :error
wget --progress=bar:force https://gitlab.com/Oslandia/osm2tempus/repository/archive.tar.bz2?ref=v%V% -O osm2tempus.tar.bz2 || goto :error
tar xjf osm2tempus.tar.bz2
cd osm2tempus-*
call ci\windows\build_gitlab.bat || goto :error

:: binary archive
tar --transform 's,install,apps/tempus,' -cvjf %PKG_BIN% install || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
