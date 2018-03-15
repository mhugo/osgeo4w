::--------- Package settings --------
:: package name
set P=qgis-vc14
:: version
set V=2.8.7
:: package version
set B=1
:: build dependencies
set BUILD_DEPS=qt4-vc14-libs qt4-vc14-devel gdal ^
    geos libspatialindex libspatialindex-devel spatialite sqlite3 ^
	qwt-vc14-libs-qt4 qwt-vc14-devel-qt4 python-core python-devel ^
	proj

::--------- Prepare the environment
set HERE=%CD%
call ..\__inc__\prepare_env.bat %1 || goto error

::--------- Build script
if not exist QGIS-final-2_8_7 (
wget https://github.com/qgis/QGIS/archive/final-2_8_7.tar.gz || goto :error
tar xzvf final-2_8_7.tar.gz || goto :error
cd QGIS-final-2_8_7 || goto :error

c:\cygwin64\bin\patch.exe -p0 < ../patch0.patch || goto :error

) else (
cd QGIS-final-2_8_7 || goto :error
)

mkdir build
cd build

set BUILDCONF=RelWithDebInfo
set ARCH=x86_64
set PACKAGENAME=%P%
set PACKAGE=%B%
set VERSION=%V%
set INSTALLDIR=C:\install
set PKGDIR=%INSTALLDIR%\apps\%PACKAGENAME%

:: make sure the install dir is empty before installing
if exist %INSTALLDIR% rd /s /q %INSTALLDIR% || goto :error

mkdir %PKGDIR%

:: cmake
cmake -G "Visual Studio 14 2015 Win64" ^
	-D FLEX_EXECUTABLE=C:/cygwin64/bin/flex.exe ^
	-D BISON_EXECUTABLE=C:/cygwin64/bin/bison.exe ^
    -D CMAKE_INSTALL_PREFIX=%PKGDIR% ^
	-D BUILDNAME="%P%-%V%-%ARCH%" ^
	-D PEDANTIC=TRUE ^
	-D PROJ_LIBRARY=%OSGEO4W_ROOT%/lib/proj_i.lib ^
	-D GDAL_INCLUDE_DIR=%OSGEO4W_ROOT%/include ^
	-D GDAL_LIBRARY=%OSGEO4W_ROOT%/lib/gdal_i.lib ^
	-D GEOS_LIBRARY=%OSGEO4W_ROOT%/lib/geos_c.lib ^
	-D SPATIALITE_LIBRARY=%OSGEO4W_ROOT%/lib/spatialite_i.lib ^
	-D SPATIALINDEX_LIBRARY=%OSGEO4W_ROOT%/lib/spatialindex-64.lib ^
	-D SQLITE3_LIBRARY=%OSGEO4W_ROOT%/lib/sqlite3_i.lib ^
	-D QT_BINARY_DIR=%OSGEO4W_ROOT%/bin ^
	-D QT_LIBRARY_DIR=%OSGEO4W_ROOT%/lib ^
	-D QT_HEADERS_DIR=%OSGEO4W_ROOT%/include/qt4 ^
	-D QWT_INCLUDE_DIR=%OSGEO4W_ROOT%/include/qwt ^
	-D QWT_LIBRARY=%OSGEO4W_ROOT%/lib/qwt-vc14-5.lib ^
	-D PYTHON_EXECUTABLE=%OSGEO4W_ROOT%/bin/python.exe ^
	-D PYTHON_LIBRARY=%OSGEO4W_ROOT%/apps/Python27/libs/python27.lib ^
	-D WITH_QSPATIALITE=TRUE ^
	-D WITH_SERVER=FALSE ^
	-D WITH_GLOBE=FALSE ^
	-D WITH_ORACLE=FALSE ^
	-D WITH_DESKTOP=TRUE ^
	-D WITH_BINDINGS=FALSE ^
	-D WITH_CUSTOM_WIDGETS=TRUE ^
	-D CMAKE_BUILD_TYPE=%BUILDCONF% ^
	-D CMAKE_CONFIGURATION_TYPES=%BUILDCONF% ^
	-D CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS=TRUE ^
	-D CMAKE_CXX_FLAGS="/DWIN32 /D_WINDOWS /W3 /GR /EHsc /Dfinite=_finite" ^
    -D CMAKE_CXX_FLAGS_RELEASE="/MD /MP /O2 /Ob2 /D NDEBUG" ^
	-D CMAKE_CXX_FLAGS_RELWITHDEBINFO="/MD /Zi /MP /Od /D NDEBUG /D QGISDEBUG" ^
	-D CMAKE_PDB_OUTPUT_DIRECTORY_RELWITHDEBINFO=%PKGDIR%/pdb ^
	.. || goto :error

