::--------- Package settings --------
:: package name
set P=qt4-vc14
:: version
set V=4.8.7
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

::--------- Build script
git clone git://code.qt.io/qt/qt.git || goto :error
cd qt
git checkout 4.8

:: patchs
%HOME%\setup-x86_64.exe -s http://cygwin.mirror.constant.com -W -q -P patch
cp ../patch.diff .
c:\cygwin64\bin\patch -p1 < patch.diff || goto :error

:: make sure the install dir is empty before installing
rd /s /q c:\install

configure -opensource -confirm-license -nomake examples -platform win32-msvc2015 -no-accessibility -webkit -no-qt3support -nomake demos -nomake tests -prefix "C:/install"
nmake
nmake install

cd ..

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

call qt4-vc14-libs\package.cmd %1 %PKG_SRC%
call qt4-vc14-devel\package.cmd %1 %PKG_SRC%
goto :EOF

:error
echo Build failed
exit /b 1

