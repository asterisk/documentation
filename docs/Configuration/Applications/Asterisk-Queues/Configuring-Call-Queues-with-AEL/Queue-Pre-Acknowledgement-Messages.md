---
title: Queue Pre-Acknowledgement Messages
pageid: 5243040
---

If you would like to have a pre acknowledge message with option to reject the message you can use the following dialplan Macro as a base with the 'M' dial argument.

```

[macro-screen]
exten=>s,1,Wait(.25)
exten=>s,2,Read(ACCEPT,screen-callee-options,1) 
exten=>s,3,Gotoif($[${ACCEPT} = 1] ?50) 
exten=>s,4,Gotoif($[${ACCEPT} = 2] ?30) 
exten=>s,5,Gotoif($[${ACCEPT} = 3] ?40) 
exten=>s,6,Gotoif($[${ACCEPT} = 4] ?30:30) 
exten=>s,30,Set(MACRO_RESULT=CONTINUE) 
exten=>s,40,Read(TEXTEN,custom/screen-exten,) 
exten=>s,41,Gotoif($[${LEN(${TEXTEN})} = 3]?42:45) 
exten=>s,42,Set(MACRO_RESULT=GOTO:from-internal^${TEXTEN}^1) 
exten=>s,45,Gotoif($[${TEXTEN} = 0] ?46:4) 
exten=>s,46,Set(MACRO_RESULT=CONTINUE) 
exten=>s,50,Playback(after-the-tone) 
exten=>s,51,Playback(connected) 
exten=>s,52,Playback(beep)

```