cmake --build %CD% --config %BUILDCONF% || goto error

cmake --build %CD% --target install --config %BUILDCONF% || goto error

mkdir %INSTALLDIR%\bin
mkdir %INSTALLDIR%\etc\postinstall
mkdir %INSTALLDIR%\etc\preremove

cd ..\ms-windows\osgeo4w

::-- reusing package.cmd file from QGIS from now
:: (with OSGEO4W_ROOT replaced by INSTALLDIR)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' postinstall-common.bat >%INSTALLDIR%\etc\postinstall\%PACKAGENAME%-common.bat
if errorlevel 1 (echo creation of common postinstall failed & goto error)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' postinstall-desktop.bat >%INSTALLDIR%\etc\postinstall\%PACKAGENAME%.bat
if errorlevel 1 (echo creation of desktop postinstall failed & goto error)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' preremove-desktop.bat >%INSTALLDIR%\etc\preremove\%PACKAGENAME%.bat
if errorlevel 1 (echo creation of desktop preremove failed & goto error)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' qgis.bat.tmpl >%INSTALLDIR%\bin\%PACKAGENAME%.bat.tmpl
if errorlevel 1 (echo creation of desktop template failed & goto error)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' browser.bat.tmpl >%INSTALLDIR%\bin\%PACKAGENAME%-browser.bat.tmpl
if errorlevel 1 (echo creation of browser template & goto error)

::sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' designer.bat.tmpl >%INSTALLDIR%\bin\%PACKAGENAME%-designer.bat.tmpl
::if errorlevel 1 (echo creation of designer template failed & goto error)

::sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' python.bat.tmpl >%INSTALLDIR%\bin\python-%PACKAGENAME%.bat.tmpl
::if errorlevel 1 (echo creation of python wrapper template failed & goto error)

sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' qgis.reg.tmpl >%PKGDIR%\bin\qgis.reg.tmpl
if errorlevel 1 (echo creation of registry template & goto error)

::sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' postinstall-server.bat >%INSTALLDIR%\etc\postinstall\%PACKAGENAME%-server.bat
::if errorlevel 1 (echo creation of server postinstall failed & goto error)

::sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' preremove-server.bat >%INSTALLDIR%\etc\preremove\%PACKAGENAME%-server.bat
::if errorlevel 1 (echo creation of server preremove failed & goto error)

::if not exist %INSTALLDIR%\httpd.d mkdir %INSTALLDIR%\httpd.d
::sed -e 's/@package@/%PACKAGENAME%/g' -e 's/@version@/%VERSION%/g' httpd.conf.tmpl >%INSTALLDIR%\httpd.d\httpd_%PACKAGENAME%.conf.tmpl
::if errorlevel 1 (echo creation of httpd.conf template failed & goto error)

set packages="" "-common" "-devel"

touch exclude

for %%i in (%packages%) do (
	if not exist %ARCH%\release\qgis\%PACKAGENAME%%%i mkdir %ARCH%\release\qgis\%PACKAGENAME%%%i
)

