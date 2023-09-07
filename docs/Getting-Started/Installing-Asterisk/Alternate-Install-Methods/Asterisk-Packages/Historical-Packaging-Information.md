---
title: Historical Packaging Information
pageid: 27199498
---




!!! info ""
    At one time, Asterisk packages were also available for Ubuntu. Currently, packages are not being made by the Asterisk project for this distribution. Information detailing the Ubuntu build environment has been moved onto this page for historical purposes.

      
[//]: # (end-info)





Prerequisites
=============

All of Ubuntu's Code, Translations, Packages, Bugs, access control lists, team information, etc. live in [Launchpad](https://launchpad.net/). So for you to be able to contribute to bug discussions, upload packages, contribute code and translations, it's important that you:

* Create an [account](https://help.launchpad.net/YourAccount/NewAccount) on launchpad.
* Create a [GPG key](https://help.launchpad.net/YourAccount/ImportingYourPGPKey) and import it.
* Create a [SSH key](https://help.launchpad.net/YourAccount/CreatingAnSSHKeyPair) and import it.

Create a Build Environment
==========================

Install Ubuntu 10.04 (Lucid)
----------------------------

[Installing Ubuntu 10.04 (Lucid)](/Installing-Ubuntu-10.04--Lucid-)

Enable Backports
-------------
```bash title="---" linenums="1"
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository "deb http://ca.archive.ubuntu.com/ubuntu/ $(lsb_release --short --codename)-backports main universe"

```

Upgrade Lucid to the latest release:
---------------------------------
```bash title="---" linenums="1"
$ sudo apt-get update
$ sudo apt-get dist-upgrade
$ sudo apt-get autoremove
$ sudo reboot

```

Install required software
----------------------
```bash title="---" linenums="1"
$ sudo apt-get install build-essential pbuilder debian-archive-keyring ccache

```

pbuilder
-----
```bash title="---" linenums="1"
$ sudo mkdir -p /var/cache/pbuilder/ccache
$ sudo mkdir -p /var/cache/pbuilder/hook.d

```
```bash title="---" linenums="1"
$ sudo vi /etc/pbuilder/pbuilderrc

```



---

  
/etc/pbuilder/pbuilderrc  

```
export CCACHE_DIR="/var/cache/pbuilder/ccache"
export PATH="/usr/lib/ccache:${PATH}"
EXTRAPACKAGES="ccache"
BINDMOUNTS="${CCACHE_DIR}"

# Codenames for Debian suites according to their alias. Update these when
# needed.
UNSTABLE_CODENAME="sid"
TESTING_CODENAME="wheezy"
STABLE_CODENAME="squeeze"
OLDSTABLE_CODENAME="lenny"
STABLE_BACKPORTS_SUITE="$STABLE_CODENAME-backports"
 
# List of Debian suites.
DEBIAN_SUITES=($UNSTABLE_CODENAME $TESTING_CODENAME $STABLE_CODENAME $OLDSTABLE_CODENAME
 "unstable" "testing" "stable" "oldstable")
 
# List of Ubuntu suites. Update these when needed.
UBUNTU_SUITES=("oneiric" "natty" "maverick" "lucid")
 
# Mirrors to use. Update these to your preferred mirror.
DEBIAN_MIRROR="ftp.us.debian.org"
UBUNTU_MIRROR="mirrors.kernel.org"
 
# Optionally use the changelog of a package to determine the suite to use if
# none set.
if [ -z "${DIST}" ] && [ -r "debian/changelog" ]; then
 DIST=$(dpkg-parsechangelog | awk '/^Distribution: / {print $2}')
 # Use the unstable suite for certain suite values.
 if $(echo "experimental UNRELEASED" | grep -q $DIST); then
 DIST="$UNSTABLE_CODENAME"
 fi
fi
 
# Optionally set a default distribution if none is used. Note that you can set
# your own default (i.e. ${DIST:="unstable"}).
: ${DIST:="$(lsb_release --short --codename)"}
 
# Optionally change Debian release states in $DIST to their names.
case "$DIST" in
 unstable)
 DIST="$UNSTABLE_CODENAME"
 ;;
 testing)
 DIST="$TESTING_CODENAME"
 ;;
 stable)
 DIST="$STABLE_CODENAME"
 ;;
 oldstable)
 DIST="$OLDSTABLE_CODENAME"
 ;;
esac
 
# Optionally set the architecture to the host architecture if none set. Note
# that you can set your own default (i.e. ${ARCH:="i386"}).
: ${ARCH:="$(dpkg --print-architecture)"}
 
NAME="$DIST"
if [ -n "${ARCH}" ]; then
 NAME="$NAME-$ARCH"
 DEBOOTSTRAPOPTS=("--arch" "$ARCH" "${DEBOOTSTRAPOPTS[@]}")
fi

DEBBUILDOPTS="-b"
if [ "${ARCH}" == "i386" ]; then
 DEBBUILDOPTS="-B"
fi

BASETGZ="/var/cache/pbuilder/$NAME-base.tgz"
# Optionally, set BASEPATH (and not BASETGZ) if using cowbuilder
# BASEPATH="/var/cache/pbuilder/$NAME/base.cow/"
DISTRIBUTION="$DIST"
BUILDRESULT="/var/cache/pbuilder/$NAME/result/"
APTCACHE="/var/cache/pbuilder/$NAME/aptcache/"
BUILDPLACE="/var/cache/pbuilder/build/"
 
if $(echo ${DEBIAN_SUITES[@]} | grep -q $DIST); then
 # Debian configuration
 MIRRORSITE="http://$DEBIAN_MIRROR/debian/"
 COMPONENTS="main contrib non-free"
 DEBOOTSTRAPOPTS=("${DEBOOTSTRAPOPTS[@]}" "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg")
elif $(echo ${UBUNTU_SUITES[@]} | grep -q $DIST); then
 # Ubuntu configuration
 MIRRORSITE="http://$UBUNTU_MIRROR/ubuntu/"
 COMPONENTS="main universe"
 DEBOOTSTRAPOPTS=("${DEBOOTSTRAPOPTS[@]}" "--keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg")
else
 echo "Unknown distribution: $DIST"
 exit 1
fi

```

### Debian

```bash title=" " linenums="1"
$ for x in unstable testing stable; do for y in i386 amd64; do sudo DIST=${x} ARCH=${y} pbuilder create; done; done

```

### Ubuntu

```bash title=" " linenums="1"
$ for x in lucid maverick natty; do for y in i386 amd64; do sudo DIST=${x} ARCH=${y} pbuilder create; done; done

```

svn-buildpackage
-------------
```bash title="---" linenums="1"
$ vi ~/.svn-buildpackage.conf

```
```
svn-builder=debuild
svn-noautodch

```

quilt
----
```bash title="---" linenums="1"
$ vi ~/.quiltrc

```
```
QUILT_PATCHES="debian/patches"

QUILT_PATCH_OPTS="--unified-reject-files"
QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
QUILT_DIFF_OPTS="--show-c-function"
QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"

```

devscripts
-------
```bash title="---" linenums="1"
$ vi ~/.devscripts

```
```
DEBCHANGE_RELEASE_HEURISTIC=changelog
DEBCHANGE_MULTIMAINT_MERGE=yes
DEBCHANGE_MAINTTRAILER=no
DEBUILD_ROOTCMD=fakeroot
DEBUILD_LINTIAN=yes
DEBUILD_LINDA=yes
DEFAULT_DEBRELEASE_DEBS_DIR=../build-area/
USCAN_DESTDIR=../tarballs

```

Create a GPG Key
----------------

<https://help.ubuntu.com/community/GnuPrivacyGuardHowto>

```bash title=" " linenums="1"
$ vi ~/.bashrc

```
```
export DEBFULLNAME='Paul Belanger'
export DEBEMAIL='pabelanger@digium.com'
export GPGKEY=8C3B0FA6
export EDITOR=vi

```

See also
--------

* [Ubuntu Packaging Guide](https://wiki.ubuntu.com/PackagingGuide/Complete)

Updating an Ubuntu Package
==========================

New upstream release
--------------------

### Checkout source

```bash title=" " linenums="1"
$ mkdir -p ~/digium
$ cd ~/digium
$ svn http://blah.org/svn/blah

```

### Upstream tarball

```bash title=" " linenums="1"
$ uscan --verbose

```

### Update the changelog file

```bash title=" " linenums="1"
$ dch -e

```

### Update patches

```bash title=" " linenums="1"
$ while quilt push; do quilt refresh; done

```

### Release package

```bash title=" " linenums="1"
$ dch -r

```

### Build package source

```bash title=" " linenums="1"
$ svn-buildpackage -S

```

### Compile package

```bash title=" " linenums="1"
$ dput ppa:pabelanger/testing ../build-area/*.changes

```

rebuildd
========

Introduction
------------

Prerequisites
-------------

[Creating a Build Environment](/Creating-a-Build-Environment)

Getting started
---------------

```
sudo apt-get install rebuildd reprepro apache2

```

### reprepro

```bash title=" " linenums="1"
$ sudo adduser --system --shell /bin/bash --gecos 'Reprepro Daemon' --group --disabled-password reprepro

```
```bash title="---" linenums="1"
$ sudo su reprepro

```
```bash title="---" linenums="1"
$ cd ~
$ mkdir bin conf incoming

```
```bash title="---" linenums="1"
$ vi ~/conf/distributions

```



---

  
distributions  

```
Suite: lucid-proposed
Version: 10.04
Codename: lucid-proposed
Architectures: i386 amd64 source
Components: main
SignWith: yes
Log: logfile
 --changes ~/bin/build_sources

```
```bash title="---" linenums="1"
$ vi ~/conf/incoming

```



---

  
incoming  

```
Name: incoming
IncomingDir: incoming
Allow: lucid-proposed
Cleanup: on_deny on_error
TempDir: tmp

```
```bash title="---" linenums="1"
$ vi ~/conf/apache.conf

```



---

  
apache.conf  

```
Alias /debian /home/reprepro/
<Directory /home/reprepro>
 Options +Indexes
 AllowOverride None
 order allow,deny
 allow from all
</Directory>

```
```bash title="---" linenums="1"
$ vi ~/bin/build_sources

```
```bash title="---" linenums="1"
#!/bin/bash
 
action=$1
release=$2
package=$3
version=$4
changes_file=$5
 
# Only care about packages being added
if [ "$action" != "accepted" ]
then
 exit 0
fi
 
# Only care about source packages
echo $changes_file | grep -q _source.changes
if [ $? = 1 ]
then
 exit 0
fi
 
# Kick off the job
echo "$package $version 1 $release" | sudo rebuildd-job add

```
```bash title="---" linenums="1"
$ reprepro -V -b . createsymlinks
$ reprepro -V -b . processincoming incoming

```
```bash title="---" linenums="1"
$ exit

```

### rebuildd

```bash title=" " linenums="1"
$ sudo vi /etc/default/rebuildd

```
```
START_REBUILDD=1
START_REBUILDD_HTTPD=1
DISTS="lucid"

```

Also see
--------

* <http://alioth.debian.org/scm/viewvc.php/checkout/mirrorer/docs/manual.html?revision=HEAD&root=mirrorer>
* <http://inodes.org/2009/09/14/building-a-private-ppa-on-ubuntu/>

Working with Source Packages
============================

```bash title=" " linenums="1"
$ sudo apt-get build-dep asterisk

```
```bash title="---" linenums="1"
$ DEB_BUILD_OPTIONS="debug" apt-get -b source asterisk

```









