::--------- Package settings --------
:: package name
set P=python3-gtfslib
:: version
set V=1.0.1
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
call ..\inc\prepare_env.bat %1
set OSGEO4W_ROOT=c:\osgeo4w64
set PATH=%OSGEO4W_ROOT%\bin;%PATH%

:: python2 package
call %OSGEO4W_ROOT%\bin\py3_env.bat

python3 -m pip install gtfslib

copy /Y converter.py %OSGEO4W_ROOT%\apps\python36\lib\site-packages\gtfslib\converter.py || goto :error

tar -C %OSGEO4W_ROOT% -cvjf %PKG_BIN% ^
 apps/Python36/Lib/site-packages/gtfslib ^
 apps/Python36/Lib/site-packages/gtfslib-1.0.0.dist-info ^
 apps/Python36/Scripts/gtfsdbloader.exe ^
 apps/Python36/Scripts/gtfsrun.exe ^
 || goto :error

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
