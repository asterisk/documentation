---
title: Upgrading pjproject Bundled
pageid: 38765236
---

This page explains how to upgrade the bundled version of a software with examples given for pjproject. For information on how to compile with bundled pjproject, see [PJSIP-pjproject.](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/PJSIP-pjproject)

Update Third Party Mirror

Currently we keep a copy of any third party "bundled" software on github for use and inclusion during our build process: [Asterisk third party mirror](https://github.com/asterisk/third-party)

Either fork and clone a copy of that repository, or clone it directly and check out a new branch for the new files you are about to add. Create a new directory beneath the appropriate project directory named for the version number being upgraded to. Next download the new version of the software you are upgrading to as a tarball into this directory.


!!! info "pjproject"
    The latest release for pjproject can be found either on their websites [downloads page](https://www.pjsip.org/download.htm), or directly from their [github repository](https://github.com/pjsip/pjproject/releases).

      
[//]: # (end-info)



The build process for bundled software currently expects tarballs compressed using bz2. So if the software you are downloading is not compressed as such (\*.tar.bz2 format) you'll need to convert it first. Once you have the tarball you'll either need to also get the associated MD5 checksum for it, or create one for it. Create a file called MD5SUM.TXT and add the checksum(s) to it (see examples from previous upgrades in the [third party mirror](https://github.com/asterisk/third-party)).




!!! note 
    The md5 file format must be unix. If using vim, you can check this by opening the file and typing:
[//]: # (end-note)


  
  

```
:set ff?  



---


If you don't see fileformat=unix, you will need to convert formats.

```

 Lastly add the \*.tar.bz2 tarball and checksum file to your repository, push the changes, and then create a pull request on github.

Asterisk Changes
----------------

Since the Asterisk build process uses the checksum to verify the bundled tarball you'll also need to copy the MD5SUM.TXT file to the appropriate third-party/{project} directory in the Asterisk source tree, and rename it to the same name as the tarball, but with but with an ".md5" extension added. For instance, something like {project}-{version}.tar.bz2.md5.




---

  
pjproject example  

```
$ cp MD5SUM.TXT ~/src/asterisk/third-party/pjproject/pjproject-2.10.tar.bz2.md5

```

Be sure to also remove the previous version of that file from the source tree:




---

  
pjproject example  

```
$ git rm ~/src/asterisk/third-party/pjproject/pjproject-2.9.tar.bz2.md5

```

Next modify the *versions.mak* file, which can be found in the third-party directory of your Asterisk directory, to the version number being upgraded to:




---

  
pjproject example  

```
PJPROJECT_VERSION = 2.10

```

Now remove any patches found beneath the ./third-party/{project}/patches directory that have been added since the last version, **and** are now included in this new version. Again, only remove those patches that are currently included in the new version of the released software being upgraded to.




!!! info ""
    Hint: patch files starting with '0000' (all zeros) are ones that are always carried over, and shouldn't require removing unless they have been contributed and accepted upstream.

      
[//]: # (end-info)



To know which patches need to be removed either visit the project's website, and find the change log of issues/patches included, or probably better for each patch check the actual git log of the new software and ensure the patch has been included.

Next, read the change log for the new version being upgraded to, and make sure that there are no changes that will potentially break Asterisk. For instance, renamed, removed, or deprecated API calls. Or fields, or variables changing signage or type, etc... If something has changed that would cause a potential error in Asterisk then fix it. Pay attention to the Github tag for the release which shows backwards incompatible changes as well as any security issues that may be present in the release.

Testing
-------

At this point you should be able to configure, and build Asterisk. Ensure the correct bundled version of the software is now being downloaded and compiled against. Run a few tests locally to make sure Asterisk is generally "fine". If you are able then also execute the testsuite against the new changes. Once everything seems to be okay, then create a patch with all the Asterisk changes, and push it up for review on [GitHub](/Development/Policies-and-Procedures/Code-Contribution). Once uploaded you can also add a "regate" comment to the review to initiate a testsuite run via continuous integration. Don't worry if everything does pass it will not auto-merge the changes.



