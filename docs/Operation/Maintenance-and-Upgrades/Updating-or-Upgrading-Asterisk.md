---
title: Updating or Upgrading Asterisk
pageid: 28315838
---

Keeping the System Up-to-date
=============================

Definition of Updates and Upgrades
----------------------------------

**Updates** involve installing a new minor version. That is, moving from 11.X.X to 11.X.X vs moving from 11 to 12. New minor versions include bug fixes, some of which may be security related. Typically, there should not be features or new functionality included in a minor version except when the fixing of a bug requires it.

**Upgrades** involve installing a new major version. For example, moving from 11 to 12. New major versions can include bug fixes, new features and functionality, changes to old features or functionality, deprecation of functionality or change in support status.

**Updates and upgrades should only be performed when necessary**

* Reason to Update  

	+ Your install is affected by a bug or [security vulnerability](/About-the-Project/Asterisk-Security-Vulnerabilities) and you believe the new minor version will fix your issue.
* Reason to Upgrade  

	+ You require new features or enhancements only available in a new major version and are ready for the work involved in upgrading.

When considering an update or upgrade you should be familiar with the [Asterisk support life-cycle](/About-the-Project/Asterisk-Versions). It is useful to know the support status of the version you may be moving to.

Researching a New Asterisk Version
----------------------------------

Included with Asterisk releases are a few files that are useful for researching the version you are considering for update or upgrade. These can be found in the root of the Asterisk source directory.

1. UPGRADE.txt - Documents any changes that you need to know about when moving between major versions. Especially changes that break backwards compatibility.
2. CHANGES - Documents new or enhanced functionality between versions listed in the file.
3. ChangeLog - A log showing all changes (bug fixes, new features, security fixes,etc) between released versions. It can be useful if you are searching for a specific fix or change, but this could be overly verbose for looking at changes between two major versions.

Performing Updates
------------------

Process1. Research the new minor version you intend to update to.
2. Be sure you [have a backup](/Operation/Maintenance-and-Upgrades/Asterisk-Backups) of any essential data on the system.
3. If you determine one of those changes will be beneficial for you, only then proceed with an update.
4. Download the new version and [install Asterisk](/Getting-Started/Installing-Asterisk).
Performing Upgrades
-------------------

Process1. Research the new major version you are considering for an upgrade.
2. Be sure you [have a backup](/Operation/Maintenance-and-Upgrades/Asterisk-Backups) of any essential data on the system.
3. If you determine the new functionality or changes will be beneficial then proceed with the upgrade.
4. On a test system, a non-production system, download and [install the new version](/Getting-Started/Installing-Asterisk).
5. Migrate backups of configuration, databases and other data to the new Asterisk install.
6. Test this new system, or simulate your production environment before moving this new system into production.
	1. Especially test any areas of Asterisk where behavior changes have been noted in the UPGRADE.txt or CHANGES files. APIs, like AGI, AMI or ARI connecting to custom applications or scripts should be thoroughly tested. You should always try to extensively test your dialplan.

Third Party Modules
-------------------

When updating or upgrading Asterisk you should also check for updates to any third party modules you use. That is, modules that are not distributed with Asterisk. Those third party modules may require updates to work with your new version of Asterisk.

Update and Upgrade Tips
-----------------------

 




!!! tip 
    Updates and upgrades could include changes to configuration samples.  Sample files will not be updated unless you run "make samples" again or copy the new sample files from the source directory. Be careful not to overwrite your current configuration.

      
[//]: # (end-tip)





!!! tip 
    Keep old menuselect.makeopts files (see Asterisk source directory) and use them when building a new version to avoid customizing menuselect again when building a new version. This may only work for updates and not upgrades.

      
[//]: # (end-tip)





!!! tip 
    If you forget to re-build all Asterisk modules currently installed on the system then you may be prompted after compilation with a warning about those modules. That can be resolved by simply re-building those modules or re-installing them if you obtain them in binary form from a third party.

      
[//]: # (end-tip)



