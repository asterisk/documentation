---
title: Built-in Dynamic Features
pageid: 21463260
---

The [FEATURE](/Asterisk-11-Function_FEATURE) and [FEATUREMAP](/Asterisk-11-Function_FEATUREMAP) dialplan functions allow you to set some features.conf options on a per channel basis.




---


**Information:**  To see what options are currently supported, look at the FEATURE and FEATUREMAP function descriptions. **These functions were added in Asterisk 11.**

At this time the functions do not work with custom features. Those are set with a channel variable as described in the [Custom Dynamic Features](/Custom-Dynamic-Features) section.

  



---




---

  
Set the parking time of this channel to be 100 seconds if it is parked.  


```

exten => s,1,Set(FEATURE(parkingtime)=100)
same => n,Dial(SIP/100)
same => n,Hangup()


```



---




---

  
Set the DTMF sequence for attended transfer on this channel to \*9.  


```

exten => s,1,Set(FEATUREMAP(atxfer)=\*9)
same => n,Dial(SIP/100,,T)
same => n,Hangup()


```



---


