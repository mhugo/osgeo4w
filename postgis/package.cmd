::--------- Package settings --------
:: package name
set P=postgis
:: version
set V=2.3.2
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

set OSGEO4W_HOME=c:\osgeo4w64
%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s http://hekla.oslandia.net/osgeo4w -k -q -P postgres proj4 geos 

::-- Cygwin has its own Perl which won't work, put our perl in front
set PATH=C:\strawberry\perl\bin;%PATH%
::-- Add osgeo4w to the path, we need it to be before strawberry in order to avoid pg_config.exe there
set PATH=c:\osgeo4w64\bin;%PATH%

git clone https://gitlab.com/Oslandia/postgis.git
::wget --progress=bar:force http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz
::tar xzvf postgis-2.3.2.tar.gz
wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz
tar -xvzf proj-4.9.3.tar.gz
cd proj-4.9.3
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake

cd %HERE%

:: copy the config file
cd postgis
git checkout cmake
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake

cd %HERE%

if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

:: make sure the install dir is empty before installing
rd /s /q c:\install
::call install.bat c:\install

:: tar -C c:\install -cjvf %PKG_BIN% bin lib share include

:: TODO split into postgresql-client postgresql-devel postgresql-plpython3u ?

:: source archive
:: tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint config.pl

::--------- Installation
:: call %HERE%\..\inc\install_archives.bat
