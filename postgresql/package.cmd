::--------- Package settings --------
:: package name
set P=postgresql
:: version
set V=9.6.2
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

::-- Cygwin has its own Perl which won't work, put our perl in front
set PATH=C:\strawberry\perl\bin;%PATH%
::-- Add python to the path
set PATH=%PATH%;c:\osgeo4w64\bin

wget --progress=bar:force https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.bz2
tar xjvf postgresql-9.6.2.tar.bz2

:: copy the config file
copy config.pl postgresql-9.6.2\src\tools\msvc
set HERE=%CD%
cd postgresql-9.6.2\src\tools\msvc
build
if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: make sure the install dir is empty before installing
rd /s /q c:\install
install c:\install

tar -C c:\install -cjvf %PKG_BIN% bin lib share include

:: TODO split into postgresql-client postgresql-devel postgresql-plpython3u ?

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint config.pl

::--------- Installation
call %HERE%\..\inc\install_archives.bat

