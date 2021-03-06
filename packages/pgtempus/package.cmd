::--------- Package settings --------
:: package name
set P=pgtempus
:: version
set V=1.2.1
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

:: python3 env
call C:\osgeo4W64\bin\py3_env.bat || goto :error

if "%1"=="test" (
wget -O pgtempus.tar.bz2 https://gitlab.com/Oslandia/pgtempus/repository/master/archive.tar.bz2 || goto :error
) else (
wget -O pgtempus.tar.bz2 https://gitlab.com/Oslandia/pgtempus/repository/archive.tar.bz2?ref=v%V% || goto :error)
tar xjvf pgtempus.tar.bz2 || goto :error
cd pgtempus-* || goto :error

rd /s /q c:\install
mkdir c:\install\share\extension

copy pgext\pgtempus*.* c:\install\share\extension || goto :error

cd ..

tar -C c:\install -cvjf %PKG_BIN% share || goto :error

::--------- Installation
scp %PKG_BIN% %R% || goto :error
scp setup.hint %R% || goto :error
goto :EOF


:error
echo Build failed
exit /b 1
