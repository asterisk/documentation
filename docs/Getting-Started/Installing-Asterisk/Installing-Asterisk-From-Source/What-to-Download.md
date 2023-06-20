---
title: What to Download?
pageid: 4817506
---

Asterisk
========

Downloads of Asterisk are available at <https://downloads.asterisk.org/pub/telephony/asterisk/>. The currently supported versions of Asterisk will each have a symbolic link to their related release on this server, named **asterisk-{version}-current****.tar.gz**. All releases ever made for the Asterisk project are available at <https://downloads.asterisk.org/pub/telephony/asterisk/releases/>.

The currently supported versions of Asterisk are documented on the [Asterisk Versions](/About-the-Project/Asterisk-Versions) page. It is highly recommended that you install one of the currently supported versions, as these versions continue to receive bug and security fixes.




---

**Tip: Which version should I install?** * If you want a rock solid communications framework, choose the latest **Long Term Support (LTS)** release.
* If you want the latest cool features and capabilities, choose the latest release of Asterisk. If that is a **Standard** release, note that these releases may have larger changes made in them than LTS releases.

Unless otherwise noted, for the purposes of this section we will assume that Asterisk 14 is being installed.

  



---


Review Asterisk's [System Requirements](/Operation/System-Requirements) in order to determine what needs to be installed for the version of Asterisk you are installing. While Asterisk will look for any missing system requirements during compilation, it's often best to install these prior to configuring and compiling Asterisk.

Asterisk does come with a script, **install\_prereq**, to aid in this process. If you'd like to use this script, download Asterisk first, then see [Checking Asterisk Requirements](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Checking-Asterisk-Requirements) for instructions on using this script to install prerequisites for your version of Asterisk.

On this PageDownloading Asterisk
--------------------

Browse to <https://downloads.asterisk.org/pub/telephony/asterisk>, select [asterisk-14-current.tar.gz](https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz), and save the file on your file system.

You can also get the latest releases from the downloads page on [asterisk.org](http://asterisk.org/downloads).

Alternatively, you can us`e [wget](https://www.gnu.org/software/wget/)` to retrieve the latest release:




---

  
  


```

[root@server:/usr/local/src]# wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz
--2017-04-28 15:45:36-- https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz
Resolving downloads.asterisk.org (downloads.asterisk.org)... 76.164.171.238
Connecting to downloads.asterisk.org (downloads.asterisk.org)|76.164.171.238|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40692588 (39M) [application/x-gzip]
Saving to: ‘asterisk-14-current.tar.gz’

asterisk-14-current.tar.gz 100%[======================================================================>] 38.81M 3.32MB/s in 12s 

2017-04-28 15:45:47 (3.37 MB/s) - ‘asterisk-14-current.tar.gz’ saved [40692588/40692588]

```



---


Other Projects
==============

libpri
------

The **libpri** library allows Asterisk to communicate with ISDN connections.You'll only need this if you are going to use DAHDI with ISDN interface hardware (such as T1/E1/J1/BRI cards).

DAHDI
-----

The **DAHDI** library allows Asterisk to communicate with analog and digital telephones and telephone lines, including connections to the Public Switched Telephone Network, or PSTN.

DAHDI stands for Digium Asterisk Hardware Device Interface, and is a set of drivers and utilities for a number of analog and digital telephony cards, such as those manufactured by Digium. The DAHDI drivers are independent of Asterisk, and can be used by other applications. DAHDI was previously called Zaptel, as it evolved from the Zapata Telephony Project.

The DAHDI code can be downloaded as individual pieces (**dahdi-linux** for the DAHDI drivers, and **dahdi-tools** for the DAHDI utilities. They can also be downloaded as a complete package called **dahdi-linux-complete**, which contains both the Linux drivers and the utilities.

You will only need to install DAHDI if you are going to utilize DAHDI compatible analog or digital telephony interface boards.




---

**Tip: Why is DAHDI split into different pieces?** DAHDI has been split into two pieces (the Linux drivers and the tools) as third parties have begun porting the DAHDI drivers to other operating systems, such as FreeBSD. Eventually, we may have dahdi-linux, dahdi-freebsd, and so on.

  



---


Download Locations
==================



| Project | Location |
| --- | --- |
| Asterisk | <https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz> |
| libpri | <https://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz> |
| dahdi-linux | <https://downloads.asterisk.org/pub/telephony/dahdi-linux/dahdi-linux-current.tar.gz> |
| dahdi-tools | <https://downloads.asterisk.org/pub/telephony/dahdi-tools/dahdi-tools-current.tar.gz> |
| dahdi-complete | <https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz> |

 

 

