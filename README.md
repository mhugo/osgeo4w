Oslandia's OSGEO4W distribution
===============================

This repository hosts sources for the generation of OSGEO4W packages.

They are designed to be run on our Windows build environment through gitlab-ci.

Directory structure:
--------------------

To add a package script, add a new subdirectory and put at least the following files in it:
- package.cmd: the Windows "shell" script that will be triggered to compile the package. Have a look at [some existing package script](packages/protobuf/package.cmd).
- setup.hint: this is the Cygwin/OSGEO4W definition of the package that will be read by some script to generate a setup.ini file used by osgeo4w installers

The [include directory](packages/__inc__) contains common batch files that should ease the writing of package.cmd scripts

Package building:
-----------------

To launch the building of a package, in `scripts` run `trigger_build.sh` following by the name (directory name) of the package to build and the build type (release or test), e.g. `trigger_build.sh pytempus test`

This will trigger gitlab-ci and build this package on our Windows box. If you correctly called [install_archives.bat](packages/__inc__/install_archives.bat), packages should have been uploaded to our "hekla" internal server (in /home/storage/osgeo4w).

They will be available upon completion on http://hekla.oslandia.net/osgeo4w.test (for the test target) or http://hekla.oslandia.net/osgeo4w (for the release target)

A cron job will make them available on http://osgeo4w-oslandia.com/extra periodically (every 6 hours).

OSGEO4W Setup
-------------

When using an OSGEO4W setup, point it to http://osgeo4w-oslandia.com/mirror if you want to only use a mirror of the official distribution. Point it to
http://osgeo4w-oslandia.com/extra if you want to benefit from the extra packages found here.

You can also call from the command line
```
osgeo4w-setup.exe -O -s http://osgeo4w-oslandia.com/extra
```

Custom Setup
------------

A better option is to wrap the previous command line in a standalone .exe file. Have a look at the [make_setup_exe](make_setup_exe/) folder.

Setup.ini overloading
---------------------

For information, the setup.ini file is generated by overloading the official found in OSGEO4W distribution

Hekla's webserver is configured to resolve any non existing file to osgeo.org with the following rule:

```
<Directory "/var/www/html/osgeo4w">
RewriteEngine on
RewriteCond %{REQUEST_URI} !index.html
RewriteCond /home/storage/%{REQUEST_URI} !-f
RewriteCond /home/storage/%{REQUEST_URI} !-d
RewriteRule "^(.+)" "http://download.osgeo.org/osgeo4w/$1" [P]
</Directory>
```

Notes:
* [P] for Proxy, i.e. not an HTTP redirect, hekla acts as a proxy. Seems to resolve problems with osgeo4w installer when using an http proxy
* RewriteCond %{REQUEST_URI} !index.html needed to keep Apache generate directory indexes of directories