tar -C %INSTALLDIR% -cjf %ARCH%/release/qgis/%PACKAGENAME%-common/%PACKAGENAME%-common-%VERSION%-%PACKAGE%.tar.bz2 ^
	--exclude-from exclude ^
	--exclude "*.pyc" ^
	"apps/%PACKAGENAME%/bin/qgis_analysis.dll" ^
	"apps/%PACKAGENAME%/bin/qgis_networkanalysis.dll" ^
	"apps/%PACKAGENAME%/bin/qgis_core.dll" ^
	"apps/%PACKAGENAME%/bin/qgis_gui.dll" ^
	"apps/%PACKAGENAME%/doc/" ^
	"apps/%PACKAGENAME%/plugins/delimitedtextprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/gdalprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/gpxprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/memoryprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/mssqlprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/ogrprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/owsprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/postgresprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/spatialiteprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/wcsprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/wfsprovider.dll" ^
	"apps/%PACKAGENAME%/plugins/wmsprovider.dll" ^
	"apps/%PACKAGENAME%/resources/qgis.db" ^
	"apps/%PACKAGENAME%/resources/spatialite.db" ^
	"apps/%PACKAGENAME%/resources/srs.db" ^
	"apps/%PACKAGENAME%/resources/symbology-ng-style.db" ^
	"apps/%PACKAGENAME%/resources/cpt-city-qgis-min/" ^
	"apps/%PACKAGENAME%/svg/" ^
	"apps/%PACKAGENAME%/crssync.exe" ^
	"etc/postinstall/%PACKAGENAME%-common.bat"	
if errorlevel 1 (echo tar common failed & goto error)

::tar -C %INSTALLDIR% -cjf %ARCH%/release/qgis/%PACKAGENAME%-server/%PACKAGENAME%-server-%VERSION%-%PACKAGE%.tar.bz2 ^
::	--exclude-from exclude ^
::	--exclude "*.pyc" ^
::	"apps/%PACKAGENAME%/bin/qgis_mapserv.fcgi.exe" ^
::	"apps/%PACKAGENAME%/bin/qgis_server.dll" ^
::	"apps/%PACKAGENAME%/bin/admin.sld" ^
::	"apps/%PACKAGENAME%/bin/wms_metadata.xml" ^
::	"apps/%PACKAGENAME%/bin/schemaExtension.xsd" ^
::	"apps/%PACKAGENAME%/python/qgis/_server.pyd" ^
::	"apps/%PACKAGENAME%/python/qgis/_server.lib" ^
::	"apps/%PACKAGENAME%/python/qgis/server/" ^
::	"httpd.d/httpd_%PACKAGENAME%.conf.tmpl" ^
::	"etc/postinstall/%PACKAGENAME%-server.bat" ^
::	"etc/preremove/%PACKAGENAME%-server.bat"
::if errorlevel 1 (echo tar server failed & goto error)

move %PKGDIR%\bin\qgis.exe %INSTALLDIR%\bin\%PACKAGENAME%-bin.exe
if errorlevel 1 (echo move of desktop executable failed & goto error)
move %PKGDIR%\bin\qbrowser.exe %INSTALLDIR%\bin\%PACKAGENAME%-browser-bin.exe
if errorlevel 1 (echo move of browser executable failed & goto error)

::if not exist %PKGDIR%\qtplugins\sqldrivers mkdir %PKGDIR%\qtplugins\sqldrivers
::move %INSTALLDIR%\apps\qt4\plugins\sqldrivers\qsqlocispatial.dll %PKGDIR%\qtplugins\sqldrivers
::if errorlevel 1 (echo move of oci sqldriver failed & goto error)
::move %INSTALLDIR%\apps\qt4\plugins\sqldrivers\qsqlspatialite.dll %PKGDIR%\qtplugins\sqldrivers
::if errorlevel 1 (echo move of spatialite sqldriver failed & goto error)

::if not exist %PKGDIR%\qtplugins\designer mkdir %PKGDIR%\qtplugins\designer
::move %INSTALLDIR%\apps\qt4\plugins\designer\qgis_customwidgets.dll %PKGDIR%\qtplugins\designer
::if errorlevel 1 (echo move of customwidgets failed & goto error)

