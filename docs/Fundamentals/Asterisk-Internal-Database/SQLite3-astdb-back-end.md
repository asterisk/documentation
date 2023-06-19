---
title: SQLite3 astdb back-end
pageid: 19005573
---




---

**Note:**  Starting with **Asterisk 10** , Asterisk uses **SQLite3** for its internal database instead of the Berkeley DB database used by Asterisk 1.8 and previous versions.

  



---


 Every effort has been made to make this transition as automatic and painless for users as possible. This page will describe the upgrade process, any potential problems, and the appropriate solutions to those problems.

The upgrade process
-------------------

Asterisk 10 will attempt to upgrade any existing old-style Berkeley DB internal database to the new SQLite 3 database format. This conversion process is accomplished at run-time with the astdb2sqlite3 utility which builds by default in Asterisk 10. The astdb2sqlite3 utility will also be forcibly built even if deselected using menuselect if the build process determines that there is an old-style Berkeley DB and no new SQLite3 DB exists.

When Asterisk 10 is run, as part of the initialization process it checks for the existence of the SQLite3 database. If it doesn't exist and an old-style Berkeley DB does exist, it will attempt to convert the Berkeley DB to the SQLite3 format. If no existing database exists, a new SQLite 3 database will be created. If the conversion fails, a warning will be displayed with instructions describing possible fixes and Asterisk will exit.




---


**Information:**  It is important that you perform the upgrade process at the same permission level that you expect Asterisk to run at. For example, if you upgrade as root, but run Asterisk as a user with lower permissions, the SQLite3 database created as part of the upgrade will not be able to be accessed by Asterisk.

  



---


Troubleshooting an upgrade
--------------------------

### Symptoms

#### ./configure displays the warning: \*\*\* Please install the SQLite3 development package.

##### Cause

To build Asterisk 10, the SQLite 3 development libraries must be installed.

##### Solution

On Debian-based distros including Ubuntu, these libraries may be installed by running 'sudo apt-get install libsqlite3-dev'. For Red Hat-based distros including Fedora and Centos these libraries may be installed by running (as root) 'yum install sqlite3-devel'.

#### Asterisk exits displaying the warning: \*\*\* Database conversion failed!

##### Cause

Asterisk 10 could not find the astdb2sqlite3 utility to convert the old Berkeley DB to SQLite 3.

##### Solution

Make sure that astdb2sqlite3 is selected for build in the Utilities section when running 'make menuselect'. Be sure to re-run 'make' and 'make install' after selecting astdb2sqlite3 for build.

##### Cause

Asterisk is unable to write to the directory specified in asterisk.conf as the 'astdbdir'

##### Solution

SQLite 3 creates a journal file in the 'astdbdir' specified in asterisk.conf. It is important that this directory is writable by the user Asterisk runs as. This involves either modifying the permissions of the 'astdbdir' directory listed in asterisk.conf, or changing the 'astdbdir' option to a directory for which the user running Asterisk already has write permission. This is generally only a problem if Asterisk is run as a non-root user.

##### Cause

If Asterisk 10 was installed via a distro-specific package, it is possible that the distro forgot to package the astdb2sqlite3 utility.

##### Solution

Run 'which astdb2sqlite3' from a terminal. If no filenames are displayed, then astd2sqlite3 has not be installed. Check if the distro includes it in another asterisk related package, or download the Asterisk 10 source from [the Asterisk.org website](http://downloads.asterisk.org/pub/telephony/asterisk) and follow the normal build instructions. Instead of running 'make install', manually run 'utils/astdb2sqlite3 /var/lib/asterisk/astdb' from the Asterisk source directory, replacing '/var/lib/asterisk' with the 'astdbdir' directory listed in asterisk.conf. After the conversion, the distro-supplied Asterisk should successfully run.

Migrating back from Asterisk 10 to Asterisk 1.8
-----------------------------------------------

If migrating back to Asterisk 1.8 from Asterisk 10, it is possible to convert the SQLite 3 internal database back to the Berkeley DB format that Asterisk 1.8 uses by using the astdb2bdb utility found in the utils/ directory of the Asterisk 10 source. To build, make sure that astdb2bdb is selected in the Utilities section when running 'make menuselect'. Running 'utils/astdb2bdb /var/lib/asterisk/astdb.sqlite3' (replacing '/var/lib/asterisk' with the 'astdbdir' directory listed in asterisk.conf) will produce a file named 'astdb' in the current directory. Back up any existing astdb file in the astdbdir directory and replace it with the newly created astdb file.

