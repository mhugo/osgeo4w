::--------- Package settings --------
:: package name
set P=boost
:: version
set V=1.63.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

wget --progress=bar:force https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.bz2
tar xjvf boost-1.63.0.tar.bz2

cd boost-1.63.0
call bootstrap.bat --with-python=C:\osgeo4W64\apps\python36
call b2.bat --with-python

