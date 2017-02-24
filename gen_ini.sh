./genini --arch x86_64 --recursive --output=x86_64/setup.ini x86_64
rm -f x86_64/setup.ini.bz2
bzip2 -k x86_64/setup.ini
