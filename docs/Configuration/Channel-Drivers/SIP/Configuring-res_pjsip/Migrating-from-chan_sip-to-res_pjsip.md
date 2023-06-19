---
title: Migrating from chan_sip to res_pjsip
pageid: 30278068
---

Overview
========

This page documents any useful tools, tips or examples on moving from the old chan\_sip channel driver to the new chan\_pjsip/res\_pjsip added in Asterisk 12.

Configuration Conversion Script
-------------------------------

Contained within a download of Asterisk, there is a Python script, sip\_to\_pjsip.py, found within the contrib/scripts/sip\_to\_pjsip subdirectory, that provides a basic conversion of a sip.conf config to a pjsip.conf config. It is not intended to work for every scenario or configuration; for basic configurations it should provide a good example of how to convert it over to pjsip.conf style config.

To insure that the script can read any [#include'd](/Using-The-include--tryinclude-and-exec-Constructs) files, run it from the /etc/asterisk directory or in another location with a copy of the sip.conf and any included files. The default input file is sip.conf, and the default output file is pjsip.conf. Any included files will also be converted, and written out with a pjsip\_ prefix, unless changed with the --prefix=*xxx* option.

### Command line usage




---

  
  


```

# /path/to/asterisk/source/contrib/scripts/sip\_to\_pjsip/sip\_to\_pjsip.py --help
Usage: sip\_to\_pjsip.py [options] [input-file [output-file]]
input-file defaults to 'sip.conf'
output-file defaults to 'pjsip.conf'
Options:
 -h, --help show this help message and exit
 -p PREFIX, --prefix=PREFIX
 output prefix for include files
 

```



---


### Example of Use




---

  
  


```

# cd /etc/asterisk
# /path/to/asterisk/source/contrib/scripts/sip\_to\_pjsip/sip\_to\_pjsip.py
Reading sip.conf
Converting to PJSIP...
Writing pjsip.conf

```



---


On this Page


Side by Side Examples of sip.conf and pjsip.conf Configuration
==============================================================

These examples contain only the configuration required for sip.conf/pjsip.conf as the configuration for other files should be the same, excepting the Dial statements in your extensions.conf. Dialing with PJSIP is discussed in [Dialing PJSIP Channels](/Dialing-PJSIP-Channels).




---

**Note:**  It is important to know that PJSIP syntax and configuration format is stricter than the older chan\_sip driver. When in doubt, try to follow the documentation exactly, avoid extra spaces or strange capitalization. Always check your logs for warnings or errors if you suspect something is wrong.

  



---


Example Endpoint Configuration
------------------------------

This examples shows the configuration required for:

* two SIP phones need to make calls to or through Asterisk, we also want to be able to call them from Asterisk
* for them to be identified as users (in the old chan\_sip) or endpoints (in the new res\_sip/chan\_pjsip)
* both devices need to use username and password authentication
* 6001 is setup to allow registration to Asterisk, and 6002 is setup with a static host/contact



| sip.conf | pjsip.conf |
| --- | --- |
| 

---



```

[general]
udpbindaddr=0.0.0.0

[6001]
type=friend
host=dynamic
disallow=all
allow=ulaw
context=internal
secret=1234

[6002]
type=friend
host=192.0.2.1
disallow=all
allow=ulaw
context=internal
secret=1234

```



---


   | 

---



```

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0

[6001]
type = endpoint
context = internal
disallow = all
allow = ulaw
aors = 6001
auth = auth6001

[6001]
type = aor
max\_contacts = 1

[auth6001]
type=auth
auth\_type=userpass
password=1234
username=6001

[6002]
type = endpoint
context = internal
disallow = all
allow = ulaw
aors = 6002
auth = auth6002

[6002]
type = aor
contact = sip:6002@192.0.2.1:5060

[auth6002]
type=auth
auth\_type=userpass
password=1234
username=6001

```



---

 |

Example SIP Trunk Configuration
-------------------------------

This shows configuration for a SIP trunk as would typically be provided by an ITSP. That is registration to a remote server, authentication to it and a peer/endpoint setup to allow inbound calls from the provider.

* SIP provider requires registration to their server with a username of "myaccountname" and a password of "1234567890"
* SIP provider requires registration to their server at the address of 203.0.113.1:5060
* SIP provider requires outbound calls to their server at the same address of registration, plus using same authentication details.
* SIP provider will call your server with a user name of "mytrunk". Their traffic will only be coming from 203.0.113.1



| sip.conf | pjsip.conf |
| --- | --- |
| 

---



```

[general]
udpbindaddr=0.0.0.0

register => myaccountname:1234567890@203.0.113.1:5060

[mytrunk]
type=friend
secret=1234567890
username=myaccountname
host=203.0.113.1
disallow=all
allow=ulaw
context=from-external

```



---

 | 

---



```

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0

[mytrunk]
type=registration
outbound\_auth=mytrunk
server\_uri=sip:myaccountname@203.0.113.1:5060
client\_uri=sip:myaccountname@203.0.133.1:5060

[mytrunk]
type=auth
auth\_type=userpass
password=1234567890
username=myaccountname

[mytrunk]
type=aor
contact=sip:203.0.113.1:5060

[mytrunk]
type=endpoint
context=from-external
disallow=all
allow=ulaw
outbound\_auth=mytrunk
aors=mytrunk

[mytrunk]
type=identify
endpoint=mytrunk
match=203.0.113.1

```



---

 |

 

Disabling res\_pjsip and chan\_pjsip
====================================

You may want to keep using chan\_sip for a short time in Asterisk 12+ while you migrate to res\_pjsip. In that case, it is best to disable res\_pjsip unless you understand how to configure them both together.

There are several methods to disable or remove modules in Asterisk. Which method is best depends on your intent.

If you have built Asterisk with the PJSIP modules, but don't intend to use them at this moment, you might consider the following:

1. Edit the file **modules.conf** in your Asterisk configuration directory. (typically /etc/asterisk/)




---

  
  


```

noload => res\_pjsip.so
noload => res\_pjsip\_pubsub.so
noload => res\_pjsip\_session.so
noload => chan\_pjsip.so
noload => res\_pjsip\_exten\_state.so
noload => res\_pjsip\_log\_forwarder.so

```



---


Having a noload for the above modules should (at the moment of writing this) prevent any PJSIP related modules from loading.
2. Restart Asterisk!

Other possibilities would be:

* Remove all PJSIP modules from the modules directory (often, /usr/lib/asterisk/modules)
* Remove the configuration file (pjsip.conf)
* Un-install and re-install Asterisk with no PJSIP related modules.
* If you are wanting to use chan\_pjsip alongside chan\_sip, you could change the port or bind interface of your chan\_pjsip transport in pjsip.conf

Network Address Translation (NAT)
=================================

When configured with **chan\_sip**, peers that are, relative to Asterisk, located behind a NAT are configured using the **nat** parameter.  In versions 1.8 and greater of Asterisk, the following nat parameter options are available:



| Value | Description |
| --- | --- |
| no | Do not perform NAT handling other than [RFC 3581](http://www.ietf.org/rfc/rfc3581.txt). |
| force\_rport | When the rport parameter is not present, send responses to the source IP address and port anyway, as though the rport parameter was present |
| comedia | Send media to the address and port from which Asterisk received it, regardless of where SDP indicates that it should be sent |
| auto\_force\_rport | Automatically enable the sending of responses to the source IP address and port, as though rport were present, if Asterisk detects NAT. Default. |
| auto\_comedia | Automatically send media to the port from which Asterisk received it, regardless of where SDP indicates that it should be sent, if Asterisk detects NAT. |

Versions of Asterisk prior to 1.8 had less granularity for the nat parameter:



| Value | Description |
| --- | --- |
| no | Do not perform NAT handling other than RFC 3581 |
| yes | Send media to the port from which Asterisk received it, regardless of where SDP indicates that it should be sent; send responses to the source IP address and port as though rport were present; and rewrite the SIP Contact to the source address and port of the request so that subsequent requests go to that address and port. |
| never | Do not perform any NAT handling |
| route | Send media to the port from which Asterisk received it, regardless of where SDP indicates that it should be sent and rewrite the SIP Contact to the source address and port of the request so that subsequent requests go to that address and port. |

In **chan\_pjsip**, the **endpoint** options that control NAT behavior are:

* rtp\_symmetric - Send media to the address and port from which Asterisk receives it, regardless of where SDP indicates that it should be sent
* force\_rport - Send responses to the source IP address and port as though port were present, even if it's not
* rewrite\_contact - Rewrite SIP Contact to the source address and port of the request so that subsequent requests go to that address and port.

Thus, the following are equivalent:



| chan\_sip (sip.conf) | chan\_pjsip (pjsip.conf) |
| --- | --- |
| 

---



```

[mypeer1]
type=peer
nat=yes
;...
 
 
 
[mypeer2]
type=peer
nat=no
;...
 
 
 
[mypeer3]
type=peer
nat=never
;...
 
 
 
[mypeer4]
type=peer
nat=route
;...
 
 
 

```



---

 | 

---



```

[mypeer1]
type=endpoint
rtp\_symmetric=yes
force\_rport=yes
rewrite\_contact=yes
;...
 
[mypeer2]
type=endpoint
rtp\_symmetric=no
force\_rport=no
rewrite\_contact=no
;...
 
[mypeer3]
type=endpoint
rtp\_symmetric=no
force\_rport=no
rewrite\_contact=no
;...
 
[mypeer4]
type=endpoint
rtp\_symmetric=no
force\_rport=yes
rewrite\_contact=yes
;...
 

```



---

 |

