::--------- Package settings --------
:: package name
set P=python3-pilow
:: version
set V=4.0.0
:: package version
set B=1

set HERE=%CD%

::--------- Prepare the environment
set OSGEO4W_HOME=c:\osgeo4w64
call ..\inc\prepare_env.bat %1
call %OSGEO4W_HOME%\bin\o4w_env.bat
set PYTHONHOME=%OSGEO4W_HOME%\apps\Python36

python3 -m pip install pillow==4.0.0

:: binary archive
tar --transform 's,%OSGEO4W_HOME%,,' -cvjf %PKG_BIN% %PYTHONHOME%/site-packages/PIL

::--------- Installation
scp %PKG_BIN% %R%
cd %HERE%
scp setup.hint %R%
