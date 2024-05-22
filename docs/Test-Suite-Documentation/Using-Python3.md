---
title: Using Python3
pageid: 50921837
---

Moving to Python3
=================

Along with the move to Python 3 comes with a few major changes and many small ones.  The two largest changes are the move away from using the pjsua/pjsua2 library by migrating those tests to sipp and the move to the use of a python virtual environment.  There are test that still use the pjsua application (primarily in chan-sip) so if you want to run those tests you will still need [pjsua](/Test-Suite-Documentation/Using-Python3) installed.[\*](/Test-Suite-Documentation/Using-Python3)

The move to the virtual environment for python comes with two big advantages.  First, installation becomes standardized and simplified so that all we have to do is activate the environment, install the defined modules and the test environment should be set.  You still have to have asterisk and the other prerequisites installed but no more hunting down the required modules.  Second, we can activate/deactivate the virtual environment separately from the host environment so that the test suite's requirements don't interfere with your local os. 

StarPy also is now using a new Python3 specific version (1.1).  The correct version should be installed as part of the extras below.

Prerequisites
=============

Most developers create an Asterisk work directory like `~/source/asterisk` or `/usr/src/asterisk` then in that directory, clone the Asterisk, Testsuite and support repositories.  I'll assume `/usr/src/asterisk` in the rest of these instructions and that your tree looks (or will look) like...

`/usr/src/asterisk/
 asterisk/ The asterisk repository cloned from https://gerrit/asterisk.org/asterisk
 testsuite/ The testsuite repository clones from https://gerrit/asterisk.org/testsuite` If you don't already have the Asterisk source tree checked out and all of its prerequisites installed, please visit [Installing Asterisk From Source](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source).

Make sure you're using a supported version of libsrtp.  See ["Installing libsrtp"](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Installing-libsrtp) for more information.

Install Support Packages
========================

*yappcap and starpy are now installed as part of the virtual environment via the extras.txt*




!!! note 
    The testsuite also provides an install_prereq script in the contrib/scripts directory which can be used to install the base dependencies on various distributions. If this is used then there is no need to manually install SIPp or asttest.  
