::--------- Package settings --------
:: package name
set P=pgtempus
:: version
set V=1.0.1
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

:: python3 env
call C:\osgeo4W64\bin\py3_env.bat || goto :error

wget -O pgtempus.tar.bz2 https://gitlab.com/Oslandia/pgtempus/repository/archive.tar.bz2?ref=v%V% || goto :error
tar xjvf pgtempus.tar.bz2 || goto :error
cd pgtempus-* || goto :error

rd /s /q c:\install
mkdir c:\install\share\extension
mkdir c:\install\apps\Python36\Lib\site-packages\pgtempus
mkdir c:\install\etc\postinstall

copy pgtempus\*.* c:\install\apps\Python36\Lib\site-packages\pgtempus || goto :error
copy pgext\pgtempus*.* c:\install\share\extension || goto :error

cd ..

copy set_tempus_plugins_dir.bat c:\install\etc\postinstall

tar -C c:\install -cvjf %PKG_BIN% apps share etc || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
