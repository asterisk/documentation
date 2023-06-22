---
title: Background and WaitExten Applications
pageid: 4817385
---

The **Background()** application plays a sound prompt, but listens for DTMF input. Asterisk then tries to find an extension in the current dialplan context that matches the DTMF input. If it finds a matching extension, Asterisk will send the call to that extension.


The Background() application takes the name of the sound prompt as the first parameter just like the Playback() application, so remember not to include the file extension.




!!! tip Multiple Prompts
    If you have multiple prompts you'd like to play during the Background() application, simply concatenate them together with the ampersand (&) character, like this:
[//]: # (end-tip)


  
  


```

javascriptexten => 6123,1,Background(prompt1&prompt2&prompt3)
  



---



```


One problems you may encounter with the **Background()** application is that you may want Asterisk to wait a few more seconds after playing the sound prompt. In order to do this, you can call the **WaitExten()** application. You'll usually see the **WaitExten()** application called immediately after the **Background()** application. The first parameter to the **WaitExten()** application is the number of seconds to wait for the caller to enter an extension. If you don't supply the first parameter, Asterisk will use the built-in response timeout (which can be modified with the **TIMEOUT()** dialplan function).




```javascript title=" " linenums="1"
[auto\_attendant]
exten => start,1,Verbose(2,Incoming call from ${CALLERID(all)})
 same => n,Playback(silence/1)
 same => n,Background(prompt1&prompt2&prompt3)
 same => n,WaitExten(10)
 same => n,Goto(timeout-handler,1)

exten => timeout-handler,1)
 same => n,Dial(${GLOBAL(OPERATOR)},30)
 same => n,Voicemail(operator@default,${IF($[${DIALSTATUS} = BUSY]?b:u)})
 same => n,Hangup()

```


