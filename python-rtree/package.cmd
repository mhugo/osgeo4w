::--------- Package settings --------
:: package name
set P=python-rtree
:: version
set V=0.8.3
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

pip install rtree==%V%

sed -i s/spatialindex_c.dll/spatialindex_c-64.dll/g %PYTHONHOME%/Lib/site-packages/rtree/core.py


tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/rtree

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
