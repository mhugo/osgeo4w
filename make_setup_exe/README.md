Generation of a setup.exe
=========================

This folder contains a bash script that allows to generate a setup.exe for Windows that will
- use the OSGEO4W installer
- get the package list from hekla.oslandia.net
- automatically install a preselected list of packages

This is done thanks to [7-Zip SFX module](https://sevenzip.osdn.jp/chm/cmdline/switches/sfx.htm):

Example of invocation:
```
./make_setup_exe.sh -n postgresql -v 9.6.0-1 -p postgresql
```

This will create a `setup-postgresql-9.6.0-1.exe` file ready to be installed on Windows.

