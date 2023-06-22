---
title: Creating a Simple IVR Menu
pageid: 4817383
---

Let's go ahead and apply what we've learned about the various dialplan applications by building a very simple auto-attendant menu. It is common practice to create an auto-attendant or IVR menu in a new context, so that it remains independant of the other extensions in the dialplan. Please add the following to your dialplan (the **extensions.conf** file) to create a new **demo-menu** context. In this new context, we'll create a simple menu that prompts you to enter one or two, and then it will read back what you're entered.




!!! info "Sample Sound Prompts"
    Please note that the example below (and many of the other examples in this guide) use sound prompts that are part of the *extra* sounds packages. If you didn't install the extra sounds earlier, now might be a good time to do that.

      
[//]: # (end-info)





---

  
  


```

[demo-menu]
exten => s,1,Answer(500)
 same => n(loop),Background(press-1&or&press-2)
 same => n,WaitExten()

exten => 1,1,Playback(you-entered)
 same => n,SayNumber(1)
 same => n,Goto(s,loop)

exten => 2,1,Playback(you-entered)
 same => n,SayNumber(2)
 same => n,Goto(s,loop)

```


Before we can use the demo menu above, we need to add an extension to the **[docs:users]** context to redirect the caller to our menu. Add this line to the **[docs:users]** context in your dialplan:




---

  
  


```

exten => 6598,1,Goto(demo-menu,s,1)


```


Reload your dialplan, and then try dialing extension **6598** to test your auto-attendant menu.

