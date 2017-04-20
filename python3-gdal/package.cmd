::--------- Package settings --------
:: package name
set P=python3-gdal
:: version
set V=2.1.3
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
call %OSGEO4W_ROOT%\bin\py3_env.bat
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

python3 -m pip uninstall -y gdal
python3 -m pip install numpy
python3 -m pip install  --global-option=build_ext --global-option="-Ic:\OSGeo4W64\include" --global-option="-Lc:\OSGeo4W64\lib" gdal==2.1.3

:: binary archive
tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python36/Lib/site-packages/osgeo

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
