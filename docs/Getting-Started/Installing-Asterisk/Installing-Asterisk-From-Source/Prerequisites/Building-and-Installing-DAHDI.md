---
title: Building and Installing DAHDI
pageid: 4817510
---

Overview
========

Let's install DAHDI!

On Linux, we will use the **DAHDI-linux-complete** tarball, which contains the DAHDI Linux drivers, DAHDI tools, and board firmware files. Again, we're assuming that you've untarred the tarball in the `/usr/local/src` directory, and that you'll replace X and Y with the appropriate version numbers.

See [What to Download?](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/What-to-Download) for more information on downloading the DAHDI tarballs.




!!! note Install DAHDI before libpri
    libpri 1.4.13 and later source code depends on DAHDI include files. So, one must install DAHDI before installing libpri.

      
[//]: # (end-note)





!!! note Don't need DAHDI?
    If you are not integrating with any traditional telephony equipment and you are not planning on using the [MeetMe](/Latest_API/API_Documentation/Dialplan_Applications/MeetMe) dialplan application, then you do not have to install DAHDI or libpri in order to use Asterisk.

      
[//]: # (end-note)



On This Page

Starting with DAHDI-Linux-complete version 2.8.0+2.8.0, all files necessary to install DAHDI are available in the complete tarball. Therefore, all you need to do to install DAHDI is:

```
[root@server src]# cd dahdi-linux-complete-2.X.Y+2.X.Y

[root@server dahdi-linux-complete-2.X.Y+2.X.Y]# make

[root@server dahdi-linux-complete-2.X.Y+2.X.Y]# make install

[root@server dahdi-linux-complete-2.X.Y+2.X.Y]# make config 

```





