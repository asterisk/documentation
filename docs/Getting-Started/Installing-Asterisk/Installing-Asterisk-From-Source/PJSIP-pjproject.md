---
title: PJSIP-pjproject
pageid: 25919783
---

Overview
========

Asterisk currently contains two SIP stacks: the original **chan\_sip** SIP channel driver which is a complete standalone implementation, has been present in all previous releases of Asterisk *and no longer receives core support*, and the newer **chan\_pjsip** SIP stack that is based on Teluu's "[pjproject](http://www.pjsip.org/)" SIP stack. While the pjproject stack allows us to move a significant amount of code out of Asterisk, it *is* a separate, actively maintained, library that we integrate very tightly to.  This presents challenges in making sure that the versions of Asterisk and pjproject currently installed on a system are compatible.  For this reason, we've elected to "bundle" a stable, tested version of pjproject with the Asterisk distribution and integrate it into the Asterisk build process. This does not prevent you from using an external pjproject installation but it will not be supported by the Asterisk team.  See  below for more info.

On this Pagefalse2true

bundledUsing the Bundled Version of pjproject
=============================================

Beginning with Asterisk 13.8.0, a stable version of pjproject is included in Asterisk's ./third-party directory and is enabled with the `--with-pjproject-bundled` option to `./configure`.  Beginning with Asterisk 15.0.0, it is enabled by default but can be disabled with the `--without-pjproject-bundled` option to `./configure`.

The actual pjproject source code is NOT distributed with Asterisk.  Instead the Asterisk build process downloads the official pjproject tarball then patches, configures and builds pjproject when you build Asterisk. 

Why use the bundled version?
----------------------------

* **Predictability**:  When built with the bundled pjproject, you're always certain of the version you're running against, no matter where it's installed.
* **Scalability**:  The default pjproject configuration is optimized for client applications. The bundled version's configuration is optimized for server use.
* **Usability**:  Several feature patches, which have been submitted upstream to pjproject but not yet released, are usually included in the bundled version.
* **Safety**:  If a security or critical issue is identified in pjproject, it can be patched and made available with a new release of Asterisk instead of having to waiting for a new release of pjproject.
* **Maintainability**:  You don't need to build and install separate packages.
* **Supportability**:  When asking others for help, there's no question about which version of pjproject you're using and what options it was compiled with.
* **Debugability**: The Asterisk `DONT_OPTIMIZE` and `MALLOC_DEBUG` compile flags,  which are essential for troubleshooting crashes and deadlocks, are automatically passed to the pjproject build process.
* **Compatibility**:  This is especially important from a development perspective because it means we can be sure that new pjproject APIs that have been introduced or old ones that have been deprecated, are handled and tested appropriately in Asterisk.
* **Reliability**:  You can be sure that Asterisk was tested against the bundled version.

Usage
-----

First, run `./contrib/scripts/install_prereq`.  Building the bundled pjproject requires the python development libraries which install\_prereq installs.  All you have to do now is add the `--with-pjproject-bundled` option to your Asterisk `./configure` command line and remove any other `--with-pjproject` option you may have specified. 

 

$ cd /path/asterisk-source-dir
# For Asterisk 13 and 14...
$ ./configure --with-pjproject-bundled
# For Asterisk 15+...
$ ./configure
$ make && make installThe configure and make processes will download the correct version of pjproject, patch it, configure it, build it, and finally link Asterisk to it statically.  No changes in runtime configuration are required.  You can leave your system-installed version of pjproject in place if needed.  Once compiled with the `--with-pjproject-bundled` option, Asterisk will ignore any other installed versions of pjproject. 

Using the bundled version of pjproject doesn't necessarily mean you need internet access to download the pjproject tarball every time you build. There are 2 ways to specify an alternate location from which to retrieve it.  First, assuming version 2.6 of pjproject is needed and `/tmp/downloads` is the directory you're going to save to, download the following files to the local directory:

 

