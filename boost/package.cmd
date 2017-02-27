::--------- Package settings --------
:: package name
set P=boost
:: version
set V=1.63.0
:: package version
set B=1

::--------- Prepare the environment
call ..\inc\prepare_env.bat

wget --progress=bar:force https://github.com/boostorg/boost/archive/boost-1.63.0.zip
unzip boost-1.63.0.zip

cd boost-1.63.0
call bootstrap.bat --with-python=C:\osgeo4W64\apps\python36
call b2.bat --with-python

