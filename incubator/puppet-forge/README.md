# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

Helm Chart: puppet-forge
-----------------------
Distribute locally developed Puppet modules and proxy to the official Puppet Forge server.

Container for running the puppet_forge_server project from Github. This
project allow one to serve locally developed Puppet forge modules and
proxy requests to an upstream Puppet forge server (typically the official
server run by Puppetlabs).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

How to use this container
-------------------------
The container when invoked with no arguments will start the Puppet forge
server at port 8080 with local Puppet forge modules locate in /puppet/modules.
If a volume mount is not specified to /puppet/modules, then all modules are
kept within the container and the modules will be purged upon restarting
the container. In addition, the log files for the service are kept in
/puppet/logs.

The minimal command line to start the service is
````
docker run -d -p 8080:8080 puppet_forge
````

If any arguments are provided after the container name and begin with a dash,
then the arguments are provided as arguments to the Puppet forge server.
Otherwise the arguments are executed as a command within the context of the
container.

In addition there are a couple of meta-commands that the container will
respond to. If readme, info, or help (all case insensitive) are specified
as the first argument, then this README file will be displayed. Also if
the argument is version, then the current Puppet forge server version is
printed.

Configuration
-------------
Configuration of the Puppet forge container is controlled through a number
of environmental variables. This is normally done with the -e argument to
Docker.

Variable                      | Default Value | Notes
------------------------------|---------------|--------------------------------
PUPPET_FORGE_PROXY="URL"      | None          | Enable proxy mode to URL
PUPPET_FORGE_CACHE_TTL="SECS" | 1800          | Specify cache timeout in secs
PUPPET_FORGE_CACHE_SIZE="NUM" | 250           | Number of cache entries to keep
PUPPET_FORGE_MODULE_DIR="DIR" | /puppet/modules | Local module storage

Multiple directories can be specified for the module directory by setting the
value of the variable the list of directories with a colon (':') as the
delimiter. This can be useful if one has multiple module repositories that
allow module promotion. The server does not provide any access control for
multiple repositories and needs to be controlled through the Puppetfile.
