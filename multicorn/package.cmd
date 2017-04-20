::--------- Package settings --------
:: package name
set P=multicorn
:: version
set V=1.3.3
:: package version
set B=3

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

set OSGEO4W_HOME=c:\osgeo4w64

%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P postgresql

set PYTHONHOME=%OSGEO4W_HOME%\apps\Python36
set PATH=%OSGEO4W_HOME%\apps\Python36;%OSGEO4W_HOME%\apps\Python36\Scripts;%OSGEO4W_HOME%\bin;%PATH%

git clone https://github.com/vmora/Multicorn.git
:: copy the config file
cd Multicorn
git checkout cmake
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake

cd %HERE%

if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

rd /s /q c:\install
mkdir c:\install\lib
mkdir c:\install\share
mkdir c:\install\share\extension

copy Multicorn\build\multicorn.dll c:\install\lib
copy Multicorn\build\multicorn.control c:\install\share\extension
copy Multicorn\build\multicorn--1.3.3.sql c:\install\share\extension

tar -C c:\install -cjvf %PKG_BIN% lib share

if %ERRORLEVEL% NEQ 0 (
   exit /b 1
)

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
