from __future__ import print_function

def read_requires(fn):
    requires = {}

    requirements = []
    pkg_name = None
    pkg_path = None
    with open(fn) as fi:
        for line in fi.readlines():
            if line.startswith("@"):
                if pkg_name is not None:
                    requires[pkg_name] = (pkg_path, requirements)
                _pkg_name = line[2:-1]
                if _pkg_name not in requires.keys():
                    pkg_name = _pkg_name
                requirements = []
                pkg_path = None
            elif line.startswith('requires:'):
                requirements = line[10:-1].split()
            elif line.startswith('install:'):
                if pkg_path is None: # only retain the first path (not the one in [prev])
                    pkg_path = line[9:].split()[0]
        requires[pkg_name] = (pkg_path, requirements)

    return requires

def resolve_deps(requires, pkg_name):
    to_resolve = list(requires[pkg_name][1])
    deps = list(to_resolve)
    while len(to_resolve) > 0:
        p = to_resolve.pop()
        if p not in requires:
            #print("!! Package {} not found".format(p))
            continue
        _, dd = requires[p]
        for d in dd:
            if d not in deps:
                deps.append(d)
                to_resolve.append(d)
            
    return deps

import sys
if len(sys.argv) < 2:
    print("Return a list of package files for a given package name")
    print("Argument: path_to_setup_ini [list of packages]")
    exit(1)
if len(sys.argv) > 2:
    pkgs = sys.argv[2:]
else:
    pkgs = ("tempus-core", "python3-pytempus", "python-pglite", "python3-pglite", "osm2tempus", "postgis", "tempus-wps-server", "python-tempus-loader", "pgtempus")

requires = read_requires(sys.argv[1])

deps = set(pkgs)
for p in pkgs:
    d = set(resolve_deps(requires, p))
    #print(d)
    deps = deps.union(d)

for d in sorted(list(deps)):
    if d in requires:
        print(requires[d][0])

