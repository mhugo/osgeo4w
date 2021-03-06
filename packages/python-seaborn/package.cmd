::--------- Package settings --------
:: package name
set P=python-seaborn
:: version
set V=0.8.1
:: package version
set B=2

set HERE=%CD%

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\etc\ini\python-core.bat

%OSGEO4W_ROOT%\bin\osgeo4w-setup.exe -s %OSGEO4W_REPO% -k -q -P python-core -P python-numpy -P matplotlib -P python-scipy -P python-pandas

pip install seaborn==%V%

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% apps/Python27/Lib/site-packages/seaborn apps/Python27/Lib/site-packages/seaborn-%V%.dist-info 

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