[//]: # (end-note)





**[sipp](https://github.com/SIPp/sipp)** is a SIP simulation tool that is relied on heavily by the Testsuite.  Most distributions have up to date versions of the tool available.  If it's version 3.6.0 or greater, simple use your distro's package manager to install it and skip the rest of the sipp instructions.  Otherwise download, build and install it yourself.  You'll need to install openssl, libsrtp (or libsrtp2), libpcap, gsl (or libgsl), lksctp-tools (or libsctp1), and their associated development packages (-devel or -dev).

```bash title="sipp Installation  " linenums="1"
$ cd /usr/src/asterisk
$ git clone https://github.com/SIPp/sipp.git
$ cd sipp
$ git checkout v3.6.0 ## This is the latest version we KNOW works.
$ ./build.sh --prefix=/usr --with-openssl --with-pcap --with-rtpstream --with-sctp --with-gsl CFLAGS=-w

```

When the build completes, check the version:

```bash title="Check sipp version  " linenums="1"
 $ ./sipp -v
 
 SIPp v3.6.0-TLS-SCTP-PCAP-RTPSTREAM.
...

```

If everything's OK, install it:

```bash title="make install  " linenums="1"
$ sudo make install

```

Install Asterisk
================

 Make sure you can actually build and install Asterisk at least once before proceeding.  Once you can, you'll need to follow a few more steps to configure Asterisk and rebuild it for testing:

* Add **`--enable-dev-mode`** and optionally, **`--disable-binary-modules`** to your **`./configure`** command line.  Disabling the binary modules just prevents the need to download the external codecs and res_digium_phone.
* In menuselect...
	+ Under **Compiler Flags - Development**,  enable **DONT_OPTIMIZE**, **MALLOC_DEBUG**, **`DO_CRASH`** and **`TEST_FRAMEWORK`** and disable **`COMPILE_DOUBLE`**.
	+ Make sure all modules are enabled.  You don't need the **Test Modules** though.  If you enter **Test Modules** and press **<kbd>F7</kbd>**, you can quickly disable all modules.
* Build and install Asterisk and the development header files.

```bash title=" " linenums="1"
$ make
$ sudo make install
$ sudo make install-headers

```

The testsuite needs the sample configuration files installed but before you do that, **make sure you've saved the contents of /etc/asterisk if you've customized any files**.  Once you're sure you don't need anything in /etc/asterisk...

```bash title=" " linenums="1"
$ sudo make samples

```



Do NOT start Asterisk at this time.  The Testsuite will start and stop it for each test.

Install the Testsuite
=====================

Currently we need to get the current Review, but the dev branch should be available soon.

```bash title=" " linenums="1"
$ git clone "https://gerrit.asterisk.org/testsuite"
$ cd /usr/src/asterisk/testsuite
$ git fetch https://gerrit.asterisk.org/testsuite

```

ASTTest Installation
====================

 Install asttest

```bash title=" " linenums="1"
$ cd asttest
$ make
$ sudo make install

```

Creating a Python 3 Testsuite Virtual Environment
=================================================

At a minimum Python3 and matching pip need to be installed.  The minimum python version at this time is 3.6.8.  Please see [https://docs.python.org/3/tutorial/venv.html#](https://docs.python.org/3/tutorial/venv.html#)(https://docs.python.org/3/tutorial/venv.html) for more information on Python Virtual Environments.

* From */usr/src/asterisk/testsuite/* create the virtual environment using the provided script:

```bash title=" " linenums="1"
$ ./setupVenv.sh

```

* The *.venv* directory will be created locally.  *.gitignore* is set to ignore the *.venv* folder.  You can use another directory, but you will need to watch out for git if you choose a different name.
* After the venv is created, the script will activate it and install the pip requirements.
* If you wish to manage your own virtual environment, you can still run *setupVenv.sh* from within it to install the required python packages.

Running the Testsuite Within the Virtual Environment

* To run the testsuite using the venv, use the *runInVenv.sh* script to check, activate and run the test suite:

```bash title=" " linenums="1"
$ ./runInVenv.sh python runtests.py -l

```



* The *runInVenv.sh* script 'leaves' the virtual environment on termination.
* It also checks the current *requirements.txt* and *extras.txt* for changes since the last time it was run.  If it detects a change, the venv is removed and re-created with the new requirements. Because of this, you can call *runInVenv.sh*without running *setupVenv.sh*.
* This script will exit if run from within an activated virtual environment.  This is to avoid potential conflicts with the running environment.  If you wish to run from an activated virtual environment, you can continue to use *runtests.py* manually but are responsible for maintaining the venv.

If you use the included scripts, you should not have to interact with the virtual environment directly.  This should help maintaining a separate, clean test environment.




!!! tip 
    If you want to install the Python dependencies globally on the system and not in a Python Virtual Environment you can examine the setupVenv.sh shell script to see how it executes pip to install them, and execute globally instead.

      
[//]: # (end-tip)





Using a Docker Container
========================

Another option is to use a Docker Container.  If you do, you will want to use persistent storage for asterisk and the testsuite.  This can be done by mounting */usr/src/asterisk* from the container onto either a bind mount or volume on the local OS.

A bind mount is useful if you are trying to run the container against a version of asterisk and the testsuite that you have on the host OS.  This bind mount example uses the host's */usr/src/asterisk-docker* directory as it's local */usr/src/asterisk* directory

```bash title="run with bind mount  " linenums="1"
$ docker run \
--name myNewContainer -it -d \
--mount type=bind,source=/usr/src/asterisk-docker,target=/usr/src/asterisk \
testsuite/centos7

```

A note about using this method.  This is useful if you want to run git and your ide on your local OS while building and testing on the container.  However, you want to use a separate directory for this bind mount from your normal local-builds because if you build on both the container and host from the same directory, the temporary files that are created can and will collide unless care is taken to clean between building on each OS.

If you do not plan on developing for the testsuite and simply want to run it, the simpler option would be to use a volume.  A volume is a re-usable storage location for Docker Containers.

```bash title="run with volume  " linenums="1"
$ docker run \
--name myNewContainer -it -d \
--mount source=ast-build,target=/usr/src/asterisk \
testsuite/centos7 bash

```

This will create or re-use an existing ast-build Docker volume

```bash title="docker volumes  " linenums="1"
$ docker volume ls
DRIVER VOLUME NAME
local ast-build

```

A sample <Dockerfile> can be found [here](../Dockerfile).  The git pull for the testsuite should be updated to the latest branch / review.

Docker by default does not enable ipv6.  If you want to run any ipv6 tests, please add the following to */etc/docker/daemon.json* then reload the docker service.

```json title="daemon.json" linenums="1"
xml{
 "ipv6": true,
 "fixed-cidr-v6": "fd00::/80"
}

```
```bash title="reload docker  " linenums="1"
$ sudo systemctl reload docker

```

Even though we are running inside a container, we can still use the *setupVenv.sh and *runInVenv.sh** scripts because they activate and run within the same shell.











!!! info "\*A note about pjsua"
    pjsua and the test suite's phone app were used to help with more complicated SIP scenarios, mostly transfer scenarios that require registration. These can be covered via the 3pcc and ooscf features of sipp, but the complexity of the scripts in some cases is quite high. We should look at creating a separate test user agent and a standardization of scenarios long-term.

      
[//]: # (end-info)



