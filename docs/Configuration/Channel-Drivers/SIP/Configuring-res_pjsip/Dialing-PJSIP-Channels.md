---
title: Dialing PJSIP Channels
pageid: 30278070
---

Dialing from dialplan
=====================

We are assuming you already know a little bit about the Dial application here. To see the full help for it, see "core show application Dial" on the Asterisk CLI, or see [Dial](/Application_Dial).

Below we'll simply dial an endpoint using the chan_pjsip channel driver. This is really going to look at the AOR of the same name as the endpoint and start dialing the first contact associated.




---

  
  


```

exten => _6XXX,1,Dial(PJSIP/${EXTEN})

```


To dial all the contacts associated with the endpoint, use the `PJSIP_DIAL_CONTACTS()` function. It evaluates to a list of contacts separated by `&`, which causes the Dial application to call them simultaneously.




---

  
  


```

exten => _6XXX,1,Dial(${PJSIP_DIAL_CONTACTS(${EXTEN})})

```


Heres how you would dial with an explicit SIP URI, user and domain, via an endpoint (in this case dialing out a trunk), but not using its associated AOR/contact objects.




---

  
  


```

exten => _9NXXNXXXXXX,1,Dial(PJSIP/mytrunk/sip:${EXTEN:1}@203.0.113.1:5060)

```


This uses a contact(and its domain) set in the AOR associated with the **mytrunk** endpoint, but still explicitly sets the user portion of the URI in the dial string. For the AOR's contact, you would define it in the AOR config without the user name.




---

  
  


```

exten => _9NXXNXXXXXX,1,Dial(PJSIP/${EXTEN:1}@mytrunk)

```


