::--------- Package settings --------
:: package name
set P=txt2tags
:: version
set V=2.6
:: package version
set B=1

call ..\__inc__\prepare_env.bat %1 || goto error

wget https://raw.githubusercontent.com/txt2tags/txt2tags/2.6/txt2tags -O bin/txt2tags.py || goto error

tar -cjvf %PKG_BIN% etc bin

call ..\__inc__\install_archives.bat %1 || goto error

goto :EOF

:error
echo Build failed
exit /b /1

