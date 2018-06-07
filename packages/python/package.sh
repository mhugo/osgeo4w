#!/bin/bash

if [ ! -e python-2.7.15.amd64.msi ]; then
    wget https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi
fi
# will install in C:\Python27
echo "Installing Python binaries ..."
cygstart.exe -w msiexec /i python-2.7.15.amd64.msi /passive

umask 022

set -e

P=xpython
V=2.7.15
B=1

R=release/$P
mkdir -p $R

mkdir -p bin etc/postinstall etc/ini apps/Python27
# copy python27 files
echo "Copying ..."
tar -C /cygdrive/c/Python27 -cf - . | tar -C apps/Python27 -xf -
chmod -R u+rw apps/Python27

rm apps/Python27/DLLs/sqlite3.dll

for p in core help devel test tcltk tools; do
	mkdir -p $R/$P/$P-$p
	cp apps/Python27/LICENSE.txt $R/$P/$P-$p/$P-$p-$V-$B.txt
done

mv apps/Python27/{python,pythonw}.exe bin
cp make-bat-for-py.bat bin
cp ini.bat etc/ini/python-core.bat
cp postinstall.bat etc/postinstall/python-core.bat

echo "Packaging $P-help-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-help/$P-help-$V-$B.tar.bz2 \
	--remove-files \
	apps/Python27/Doc/ \
	apps/Python27/NEWS.txt \
	apps/Python27/README.txt

cat <<EOF >$R/$P/$P-help/setup.hint
sdesc: "Python documentation in a Windows compiled help file"
ldesc: "Python documentation in a Windows compiled help file"
category: Commandline_Utilities
requires: python-core
external-source: python-core
EOF

echo "Packaging $P-devel-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-devel/$P-devel-$V-$B.tar.bz2 \
	--remove-files \
	apps/Python27/include \
	apps/Python27/libs \

cat <<EOF >$R/$P/$P-devel/setup.hint
sdesc: "Python library and header files"
ldesc: "Python library and header files"
category: Libs
requires: python-core
external-source: python-core
EOF

echo "Packaging $P-test-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-test/$P-test-$V-$B.tar.bz2 \
	--remove-files \
	apps/Python27/DLLs/_ctypes_test.pyd \
	apps/Python27/Lib/bsddb/test \
	apps/Python27/Lib/ctypes/test \
	apps/Python27/Lib/email/test \
	apps/Python27/Lib/json/tests \
	apps/Python27/Lib/distutils/tests \
	apps/Python27/Lib/lib-tk/test \
	apps/Python27/Lib/sqlite3/test \
	apps/Python27/Lib/lib2to3/tests \
	apps/Python27/Lib/test \
	apps/Python27/Lib/unittest/test

cat <<EOF >$R/$P/$P-test/setup.hint
sdesc: "Python self tests"
ldesc: "Python self tests"
category: Libs
requires: python-core
external-source: python-core
EOF

echo "Packaging $P-tcltk-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-tcltk/$P-tcltk-$V-$B.tar.bz2 \
	--remove-files \
	apps/Python27/Tools/Scripts/pydocgui.pyw \
	apps/Python27/DLLs/_tkinter.pyd \
	apps/Python27/DLLs/tcl85.dll \
	apps/Python27/DLLs/tclpip85.dll \
	apps/Python27/DLLs/tk85.dll \
	apps/Python27/Lib/idlelib \
	apps/Python27/Lib/lib-tk \
	apps/Python27/tcl

cat <<EOF >$R/$P/$P-tcltk/setup.hint
sdesc: "Python Tkinter and IDLE"
ldesc: "Python Tkinter and IDLE"
category: Commandline_Utilities
requires: python-core
external-source: python-core
EOF

echo "Packaging $P-tools-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-tools/$P-tools-$V-$B.tar.bz2 \
	--remove-files \
	--exclude apps/Python27/Tools/Scripts/pydocgui.pyw \
	apps/Python27/Tools

cat <<EOF >$R/$P/$P-tools/setup.hint
sdesc: "Python Tkinter and IDLE"
ldesc: "Python Tkinter and IDLE"
category: Commandline_Utilities
requires: python-core
external-source: python-core
EOF

echo "Packaging $P-core-$V-$B.tar.bz2 ..."
tar -cjf $R/$P/$P-core/$P-core-$V-$B.tar.bz2 \
	--remove-files \
	--exclude apps/Python27/DLLs/_ctypes_test.pyd \
	--exclude apps/Python27/DLLs/_tkinter.pyd \
	--exclude apps/Python27/DLLs/tcl85.dll \
	--exclude apps/Python27/DLLs/tclpip85.dll \
	--exclude apps/Python27/DLLs/tk85.dll \
	--exclude apps/Python27/Lib/bsddb/test \
	--exclude apps/Python27/Lib/ctypes/test \
	--exclude apps/Python27/Lib/email/test \
	--exclude apps/Python27/Lib/lib-tk/test \
	--exclude apps/Python27/Lib/sqlite3/test \
	--exclude apps/Python27/Lib/lib2to3/tests \
	--exclude apps/Python27/Lib/test \
	--exclude apps/Python27/Lib/unittest/test \
	--exclude apps/Python27/Lib/json/tests \
	--exclude apps/Python27/Lib/distutils/tests \
	--exclude apps/Python27/Lib/idlelib \
	--exclude apps/Python27/Lib/lib-tk \
	--exclude apps/Python27/Tools \
	etc/postinstall/python-core.bat \
	etc/ini/python-core.bat \
	apps/Python27/LICENSE.txt \
	apps/Python27/DLLs \
	apps/Python27/Lib \
	bin/

cat <<EOF >$R/$P/$P-core/setup.hint
sdesc: "Python core interpreter and runtime"
ldesc: "Python core interpreter and runtime"
category: Commandline_Utilities
requires: shell sqlite3
EOF

rm -rf apps etc bin

tar -cjf $R/$P/$P-core/$P-core-$V-$B-src.tar.bz2 ini.bat make-bat-for-py.bat package.sh postinstall.bat

. ../__inc__/deploy_packages.sh $1 x86_64 $(pwd)/$R