::if not exist %PKGDIR%\python\PyQt4\uic\widget-plugins mkdir %PKGDIR%\python\PyQt4\uic\widget-plugins
::move %INSTALLDIR%\apps\Python27\Lib\site-packages\PyQt4\uic\widget-plugins\qgis_customwidgets.py %PKGDIR%\python\PyQt4\uic\widget-plugins
::if errorlevel 1 (echo move of customwidgets binding failed & goto error)

if not exist %ARCH%\release\qgis\%PACKAGENAME% mkdir %ARCH%\release\qgis\%PACKAGENAME%
tar -C %INSTALLDIR% -cjf %ARCH%/release/qgis/%PACKAGENAME%/%PACKAGENAME%-%VERSION%-%PACKAGE%.tar.bz2 ^
	--exclude-from exclude ^
	--exclude "*.pyc" ^
	--exclude "apps/%PACKAGENAME%/python/qgis/_server.pyd" ^
	--exclude "apps/%PACKAGENAME%/python/qgis/_server.lib" ^
	--exclude "apps/%PACKAGENAME%/python/qgis/server/" ^
	"bin/%PACKAGENAME%-browser-bin.exe" ^
	"bin/%PACKAGENAME%-bin.exe" ^
	"apps/%PACKAGENAME%/bin/qgis.reg.tmpl" ^
	"apps/%PACKAGENAME%/i18n/" ^
	"apps/%PACKAGENAME%/icons/" ^
	"apps/%PACKAGENAME%/images/" ^
	"apps/%PACKAGENAME%/plugins/coordinatecaptureplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/dxf2shpconverterplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/evis.dll" ^
	"apps/%PACKAGENAME%/plugins/gpsimporterplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/heatmapplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/interpolationplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/offlineeditingplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/oracleplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/rasterterrainplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/roadgraphplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/spatialqueryplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/spitplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/topolplugin.dll" ^
	"apps/%PACKAGENAME%/plugins/zonalstatisticsplugin.dll" ^
	"apps/%PACKAGENAME%/qgis_help.exe" ^
	"apps/%PACKAGENAME%/resources/customization.xml" ^
	"bin/%PACKAGENAME%.bat.tmpl" ^
	"bin/%PACKAGENAME%-browser.bat.tmpl" ^
	"etc/postinstall/%PACKAGENAME%.bat" ^
	"etc/preremove/%PACKAGENAME%.bat"	
if errorlevel 1 (echo tar desktop failed & goto error)


tar -C %INSTALLDIR% -cjf %ARCH%/release/qgis/%PACKAGENAME%-devel/%PACKAGENAME%-devel-%VERSION%-%PACKAGE%.tar.bz2 ^
	--exclude-from exclude ^
	--exclude "*.pyc" ^
	"apps/%PACKAGENAME%/FindQGIS.cmake" ^
	"apps/%PACKAGENAME%/include/" ^
	"apps/%PACKAGENAME%/lib/"
if errorlevel 1 (echo tar devel failed & goto error)

if not exist %ARCH%\release\qgis\%PACKAGENAME%-pdb mkdir %ARCH%\release\qgis\%PACKAGENAME%-pdb
tar -C %INSTALLDIR% -cjf %ARCH%/release/qgis/%PACKAGENAME%-pdb/%PACKAGENAME%-pdb-%VERSION%-%PACKAGE%.tar.bz2 ^
	apps/%PACKAGENAME%/pdb
if errorlevel 1 (echo tar pdb failed & goto error)

:: -- copy setup.hint
copy ..\..\..\setup.hint  %ARCH%\release\qgis\%PACKAGENAME%\setup.hint
copy ..\..\..\devel.hint  %ARCH%\release\qgis\%PACKAGENAME%-devel\setup.hint
copy ..\..\..\common.hint  %ARCH%\release\qgis\%PACKAGENAME%-common\setup.hint
copy ..\..\..\pdb.hint  %ARCH%\release\qgis\%PACKAGENAME%-pdb\setup.hint
set R=%CD%\%ARCH%\release

:: -- copy packages
cd %HERE%
call ..\__inc__\deploy_packages.bat %1 %ARCH% %R% || goto error

goto :EOF

:error
echo Build failed
exit /b 1
