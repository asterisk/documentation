---
title: Configuring Localized Tone Indications
pageid: 30278454
---

Overview
========

In certain cases Asterisk will generate tones to be used in call signaling. It may be during the use of a specific application, or with certain channel drivers. The tones used are configurable and may be defined by location.

Note that the tones configured here are only used when Asterisk is directly generating the tones.

Configuration
=============

The configuration file for location specific tone indications is **indications.conf**. It is read from the typical [Asterisk configuration directory](/Directory+and+File+Structure). You can also view the sample of indications.conf file in your source directory at configs/modules.conf.sample or on [SVN at this link](http://svnview.digium.com/svn/asterisk/trunk/configs/samples/indications.conf.sample?view=markup).

The configuration itself consists of a 'general' section and then one or more country specific sections. (e.g. '[au]' for Australia)

Within the general section, only the **country** option can be set. This option sets the default location tone set to be used.




---

  
  


```

[general]
country=us

```



---


As an example, the above set the default country to the tone set for the USA.

Within any location specific configuration, several tone types may be configured.

* description = string ;      The full name of your country, in English.
* ringcadence = num[,num]\*  ;      List of durations the physical bell rings.
* dial = tonelist   ;      Set of tones to be played when one picks up the hook.
* busy = tonelist  ;      Set of tones played when the receiving end is busy.
* congestion = tonelist   ;      Set of tones played when there is some congestion (on the network?)
* callwaiting = tonelist    ;      Set of tones played when there is a call waiting in the background.
* dialrecall = tonelist     ;      Not well defined; many phone systems play a recall dial tone after hook flash
* record = tonelist  ;      Set of tones played when call recording is in progress.
* info = tonelist  ;      Set of tones played with special information messages (e.g., "number is out of service")
* 'name' = tonelist  ;      Every other variable will be available as a shortcut for the "PlayList" command but will not be used automatically by Asterisk.

Explanation of the 'tonelist' usage:
------------------------------------




---

  
  


```

; The tonelist itself is defined by a comma-separated sequence of elements.
; Each element consist of a frequency (f) with an optional duration (in ms)
; attached to it (f/duration). The frequency component may be a mixture of two
; frequencies (f1+f2) or a frequency modulated by another frequency (f1\*f2).
; The implicit modulation depth is fixed at 90%, though.
; If the list element starts with a !, that element is NOT repeated,
; therefore, only if all elements start with !, the tonelist is time-limited,
; all others will repeat indefinitely.
;
; concisely:
; element = [!]freq[+|\*freq2][/duration]
; tonelist = element[,element]\*

```



---


 

Example of a location specific tone configuration:
--------------------------------------------------




---

  
  


```

[br]
description = Brazil
ringcadence = 1000,4000
dial = 425
busy = 425/250,0/250
ring = 425/1000,0/4000
congestion = 425/250,0/250,425/750,0/250
callwaiting = 425/50,0/1000
; Dialrecall not used in Brazil standard (using UK standard)
dialrecall = 350+440
; Record tone is not used in Brazil, use busy tone
record = 425/250,0/250
; Info not used in Brazil standard (using UK standard)
info = 950/330,1400/330,1800/330
stutter = 350+440

```



---


