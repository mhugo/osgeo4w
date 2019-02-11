::--------- Package settings --------
:: package name
set P=postgresql
:: version
set V=9.6.2
:: package version
set B=1
:: build dependencies
set BUILD_DEPS=python3-devel

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

::-- Cygwin has its own Perl which won't work, put our perl in front
set PATH=C:\strawberry\perl\bin;%PATH%
::-- Add python to the path
set PATH=%PATH%;c:\osgeo4w64\bin

wget --progress=bar:force https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.bz2 || goto :error
tar xjvf postgresql-9.6.2.tar.bz2 || goto :error

:: copy the config file
copy config.pl postgresql-9.6.2\src\tools\msvc
set HERE=%CD%
cd postgresql-9.6.2\src\tools\msvc
call c:\osgeo4w64\bin\py3_env.bat || goto :error
call build.bat || goto :error

:: make sure the install dir is empty before installing
rd /s /q c:\install
call install.bat c:\install || goto :error

tar -C c:\install -cjvf %PKG_BIN% bin lib share include || goto :error

:: TODO split into postgresql-client postgresql-devel postgresql-plpython3u ?

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint config.pl || goto :error

::--------- Installation
call %HERE%\..\__inc__\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

