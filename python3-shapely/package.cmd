::--------- Package settings --------
:: package name
set P=python3-shapely
:: version
set V=1.5.17
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
set OSGEO4W_HOME=c:\osgeo4w64
call ..\inc\prepare_env.bat %1
call %OSGEO4W_HOME%\bin\o4w_env.bat
set PYTHONHOME=%OSGEO4W_HOME%\apps\Python36

chcp 65001
set GEOS_LIBRARY_PATH=%OSGEO4W_HOME%\bin\geos_c.dll
python3 -m pip install shapely==1.5.17

:: need to replace geo.dll by geos_c.dll in package
python3 -c 'print open("%PYTHONHOME%/site-packages/shapely/geos.py").read().replace("geos.dll","geos_c.dll")'

:: binary archive
tar --transform 's,%OSGEO4W_HOME%,,' -cvjf %PKG_BIN% %PYTHONHOME%/site-packages/shapely

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
