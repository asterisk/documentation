---
title: Signaling System Number 7
pageid: 4260059
---




!!! warning 
    The LibSS7 project is not actively developed or maintained.

      
[//]: # (end-warning)



### Where to get LibSS7?

Currently, all released branches of Asterisk including trunk use the released versions of libss7.

The latest compatible libss7 code can be obtained from the [1.0 SVN branch](http://svn.asterisk.org/svn/libss7/branches/1.0)

As of 7/2013, the libss7 trunk ([http://svn.asterisk.org/svn/libss7/trunk](http://svn.asterisk.org/svn/libss7/trunk)(http://svn.asterisk.org/svn/libss7/branches/1.0)) is currently only usable with this Asterisk branch ([http://svn.asterisk.org/svn/asterisk/team/rmudgett/ss7_27_knk](http://svn.asterisk.org/svn/asterisk/team/rmudgett/ss7_27_knk)(http://svn.asterisk.org/svn/libss7/branches/1.0)) based off of Asterisk trunk.

##### Tested Switches:

* Siemens EWSD - (ITU style) MTP2 and MTP3 comes up, ISUP inbound and outbound calls work as well.
* DTI DXC 4K - (ANSI style) 56kbps link, MTP2 and MTP3 come up, ISUP inbound and outbound calls work as well.
* Huawei M800 - (ITU style) MTP2 and MTP3 comes up, ISUP National, International inbound and outbound calls work as well, CallerID presentation&screening work.

and MORE~!

##### Thanks:

Mark Spencer, for writing Asterisk and libpri and being such a great friend and boss.

Luciano Ramos, for donating a link in getting the first "real" ITU switch working.

Collin Rose and John Lodden, John for introducing me to Collin, and Collin for the first "real" ANSI link and for holding my hand through the remaining changes that had to be done for ANSI switches.

##### To Use:

In order to use libss7, you must get at least the following versions of DAHDI and Asterisk:  


You must then do a `make; make install` in each of the directories that you installed in the given order (DAHDI first, libss7 second, and Asterisk last).




!!! note 
    In order to check out the code, you must have the subversion client installed. This is how to check them out from the public subversion server.

    These are the commands you would type to install them:
[//]: # (end-note)


  
  

```
`svn co http://svn.digium.com/svn/dahdi/linux/trunk dahdi-trunk`
`cd dahdi-trunk`
`make; make install`

`svn co http://svn.digium.com/svn/dahdi/tools/trunk dahdi-tools`
`cd dahdi-tools`
`./configure; make; make install`

`svn co http://svn.digium.com/svn/libss7/trunk libss7-trunk`
`cd libss7-trunk`
`make; make install`

`svn co http://svn.digium.com/svn/asterisk/trunk asterisk-trunk`
`cd asterisk-trunk`
`./configure; make; make install;`
  



---


This should build DAHDI, libss7, and Asterisk with SS7 support.

```

In the past, there was a special asterisk-ss7 branch to use which contained the SS7 code. That code has been merged back into the trunk version of Asterisk, and the old asterisk-ss7 branch has been deprecated and removed. If you are still using the asterisk-ss7 branch, it will not work against the current version of libss7, and you should switch to asterisk-trunk instead.

##### Configuration:

In /etc/dahdi/system.conf, your signalling channel(s) should be a "dchan" and your bearers should be set as "bchan".

The sample chan_dahdi.conf contains sample configuration for setting up an E1 link.

In brief, here is a simple ss7 linkset setup:

```
signalling = ss7
ss7type = itu ; or ansi if you are using an ANSI link

linkset = 1 ; Pick a number for your linkset identifier in chan_dahdi.conf

pointcode = 28 ; The decimal form of your point code. If you are using an
 ; ANSI linkset, you can use the xxx-xxx-xxx notation for
 ; specifying your link
adjpointcode = 2 ; The point code of the switch adjacent to your linkset

defaultdpc = 3 ; The point code of the switch you want to send your ISUP
 ; traffic to. A lot of the time, this is the same as your
 ; adjpointcode.

; Now we configure our Bearer channels (CICs)

cicbeginswith = 1 ; Number to start counting the CICs from. So if DAHDI/1 to
 ; DAHDI/15 are CICs 1-15, you would set this to 1 before you
 ; declare channel=1-15

channel=1-15 ; Use DAHDI/1-15 and assign them to CICs 1-15

cicbeginswith = 17 ; Now for DAHDI/17 to DAHDI/31, they are CICs 17-31 so we initialize
 ; cicbeginswith to 17 before we declare those channels

channel = 17-31 ; This assigns CICs 17-31 to channels 17-31

sigchan = 16 ; This is where you declare which DAHDI channel is your signalling
 ; channel. In our case it is DAHDI/16. You can add redundant
 ; signalling channels by adding additional sigchan= lines.
 
; If we want an alternate redundant signalling channel add this

sigchan = 48 ; This would put two signalling channels in our linkset, one at
 ; DAHDI/16 and one at DAHDI/48 which both would be used to send/receive
 ; ISUP traffic.

; End of chan_dahdi.conf

```

This is how a basic linkset is setup. For more detailed chan_dahdi.conf SS7 config information as well as other options available for that file, see the default chan_dahdi.conf that comes with the samples in asterisk. If you would like, you can do a `make samples` in your asterisk-trunk directory and it will install a sample chan_dahdi.conf for you that contains  


For more information, you can ask questions of the community on the asterisk-ss7 or asterisk-dev mailing lists.

