---
title: Using Templates
pageid: 4817467
---

To use a template when creating another section, simply put the template name in parentheses after the section heading name, as shown in the example below. If you want to inherit from multiple templates, use commas to separate the template names).




---

  
  


```

[template-name](!)
setting=value

[template-2](!)
setting2=value2

[not-a-template]
setting4=value4

[section-name](template-name,template-2,not-a-template)
setting3=value3

```


This works even when the section name referenced in parentheses is **not defined as a template** as in the case of the "not-a-template" section.

The newly-created section will inherit all the values and objects defined in the template(s), as well as any new settings or objects defined in the newly-created section. The settings and objects defined in the newly-created section override settings or objects of the same name from the templates. Consider this example:




---

  
  


```

[test-one](!)
permit=192.168.0.2
host=alpha.example.com
deny=192.168.0.1

[test-two](!)
permit=192.168.1.2
host=bravo.example.com
deny=192.168.1.1

[test-three](test-one,test-two)
permit=192.168.3.1
host=charlie.example.com

```


The [test-three] section will be processed as though it had been written in the following way:




```javascript title=" " linenums="1"
[test-three]
permit=192.168.0.2
host=alpha.example.com
deny=192.168.0.1
permit=192.168.1.2
host=bravo.example.com
deny=192.168.1.1
permit=192.168.3.1
host=charlie.example.com

```


chan_sip Template Example
==========================

Here is a more extensive and realistic example from the chan_sip channel driver's sample configuration file.




---

  
  


```

[basic-options](!) ; a template
 dtmfmode=rfc2833
 context=from-office
 type=friend
 
[natted-phone](!,basic-options) ; another template inheriting basic-options
 nat=yes
 directmedia=no
 host=dynamic
 
[public-phone](!,basic-options) ; another template inheriting basic-options
 nat=no
 directmedia=yes
 
[my-codecs](!) ; a template for my preferred codecs
 disallow=all
 allow=ilbc
 allow=g729
 allow=gsm
 allow=g723
 allow=ulaw
 
[ulaw-phone](!) ; and another one for ulaw-only
 disallow=all
 allow=ulaw
 
; and finally instantiate a few phones
;
; [2133](natted-phone,my-codecs)
; secret = peekaboo
; [2134](natted-phone,ulaw-phone)
; secret = not_very_secret
; [2136](public-phone,ulaw-phone)
; secret = not_very_secret_either

```


