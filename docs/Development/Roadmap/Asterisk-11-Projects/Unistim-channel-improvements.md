---
title: Unistim channel improvements
pageid: 19008446
---

{numberedheadings}{numberedheadings}
Overview
========


I have met many peoples that wondering if there is pure VoIP phones exists that cost lower than $50. Also support for this phones may be usefull for them who still use this phones, but want to migrate to Asterisk, so old phones can be still used and investment for such transition get lower. Not much peoples know, that there is many Nortel phones sold for low price. An there is asterisk channel that allows it usage. This channel in asterisk for a while but after was added to trunk have not developed and supported. I proud to describe work had been done for support more functions on that phones.


Main improvement done - support in code multiple lines usage on phone. Now user of phone not limited by only one concurrent call made, it is a really big step forward. On more major thing - support for other then English language, phone by itself able to output characters in different encodings and now able to display menus and other information in different languages. Third, many code improvements made to make channel and phone usage more stable and use more asterisk abilities.


Table of Contents
=================


20pxdisc
Features
========


Multiple lines support
----------------------


Using multiple line on Unistim phones was on of the most desired functions users asked for. For making it possible most of code was modified. Now every button near the screen can be used as line button. So phone can use from 1 to 4 (for i2002) or 6 (for i2004). Additional features added by implementing multiline support:


* Call Hold
* Call Waiting (when same line defined 2 times and more)
* Switching between active calls and making new calls


Phone with two lines defined
[violet]
device=006038abcdef
callerid = "Violet" <660100> ; Individual callerid used for each line 
line => 100 ; Key #1 - can be called Unistim/100@violet
line => 100 ; Key #2 - blinks when second call comes to 100
callerid = "Shared" <660000> ; Callerid uses old zaptel.conf like syntax
line => 200 ; Key #3 - rings on Unistim/100@violet

Multiple languages support
--------------------------


Added ability for translation on-screen menu to multiple languages. Tested on Russian language, next step - translate to other that use supported encondings (ISO 8859-1, ISO 8859-2, ISO 8859-4, ISO 8859-5, ISO 2022-JP). Language controlled by 'language' configuration option and on-screen menu of phone, also updated on phone after 'unistim reload' CLI executed. All text output tryed to be translated, so even callerid names can be translated (just need to put translated strings to translation file)


Translation files store original (English) string and its translation and based on gettext .po files (but not use gettext). Also files stored in in target enconding for usage without iconv. Configuration stored in folder unistimLang in ASTLIBDIR (default: /var/lib/asterisk/unistimLang). List of languages hardcoded for now in chan\_unistim.c source file and need to be updated while new languages added.


Change way of number input
--------------------------


Previous version of chan\_unistim have limitations on number input. Input field was limited by size, and have no scroll if enough big international number was dialed. So number input was reworked:


* Number input now have scroll, so it is easier to input an correct number
* On digit input number compared with dialplan, and if full number dialed - number dialed immediately. Also you prevented from entering wrong number.
* Number can be dialed by timeout, pressing 'Dial' button not required (4 second by default)


Improved support for 1-line display phones
------------------------------------------


As soon as all testing and development done on i2002 phones, there is much improvements for displaying information on its small screen. Also type of device received from phone in initial boot sequence and device screen height not needed to be configured manually, other options depends on phone model and firmware later also can be detected automatically.


Call pickup
-----------


Unistim.conf config file have before 'callgroup' and 'pickupgroup' options, but phone itself was unable to pickup any calls. Now there is added programable on screen button 'Pickup', also dialing combination configured in pickup.conf can help you picking up a call. 


Other
-----


There is much other small functions that may help you in using Unistim phones, I'll tell in short:


* History listing improved. History can be scrolled and show more information about call.
* Tones read from indications.conf instead of using hardcoded values. DTMF tones also calculated.
* Connected line update now supported and changed party id and name shown on screen.
* All LEDs now correctly show state of phone and not light forever after you press wrong button.


Configuration options (global)
==============================


* Added 'debug' option, that enables debug in channel driver. It may help to enable debug on startup while debugging phone state. Done along with improving debug, showing names of state instead of numeric values.


Device options
==============


* Added option 'sharpdial' allowing end dialing by pressing # key
* Added option 'cwstyle' to control style of callwaiting ring
* Added option 'cwvolume' to change callwaiting ring volume


CLI commands
============


There is not much new CLI commands, but output of command exists improved and give more information about phones and sessions. There is command 'unistim show devices' added, that display configured devices in style of 'sip show peers' command.


Missed functions
================


There is still some desired functions missed and please do not look for it in updated chan\_unistim:


* 3-way call still not implemented
* mute button still mute both parties


