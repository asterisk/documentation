---
title: Goto Application and Priority Labels
pageid: 4817387
---

Before we create a simple auto-attendant menu, let's cover a couple of other useful dialplan applications. The **Goto()** application allows us to jump from one position in the dialplan to another. The parameters to the **Goto()** application are slightly more complicated than with the other applications we've looked at so far, but don't let that scare you off.


The **Goto()** application can be called with either one, two, or three parameters. If you call the **Goto()** application with a single parameter, Asterisk will jump to the specified priority (or its label) within the current extension. If you specify two parameters, Asterisk will read the first as an extension within the current context to jump to, and the second parameter as the priority (or label) within that extension. If you pass three parameters to the application, Asterisk will assume they are the context, extension, and priority (respectively) to jump to.




```javascript title=" " linenums="1"
[StartingContext]
exten => 100,1,Goto(monkeys)
 same => n,NoOp(We skip this)
 same => n(monkeys),Playback(tt-monkeys)
 same => n,Hangup()

exten => 200,1,Goto(start,1) ; play tt-weasels then tt-monkeys

exten => 300,1,Goto(start,monkeys) ; only play tt-monkeys

exten => 400,1,Goto(JumpingContext,start,1) ; play hello-world

exten => start,1,NoOp()
 same => n,Playback(tt-weasels)
 same => n(monkeys),Playback(tt-monkeys)

[JumpingContext]
exten => start,1,NoOp()
 same => n,Playback(hello-world)
 same => n,Hangup()


```


