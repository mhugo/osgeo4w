::--------- Package settings --------
:: package name
set P=qwt-vc14
:: version
set V=5.2.3
:: package version
set B=1
:: build dependencies
set BUILD_DEPS=qt4-vc14-libs qt4-vc14-devel

::--------- Prepare the environment
call ..\__inc__\prepare_env.bat %1

if exist out rd /s /q out
mkdir out
set R=out

for %%i in (libs devel) do (
        if not exist %R%\%P%-%%i-qt4 mkdir %R%\%P%-%%i-qt4
        copy %%i.hint %R%\%P%-%%i-qt4\setup.hint
)

::-- download
if not exist qwt-5.2.3 (
wget https://sourceforge.net/projects/qwt/files/qwt/5.2.3/qwt-5.2.3.zip/download -O qwt-5.2.3.zip || goto :error
unzip qwt-5.2.3.zip || goto :error
c:\cygwin64\bin\patch.exe -p0 < qwt.patch || goto :error
)

cd qwt-5.2.3

:: -- compilation
qmake qwt.pro || goto :error
nmake || goto :error
if exist c:\qwt-5.2.3 rd /s /q c:\qwt-5.2.3
nmake install || goto :error

cd ..

:: -- packaging
set HERE=%CD%
cd c:\qwt-5.2.3
mkdir bin
move lib\*.dll bin
mkdir include\qwt
move include\*.h include\qwt
cd %HERE%

tar -cvjf %R%\%P%-libs-qt4\%P%-libs-qt4-%V%-%B%-src.tar.bz2 package.cmd devel.hint libs.hint qwt.patch
tar -C c:/qwt-5.2.3 -cvjf %R%\%P%-libs-qt4\%P%-libs-qt4-%V%-%B%.tar.bz2 bin
tar -C c:/qwt-5.2.3 -cvjf %R%\%P%-devel-qt4\%P%-devel-qt4-%V%-%B%.tar.bz2 include lib

scp -r out/* %RELEASE_HOST%:%RELEASE_PATH%

goto :EOF

:error
echo Build failed
exit /b 1
