---
title: Configuring the Asterisk Module Loader
pageid: 30278449
---

Overview
========

As you may have learned from [the Asterisk Architecture section](/Fundamentals/Asterisk-Architecture/Asterisk-Architecture-The-Big-Picture), the majority of Asterisk's features and functionality are separated outside of the core into various **modules**. Each module has distinct functionality, but sometimes relies on another module or modules.

Asterisk provides capability to automatically and manually load modules. Module load order can be configured before load-time, or modules may be loaded and unloaded during run-time.

Configuration
=============

The configuration file for Asterisk's module loader is **modules.conf**. It is read from the typical [Asterisk configuration directory](/Fundamentals/Directory-and-File-Structure). You can also view the sample of modules.conf file in your source directory at configs/modules.conf.sample or on [GitHub at this link](https://github.com/asterisk/asterisk/blob/master/configs/samples/modules.conf.sample).

The configuration consist of one large section called "modules" with possible directives configured within.

There are several directives that can be used.

* autoload - When enabled, Asterisk will automatically load any modules found in the [Asterisk modules directory](/Fundamentals/Directory-and-File-Structure).
* preload - Used to specify individual modules to load before the Asterisk core has been initialized. Often used for [realtime](/Fundamentals/Asterisk-Configuration/Database-Support-Configuration/Realtime-Database-Configuration) modules so that config files can be pushed to a backend before the dependent modules are loaded.
* require - Set a required module. If a required module does not load, then Asterisk exits with status code 2.
* preload-require - A combination of preload and require.
* noload - Do not load the specified module.
* load - Load the specified module. Typically used when autoload is set to 'no'.

Let's show a few arbitrary examples below.

```
[modules]
;autoload = yes
;preload = res_odbc.so
;preload = res_config_odbc.so
;preload-require = res_odbc.so
;require = res_pjsip.so
;noload = pbx_gtkconsole.so
;load = res_musiconhold.so

```

CLI Commands
============

Asterisk provides a few commands for managing modules at run-time. Be sure to check the current usage using the CLI help with "core show help <command>".

* module show

```
Usage: module show [like keyword]
 Shows Asterisk modules currently in use, and usage statistics.

```
* module load

```
Usage: module load <module name>
 Loads the specified module into Asterisk.

```
* module unload

```
Usage: module unload [-f|-h] <module_1> [<module_2> ... ]
 Unloads the specified module from Asterisk. The -f
 option causes the module to be unloaded even if it is
 in use (may cause a crash) and the -h module causes the
 module to be unloaded even if the module says it cannot, 
 which almost always will cause a crash.

```
* module reload

```
Usage: module reload [module ...]
 Reloads configuration files for all listed modules which support
 reloading, or for all supported modules if none are listed.

```


