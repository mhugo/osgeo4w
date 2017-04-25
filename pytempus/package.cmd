::--------- Package settings --------
:: package name
set P=python3-pytempus
:: version
set V=1.0.2
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

c:\osgeo4w64\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P tempus-core -P boost-devel || goto :error
wget --progress=bar:force https://gitlab.com/Oslandia/pytempus/repository/archive.tar.bz2?ref=master -O pytempus.tar.bz2 || goto :error
tar xjf pytempus.tar.bz2
cd pytempus-*
call ci\windows\build_gitlab.bat || goto :error

:: binary archive
tar -C %HERE%/pytempus-* --transform 's,^,apps/python36/Lib/site-packages/,' -cjvf %PKG_BIN% pytempus.cp36-win_amd64.pyd || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\inc\install_archives.bat || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
