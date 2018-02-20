::--------- Package settings --------
:: package name
set P=qscintilla
:: version
set V=2.7.2
:: package version
set B=1

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

::--------- Build script
wget --progress=bar:force --output-document=QScintilla-gpl-2.7.2.zip https://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-2.7.2/QScintilla-gpl-2.7.2.zip/download || goto :error
unzip -q QScintilla-gpl-2.7.2.zip || goto :error

cd QScintilla-gpl-2.7.2/Qt4Qt5

:: make sure the install dir is empty before installing
rd /s /q c:\install
set INSTALL_ROOT=\install

qmake
nmake
nmake install

:: binary archive
tar -C c:\install -cvjf %PKG_BIN% Qt || goto :error

:: source archive
tar -C %HERE% --transform 's,^,osgeo4w/,' -cvjf %PKG_SRC% package.cmd setup.hint || goto :error

::--------- Installation
call %HERE%\..\__inc__\install_archives.bat || goto :error
goto :EOF

:error
echo Build failed
exit /b 1

