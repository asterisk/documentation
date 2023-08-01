---
title: Asterisk CLI Configuration
pageid: 28315613
---

With the exception of the functionality provided by the res_clialiases.so module, [Asterisk's Command Line Interface](/Operation/Asterisk-Command-Line-Interface) is provided by the core. There are a few configuration files relevant to the CLI that you'll see in a default Asterisk installation. All of these should be found in the typical /etc/asterisk/ directory in a default install. The configuration of these files is trivial and examples exist in the sample files included in the source and tarballs.

cli.conf
========

This file allows a listing of CLI commands to be automatically executed upon startup of Asterisk.

cli_permissions.conf
=====================

Allows you to configure specific restrictions or allowances on commands for users connecting to an Asterisk console. Read through the sample file carefully before making use of it, as you could create security issues.

cli_aliases.conf
=================

This file allows configuration of aliases for existing commands. For example, the 'help' command is really an alias to 'core show help'. This functionality is provided by the res_clialiases.so module.

CLI related commands
====================

There are a few commands relevant to the CLI configuration itself.

* **cli check permissions** - allows you to try running a command through the permissions of a specified user
* **cli reload permissions** - reloads the cli_permissions.conf file
* **cli show permissions** - shows configured CLI permissions
* **cli show aliases** - shows configured CLI command aliases



Changing the CLI Prompt
=======================

The CLI prompt is set with the ASTERISK_PROMPT UNIX environment variable that you set from the Unix shell before starting Asterisk

You may include the following variables, that will be replaced by the current value by Asterisk:

* %d - Date (year-month-date)
* %s - Asterisk system name (from asterisk.conf)
* %h - Full hostname
* %H - Short hostname
* %t - Time
* %u - Username
* %g - Groupname
* %% - Percent sign
* %# - '#' if Asterisk is run in console mode, '' if running as remote console
* %Cn[;n] - Change terminal foreground (and optional background) color to specified A full list of colors may be found in include/asterisk/term.h

On systems which implement getloadavg(3), you may also use:

* %l1 - Load average over past minute
* %l2 - Load average over past 5 minutes
* %l3 - Load average over past 15 minutes
