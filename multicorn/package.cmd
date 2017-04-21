::--------- Package settings --------
:: package name
set P=multicorn
:: version
set V=1.3.3
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1

set OSGEO4W_HOME=c:\osgeo4w64

%OSGEO4W_HOME%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P postgresql

set PYTHONHOME=%OSGEO4W_HOME%\apps\Python36
set PATH=%OSGEO4W_HOME%\apps\Python36;%OSGEO4W_HOME%\apps\Python36\Scripts;%OSGEO4W_HOME%\bin;%PATH%

rd /s /q Multicorn
git clone --depth 1 --branch cmake https://github.com/vmora/Multicorn.git || goto :error
:: copy the config file
cd Multicorn
mkdir build
cd build
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo .. || goto :error
nmake || goto :error

cd %HERE%

rd /s /q c:\install
mkdir c:\install\lib
mkdir c:\install\share
mkdir c:\install\share\extension

copy Multicorn\build\multicorn.dll c:\install\lib || goto :error
copy Multicorn\build\multicorn.pdb c:\install\lib || goto :error
copy Multicorn\build\multicorn.control c:\install\share\extension || goto :error
copy Multicorn\build\multicorn--1.3.3.sql c:\install\share\extension || goto :error

tar -C c:\install -cjvf %PKG_BIN% lib share || goto :error


::--------- Installation
scp %PKG_BIN% %R% || goto :error
cd %HERE%
scp setup.hint %R% || goto :error

goto :EOF

:error
echo Build failed
exit /b 1
