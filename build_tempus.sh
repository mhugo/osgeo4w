#!/bin/sh
# build all packages by order of dependencies
for pkg in protobuf tempus-core tempus_wps_server pytempus osm2tempus tempus_loader
do
    cmd /s /c "cd $pkg && package.cmd test"
    # rebuild setup.ini on hekla
    scp genini gen_setup_ini.sh ci@hekla.oslandia.net:~/
    ssh ci@hekla.oslandia.net ./gen_setup_ini.sh test
done
