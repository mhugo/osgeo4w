This directory contains some scripts useful for compiling OSGeo4W packages.

- `update_public_site.sh`: this is used to mirror the main OSGeo4W download
  site.

- `genini` / `gen_setup_ini.sh`: script used to update the "setup.ini" file
  of a download site. Used by the previous mirroring script
  
- `trigger_build.sh`: script to use to launch a new compilation. See above for
  detailed explanations.

How to trigger a build ?
------------------------

OSGeo4W builds need to access the gitlab CI's pipelines we have set up. This is
available through a "pipeline trigger token" that you should ask for.

You will also need an "API token" on the gitlab project.

The `trigger_bulid.sh` is the main entry point to launch the compilation of a
package. It will look for a configuration file where your private tokens are set.
Have a look a the [config.sample](config.sample) file for an example.

In addition to the configuration, this script takes as parameters the name of the
package to build (the name of the directory in `packages`) as well as the name
of the delivery target (`test` or `release`).

Have a look at the options available with the `--help` switch on the command line.
