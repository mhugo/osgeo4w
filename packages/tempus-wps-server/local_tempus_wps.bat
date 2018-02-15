@echo off
:: start pglite
pglite start
:: start nginx if not already started
if not exist nginx\logs\nginx.pid (
  start /b %OSGEO4W_ROOT%\apps\nginx\nginx.exe -c conf\tempus.conf -p nginx
  echo "A web server on port 8080 is started"
)
%OSGEO4W_ROOT%\apps\tempus\bin\tempus_wps --data %OSGEO4W_ROOT%\apps\tempus %*
