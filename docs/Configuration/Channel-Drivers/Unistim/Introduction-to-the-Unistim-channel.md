---
title: Introduction to the Unistim channel
pageid: 4260080
---

Unified Networks IP Stimulus (UNIStim) Channel Driver for Asterisk
==================================================================

This is a channel driver for Unistim protocol. You can use a least a Nortel i2002, i2004 and i2050.

Following features are supported :

* Send/Receive CallerID
* Redial
* SoftKeys
* SendText()
* Music On Hold
* Message Waiting Indication (MWI)
* Distinctive ring
* Transfer
* History
* Forward
* Dynamic SoftKeys.

### How to configure the i2004

1. Power on the phone
2. Wait for message "Nortel Networks"
3. Press quickly the four buttons just below the LCD screen, in sequence from left to right
4. If you see "Locating server", power off or reboot the phone and try again
5. DHCP : 0
6. SET IP : a free ip of your network
7. NETMSK / DEF GW : netmask and default gateway
8. S1 IP : ip of the asterisk server
9. S1 PORT : 5000
10. S1 ACTION : 1
11. S1 RETRY COUNT : 10
12. S2 : same as S1

### How to place a call

The line=> entry in unistim.conf does not add an extension in asterisk by default. If you want to do that, add extension=line in your phone context.

If you have this entry on unistim.conf :

```
 
[violet]
device=006038abcdef
line => 102

```

then use:

```
exten => 2100,1,Dial(USTM/102@violet)

```

You can display a text with :

```
exten => 555,1,SendText(Sends text to client. Greetings) 

```

##### Rebooting a Nortel phone

* Press mute,up,down,up,down,up,mute,9,release(red button)

##### Distinctive ring

1. You need to append /r to the dial string.
2. The first digit must be from 0 to 7 (inclusive). It's the 'melody' selection.
3. The second digit (optional) must be from 0 to 3 (inclusive). It's the ring volume. 0 still produce a sound.

Select the ring style #1 and the default volume :

```
exten => 2100,1,Dial(USTM/102@violet/r1)

```

Select the ring style #4 with a very loud volume :

```
exten => 2100,1,Dial(USTM/102@violet/r43)

```

##### Country code

* You can use the following codes for country= (used for dial tone) - us fr au nl uk fi es jp no at nz tw cl se be sg il br hu lt pl za pt ee mx in de ch dk cn
* If you want a correct ring, busy and congestion tone, you also need a valid entry in indications.conf and check if res_indications.so is loaded.
* language= is also supported but it's only used by Asterisk (for more information see <http://www.voip-info.org/wiki/view/Asterisk+multi-language> ). The end user interface of the phone will stay in english.

##### Bookmarks, Softkeys

**Layout**

```
 |--------------------|
 | 5 2 |
 | 4 1 |
 | 3 0 |

```

* When the second letter of bookmark= is @, then the first character is used for positioning this entry
* If this option is omitted, the bookmark will be added to the next available sofkey
* Also work for linelabel (example : linelabel="5@Line 123")
* You can change a softkey programmatically with SendText(@position@icon@label@extension) ex: SendText(@1@55@Stop Forwd@908)

##### Autoprovisioning

* This feature must only be used on a trusted network. It's very insecure : all unistim phones will be able to use your asterisk pbx.
* You must add an entry called [template](/template). Each new phones will be based on this profile.
* You must set a least line=>. This value will be incremented when a new phone is registered. device= must not be specified. By default, the phone will asks for a number. It will be added into the dialplan. Add extension=line for using the generated line number instead.

Example :

```
[general]
port=5000
autoprovisioning=yes

[template]
line => 100
bookmark=Support@123 ; Every phone will have a softkey Support

```

* If a first phone have a mac = 006038abcdef, a new device named USTM/100@006038abcdef will be created.
* If a second phone have a mac = 006038000000, it will be named USTM/101@006038000000 and so on.
* When autoprovisioning=tn, new phones will ask for a tn, if this number match a tn= entry in a device, this phone will be mapped into.

Example:

```
[black]
tn=1234
line => 100

```

* If a user enter TN 1234, the phone will be known as USTM/100@black.

##### History

* Use the two keys located in the middle of the Fixed feature keys row (on the bottom of the phone) to enter call history.
* By default, chan_unistim add any incoming and outgoing calls in files (/var/log/asterisk/unistimHistory). It can be a privacy issue, you can disable this feature by adding callhistory=0. If history files were created, you also need to delete them. callhistory=0 will NOT disable normal asterisk CDR logs.

##### Forward

* This feature requires chan_local (loaded by default)

##### Generic asterisk features

You can use the following entries in unistim.conf

* Billing - accountcode amaflags
* Call Group - callgroup pickupgroup (untested)
* Music On Hold - musiconhold
* Language - language (see section Coutry Code)
* RTP NAT - nat (control ast_rtp_setnat, default = 0. Obscure behaviour)

##### Trunking

* It's not possible to connect a Nortel Succession/Meridian/BCM to Asterisk via chan_unistim. Use either E1/T1 trunks, or buy UTPS (UNISTIM Terminal Proxy Server) from Nortel.

##### Wiki, Additional infos, Comments :

* <http://www.voip-info.org/wiki-Asterisk+UNISTIM+channels>

##### \*BSD :

* Comment #define HAVE_IP_PKTINFO in chan_unistim.c
* Set public_ip with an IP of your computer
* Check if unistim.conf is in the correct directory

##### Issues

* As always, NAT can be tricky. If a phone is behind a NAT, you should port forward UDP 5000 (or change [general](/general) port= in unistim.conf) and UDP 10000 (or change [yourphone](/yourphone) rtp_port=)
* Only one phone per public IP (multiple phones behind the same NAT don't work). You can either :
	+ Setup a VPN
	+ Install asterisk inside your NAT. You can use IAX2 trunking if you're master asterisk is outside.
	+ If asterisk is behind a NAT, you must set [general](/general) public_ip= with your public IP. If you don't do that or the bindaddr is invalid (or no longer valid, eg dynamic IP), phones should be able to display messages but will be unable to send/receive RTP packets (no sound)
* Don't forget : this work is based entirely on a reverse engineering, so you may encounter compatibility issues. At this time, I know three ways to establish a RTP session. You can modify [yourphone](/yourphone) rtp_method= with 0, 1, 2 or 3. 0 is the default method, should work. 1 can be used on new firmware (black i2004) and 2 on old violet i2004. 3 can be used on black i2004 with chrome.
* If you have difficulties, try unistim debug and set verbose 3 on the asterisk CLI. For extra debug, uncomment #define DUMP_PACKET 1 and recompile chan_unistim.
