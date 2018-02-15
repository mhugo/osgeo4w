::--------- Package settings --------
:: package name
set P=python3-shapely
:: version
set V=1.5.17
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
call %OSGEO4W_ROOT%\bin\py3_env.bat
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

chcp 65001
set GEOS_LIBRARY_PATH=%OSGEO4W_ROOT%\bin\geos_c.dll
python3 -m pip install shapely==1.5.17

:: need to replace geo.dll by geos_c.dll in package
sed -i s/geos.dll/geos_c.dll/g %PYTHONHOME%/Lib/site-packages/shapely/geos.py

:: binary archive
tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/shapely

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