$ mkdir /tmp/downloads
$ wget -O /tmp/downloads/pjproject-2.6.tar.bz2 http://www.pjsip.org/release/2.6/pjproject-2.6.tar.bz2
$ wget -O /tmp/downloads/pjproject-2.6.md5 http://www.pjsip.org/release/2.6/MD5SUM.txtIt's important that both files be named `pjproject-<version>.tar.bz2` and `pjproject-<version>.md5` respectively.

Now perform either of the following 2 steps:

1. 1. Run ./configure with the `--with-externals-cache=/tmp/downloads` option.  ./configure will check there first and only download if the files aren't already there or the tarball checksum doesn't match what's in the md5 file.  This is similar to the `--with-sounds-cache` option.  BTW, the `--with-externals-cache` mechanism works for the precompiled codecs and the Digium Phone Module for Asterisk as well.  As of Asterisk 13.18, 14.7 and 15.0, the `--with-download-cache`  option can be used to specify both the externals and sounds cache directory.
	2. Set the `PJPROJECT_URL` environment variable to any valid URL (including file:// URLs) where `./configure` can find the tarball and checksum files.  The variable can be set in your environment and exported or specified directly on the `./configure` command line.  As of Asterisk 13.18, 14.7 and 15.0, the `AST_DOWNLOAD_CACHE` environment variable can be used to specify both the externals and sounds cache directory.
 

externalBuilding and Installing pjproject from Source
=====================================================

**Installing pjproject from source or from packages is no longer a supported configuration for Asterisk versions that contain the bundled version of pjproject.** Reports of pjproject-related Asterisk issues may only be made against the bundled version. The bundled version inherits flags like DONT\_OPTIMIZE and MALLOC\_DEBUG from Asterisk which allows us to accurately diagnose issues across both Asterisk and pjproject.

Despite efforts to maintain backwards compatibility, some changes to Asterisk require a particular version of pjproject (or above) to be installed. For instance, earlier releases of pjproject cannot build shared object libraries, so some changes were required in order to use it with Asterisk 12. As such, Asterisk requires a pjproject version that is the same version of pjproject that is bundled with Asterisk, or **no more than 4 versions behind**. Alternatively, you may be able to find an Asterisk compatible version of pjproject available on [github](https://github.com/asterisk/pjproject) , or - depending on your Linux distribution - available as a package.

Earlier versions of pjproject downloaded from [www.pjsip.org](http://www.pjsip.org/) will **not** work with Asterisk 12 or greater. 

If you have previously installed a version of pjproject, you **must** remove that version of pjproject prior to building and installing the Asterisk 12+ compatible version of pjproject. See Uninstalling pjproject for more information.

Downloading pjproject
---------------------

### Obtaining pjproject from Teluu:

Use `wget` to pull the latest version (currently 2.6) from `www.pjsip.org`. Note that the instructions assume that this is 2.6; for the latest version, refer to `www.pjsip.org`:

# wget http://www.pjsip.org/release/2.6/pjproject-2.6.tar.bz2

# tar -xjvf pjproject-2.6.tar.bz2### Obtaining the latest pjproject from the svn repo:

Use  `svn` to install the latest version from  [www.pjsip.org](http://www.pjsip.org).

 

# svn co http://svn.pjsip.org/repos/pjproject/trunk/ pjproject-trunk 

### Obtaining (old asterisk) pjproject from the github repo:

If you do not have [git](http://git-scm.com/), install git on your local machine.

Downloading and installing `git` is beyond the scope of these instructions, but for Debian/Ubuntu systems, it should be as simple as:

apt-get install gitAnd for RedHat/CentOS systems:

yum install git 

Checkout the Asterisk 12-compatible pjproject from the Asterisk [github repo](https://github.com/asterisk/pjproject):

 

# git clone https://github.com/asterisk/pjproject pjprojectAnd that's it!

### Building and Installing pjproject

The first step in building and installing pjproject is configuring it using **configure**. For Asterisk, this is arguably the **most** important step in this process. pjproject embeds a number of third party libraries which can conflict with versions of those libraries that may already be installed on your system. Asterisk **will not** use the embedded third party libraries within pjproject. As an example, if you are going to build the res\_srtp module in Asterisk, then you **must** specify "--with-external-srtp" when configuring pjproject to point to an external srtp library.

Additionally, Asterisk **REQUIRES** two or three options to be passed to **configure**:

* + `--enable-shared` - Instruct pjproject to build shared object libraries. Asterisk will only use shared objects from pjproject.
	+ `--prefix` - Specify root install directory for pjproject. This will be dependent on your distribution of Linux; typically this is `/usr`for most systems. The default is `/usr/local`
	+ `--libdir` - Specify the installation location for object code libraries. This may need to be set to `/usr/lib64` for some 64-bit systems such as CentOS.

 

Failure to build Asterisk with shared pjproject object libraries **WILL** result in seemingly random crashes. For Asterisk to work properly with pjproject, pjproject **MUST** be built with shared object libraries.

#### Compiler DEFINEs

* + Users who expect to deal with Contact URIs longer than 256 characters or hostnames longer than 128 characters should set `PJSIP_MAX_URL_SIZE` and `PJ_MAX_HOSTNAME` as appropriate.
	+ IPv6 support in pjproject is, by default, disabled. To enable it, set `PJ_HAS_IPV6` to `1`.
	+ The default configuration of pjproject enables "assert" functions which can cause Asterisk to crash unexpectedly. To disable the asserts, set `NDEBUG` to `1`.
	+ The default number of TCP/TLS incoming connections allowed is 64. If you plan on having more than that you'll need to set `PJ_IOQUEUE_MAX_HANDLES` to the new limit.

With the exception of `PJ_IOQUEUE_MAX_HANDLES`, the options can be set in `CFLAGS` and passed to configure as follows: '.`/configure CFLAGS="-DNDEBUG=1 -DPJ_HAS_IPV6=1`"', etc. A better way is to create or edit the `pjlib/include/pj/config_site.h` file and set them all there. You should use the bundled version of the `config_site.h` file in `third-party/pjproject/patches` as a starting point.  Below is a copy of the file at the time of this writing.

 

pjlib/include/pj/config\_site.htruecpp/\*
 \* Asterisk config\_site.h
 \*/

#include <sys/select.h>

/\*
 \* Since both pjproject and asterisk source files will include config\_site.h,
 \* we need to make sure that only pjproject source files include asterisk\_malloc\_debug.h.
 \*/
#if defined(MALLOC\_DEBUG) && !defined(\_ASTERISK\_ASTMM\_H)
#include "asterisk\_malloc\_debug.h"
#endif

/\*
 \* Defining PJMEDIA\_HAS\_SRTP to 0 does NOT disable Asterisk's ability to use srtp.
 \* It only disables the pjmedia srtp transport which Asterisk doesn't use.
 \* The reason for the disable is that while Asterisk works fine with older libsrtp
 \* versions, newer versions of pjproject won't compile with them.
 \*/
#define PJMEDIA\_HAS\_SRTP 0

#define PJ\_HAS\_IPV6 1
#define NDEBUG 1
#define PJ\_MAX\_HOSTNAME (256)
#define PJSIP\_MAX\_URL\_SIZE (512)
#ifdef PJ\_HAS\_LINUX\_EPOLL
#define PJ\_IOQUEUE\_MAX\_HANDLES (5000)
#else
#define PJ\_IOQUEUE\_MAX\_HANDLES (FD\_SETSIZE)
#endif
#define PJ\_IOQUEUE\_HAS\_SAFE\_UNREG 1
#define PJ\_IOQUEUE\_MAX\_EVENTS\_IN\_SINGLE\_POLL (16)

#define PJ\_SCANNER\_USE\_BITWISE 0
#define PJ\_OS\_HAS\_CHECK\_STACK 0

#ifndef PJ\_LOG\_MAX\_LEVEL
#define PJ\_LOG\_MAX\_LEVEL 6
#endif

#define PJ\_ENABLE\_EXTRA\_CHECK 1
#define PJSIP\_MAX\_TSX\_COUNT ((64\*1024)-1)
#define PJSIP\_MAX\_DIALOG\_COUNT ((64\*1024)-1)
#define PJSIP\_UDP\_SO\_SNDBUF\_SIZE (512\*1024)
#define PJSIP\_UDP\_SO\_RCVBUF\_SIZE (512\*1024)
#define PJ\_DEBUG 0
#define PJSIP\_SAFE\_MODULE 0
#define PJ\_HAS\_STRICMP\_ALNUM 0

/\*
 \* Do not ever enable PJ\_HASH\_USE\_OWN\_TOLOWER because the algorithm is
 \* inconsistently used when calculating the hash value and doesn't
 \* convert the same characters as pj\_tolower()/tolower(). Thus you
 \* can get different hash values if the string hashed has certain
 \* characters in it. (ASCII '@', '[', '\\', ']', '^', and '\_')
 \*/
#undef PJ\_HASH\_USE\_OWN\_TOLOWER

/\*
 It is imperative that PJSIP\_UNESCAPE\_IN\_PLACE remain 0 or undefined.
 Enabling it will result in SEGFAULTS when URIs containing escape sequences are encountered.
\*/
#undef PJSIP\_UNESCAPE\_IN\_PLACE
#define PJSIP\_MAX\_PKT\_LEN 32000

#undef PJ\_TODO
#define PJ\_TODO(x)

/\* Defaults too low for WebRTC \*/
#define PJ\_ICE\_MAX\_CAND 32
#define PJ\_ICE\_MAX\_CHECKS (PJ\_ICE\_MAX\_CAND \* PJ\_ICE\_MAX\_CAND)

/\* Increase limits to allow more formats \*/
#define PJMEDIA\_MAX\_SDP\_FMT 64
#define PJMEDIA\_MAX\_SDP\_BANDW 4
#define PJMEDIA\_MAX\_SDP\_ATTR (PJMEDIA\_MAX\_SDP\_FMT\*2 + 4)
#define PJMEDIA\_MAX\_SDP\_MEDIA 16

/\*
 \* Turn off the periodic sending of CRLNCRLN. Default is on (90 seconds),
 \* which conflicts with the global section's keep\_alive\_interval option in
 \* pjsip.conf.
 \*/
#define PJSIP\_TCP\_KEEP\_ALIVE\_INTERVAL 0
#define PJSIP\_TLS\_KEEP\_ALIVE\_INTERVAL 0 

Other common **configure** options needed for pjproject are listed below:



| Library | Configure option | Notes |
| --- | --- | --- |
| [libspeex](http://www.speex.org/) shared objects | `--with-external-speex` | Make sure that the library development headers are accessible from pjproject. The CFLAGS and LDFLAGS environment variables may be used to set the include/lib paths. |
| [libsrtp](https://github.com/cisco/libsrtp) shared objects | `--with-external-srtp` | Make sure that the library development headers are accessible from pjproject. The CFLAGS and LDFLAGS environment variables may be used to set the include/lib paths. |
| GSM codec | `--with-external-gsm` | Make sure that the library development headers are accessible from pjproject. The CFLAGS and LDFLAGS environment variables may be used to set the include/lib paths. |
| Disable sound | `--disable-sound` | Let Asterisk perform sound manipulations. |
| Disable resampling | `--disable-resample` | Let Asterisk perform resample operations. |
| Disable video | `--disable-video` | Disable video support in pjproject's media libraries. This is not used by Asterisk. |
| Disable AMR | --disable-opencore-amr | Disable AMR codec support. This is not used by Asterisk |

These are some of the more common options used to disable third party libraries in pjproject. However, other options may be needed depending on your system - see  **``configure --help``**  for a full list of configure options you can pass to pjproject.

1. 1. Now that you understand the pjproject configure options available, change directories to the pjproject source directory:
	
	# cd pjproject
	2. In the pjproject source directory, run the configure script with the options needed for your system:
	
	# ./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG'A few recommended options are shown. That includes setting a couple important CFLAGS, -O2 for common optimizations and -DNDEBUG to disable debugging code and assertions.
	3. Build pjproject:
	
	# make dep
	# make
	4. Install pjproject
	
	# make install
	5. Update shared library links.
	
	# ldconfig
	6. Verify that pjproject has been installed in the target location by looking for, and finding the various pjproject modules:
	
	# ldconfig -p | grep pj
	 libpjsua.so (libc6,x86-64) => /usr/lib/libpjsua.so
	 libpjsip.so (libc6,x86-64) => /usr/lib/libpjsip.so
	 libpjsip-ua.so (libc6,x86-64) => /usr/lib/libpjsip-ua.so
	 libpjsip-simple.so (libc6,x86-64) => /usr/lib/libpjsip-simple.so
	 libpjnath.so (libc6,x86-64) => /usr/lib/libpjnath.so
	 libpjmedia.so (libc6,x86-64) => /usr/lib/libpjmedia.so
	 libpjmedia-videodev.so (libc6,x86-64) => /usr/lib/libpjmedia-videodev.so
	 libpjmedia-codec.so (libc6,x86-64) => /usr/lib/libpjmedia-codec.so
	 libpjmedia-audiodev.so (libc6,x86-64) => /usr/lib/libpjmedia-audiodev.so
	 libpjlib-util.so (libc6,x86-64) => /usr/lib/libpjlib-util.so
	 libpj.so (libc6,x86-64) => /usr/lib/libpj.so
	7. Finally, verify that Asterisk detects the pjproject libraries. In your Asterisk source directory:
	
	# ./configure
	# make menuselect
	8. Browse to the **Resource Modules** category and verify that the `res_pjsip` modules are enabled:
	9. You're all done!  Now, build and install Asterisk as your normally would.

If you need pjsua (for the testsuite, for example), then you may also need to take a look at  to set that up externally as well.

Troubleshooting
---------------

First, if you're using Asterisk 13.8.0 or greater, consider switching to the Bundled Version of pjproject

### Asterisk fails to detect pjproject libraries

After building and installing pjproject, Asterisk fails to detect any of the libraries - the various res\_pjsip components cannot be selected in Asterisk's menuselect

#### Solution

Verify that Asterisk's config.log shows the following:

configure:23029: checking for PJPROJECT
configure:23036: $PKG\_CONFIG --exists --print-errors "libpjproject"
Package libpjproject was not found in the pkg-config search path.
Perhaps you should add the directory containing `libpjproject.pc'
to the PKG\_CONFIG\_PATH environment variable
No package 'libpjproject' found1. 1. Make sure you have `pkg-config` installed on your system.
	2. pjproject will install the package config file in  `/usr/lib/pkgconfig` . Some distributions, notably Fedora, will instead look for the library in  `/usr/lib64` . Update your  `PKG_CONFIG_PATH`  environment variable with  `/usr/lib/pkgconfig`  and re-run Asterisk's  `configure`  script.

### pjproject fails to build: errors related to opencore\_amr

When building pjproject, errors about opencore\_amr are displayed, e.g.:

output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x60): multiple definition of `pjmedia\_codec\_amrnb\_framelenbits'
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x60): first defined here
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x80): multiple definition of `pjmedia\_codec\_amrnb\_framelen'
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x80): first defined here
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x20): multiple definition of `pjmedia\_codec\_amrwb\_framelenbits'
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x20): first defined here
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x40): multiple definition of `pjmedia\_codec\_amrwb\_framelen'
output/pjmedia-codec-x86\_64-unknown-linux-gnu/opencore\_amr.o:(.rodata+0x40): first defined here
...#### Solution

 You already have the AMR codec installed. Run  `configure`  with the  `--disable-opencore-amr`  option specified. 

###  pjproject fails to build: video linker errors

  When building pjproject, linker errors referring to various video methods are displayed, e.g.:  

/home/mjordan/projects/pjproject/pjmedia/lib/libpjmedia-videodev.so: undefined reference to `pjmedia\_format\_init\_video'
/home/mjordan/projects/pjproject/pjmedia/lib/libpjmedia.so: undefined reference to `pjmedia\_video\_format\_mgr\_instance'
/home/mjordan/projects/pjproject/pjmedia/lib/libpjmedia-videodev.so: undefined reference to `pjmedia\_format\_get\_video\_format\_detail'
/home/mjordan/projects/pjproject/pjmedia/lib/libpjmedia-videodev.so: undefined reference to `pjmedia\_get\_video\_format\_info'#### Solution

Run  `configure`  with either or both  `--disable-video`  or  `--disable-v4l2`

### ldconfig fails to display pjproject libraries

After building pjproject, the dump provided by  `ldconfig -p`  doesn't display any libraries.

#### Solution

 Run  `ldconfig`  to re-configure dynamic linker run-time bindings. This will need to be run with super user permissions.  
  

###  pjproject fails to build on Raspberry Pi

 pjproject/Asterisk fails to compile on your Raspberry Pi (raspbian) due to pjproject configure scripts not detecting endianness:  
  

/usr/include/pj/config.h:243:6: error: #error Endianness must be declared for this processor
In file included from /usr/include/pj/types.h:33:0,
 from /usr/include/pjsip/sip\_config.h:27,
 from /usr/include/pjsip/sip\_types.h:34,
 from /usr/include/pjsip.h:24,
 from conftest.c:290:
/usr/include/pj/config.h:1161:4: error: #error "PJ\_IS\_LITTLE\_ENDIAN is not defined!"
/usr/include/pj/config.h:1165:4: error: #error "PJ\_IS\_BIG\_ENDIAN is not defined!"####  Solution

1. 1. Edit `/usr/include/pj/config.h` (using the editor of your choice)
	2. Replace this code:

 /\*
 \* ARM, bi-endian, so raise error if endianness is not configured
 \*/
# undef PJ\_M\_ARMV4
# define PJ\_M\_ARMV4 1
# define PJ\_M\_NAME "armv4"
# define PJ\_HAS\_PENTIUM 0
# if !PJ\_IS\_LITTLE\_ENDIAN && !PJ\_IS\_BIG\_ENDIAN
# error Endianness must be declared for this processor
# endifWith this:

 /\*
 \* ARM, bi-endian, so raise error if endianness is not configured
 \*/
# undef PJ\_M\_ARMV4
# define PJ\_M\_ARMV4 1
# define PJ\_M\_NAME "armv4"
# define PJ\_HAS\_PENTIUM 0
# define PJ\_IS\_LITTLE\_ENDIAN 1
# define PJ\_IS\_BIG\_ENDIAN 0Then recompile. This workaround was taken from issue [ASTERISK-23315](https://issues.asterisk.org/jira/browse/ASTERISK-23315).

 

uninstalling\_pjproject

Uninstalling a Previous Version of pjproject
============================================

Typically, other versions of pjproject will be installed as static libraries. These libraries are not compatible with Asterisk and can confuse the build process for Asterisk 12. As such, any static libraries must be removed prior to installing the compatible version of pjproject.

pjproject provides an `uninstall` make target that will remove previous installations. It can be called from the pjproject source directory like:

# make uninstallIf you don't have an "uninstall" make target, you may need to fetch and merge the latest pjproject from <https://github.com/asterisk/pjproject>

Alternatively, the following should also remove all previously installed static libraries:

# rm -f /usr/lib/libpj\*.a /usr/lib/libmilenage\*.a /usr/lib/pkgconfig/libpjproject.pcFinally, you will need to update shared library links:

# ldconfigIf you want to run a sanity check, you can verify that pjproject has been uninstalled by ensuring no pjproject modules remain on the system:

# ldconfig -p | grep pjIf running the above command yields no results, that's it! You have successfully uninstalled pjproject from your system. If there are results, you may need to remove other pjproject-related items from /usr/lib as well.

 

 

 

 

 

 

