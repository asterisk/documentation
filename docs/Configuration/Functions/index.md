---
title: Overview
pageid: 27200281
---




---

**WARNING!:**   
Under Construction

  



---


Asterisk Dialplan Functions
===========================

Asterisk functions are very similar to functions in many programming languages.

Functions are:

* Sophisticated subroutines that help you manipulate data in a variety of ways.
* Callable from within dialplan and Asterisk's various interfaces.

Compared to Dialplan Applications:

* Dialplan Functions tend to be geared towards manipulating channel data and attributes as well as providing general tools for manipulating data in variables and expressions, whether they are channel related or not.
* [Dialplan Applications](/Configuration/Applications) tend to take over the channel and provide more complex features to the channel.

Both will be typically be used with a channel but in different ways. For example you may send a channel to an application such as Playback and then let it fly, but with functions you might use one or many functions in a single expression to manipulate or move around data related to the channels operation.

Applications and functions are regularly used together and as you use them you'll see that the distinction between applications and the more powerful functions can sometimes be murky.

In This Section 

Available functions
-------------------

Many functions come with Asterisk by default. For a complete list of the dialplan functions available to your installation of Asterisk, type **core show functions** at the Asterisk CLI. Not all functions are compiled with Asterisk by default, so if you have the source available then you may want to browse the functions listed in [menuselect](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) under "Dialplan Functions". Dedicated function modules start with "func\_", but the core or other large modules may provide functions as well.

Since anyone can write an Asterisk module they can also be obtained from sources outside the Asterisk distribution. Pre-packaged community or commercial Asterisk distributions that have a special purpose may include a custom function or two.

General function syntax
-----------------------

The general syntax for calling a function follows:




---

  
  


```

FUNCTION(argument1,argument2, ...)

```



---


A function's value can be set using the Set application. The example below will show how to set the CHANNEL function argument "tonezone" to the value "de" (for Germany).




---

  
  


```

same => n,Set(CHANNEL(tonezone)=de)

```



---


A function's value can be referenced almost anywhere in dialplan where you can use an expression or reference a variable. The value can be referenced by encapsulating the call with curly braces and a leading dollar sign.




---

  
  


```

${FUNCTION(argument)}

```



---


For example, if we wanted to log the destination address for the audio stream of the channel:




---

  
  


```

same => n,Log(NOTICE, The destination for the audio stream is: ${CHANNEL(rtp,dest)})

```



---


Help for specific functions
---------------------------

The wiki section CLI Syntax and Help Commands details how to use the CLI-accessible documentation. This will allow you to access the syntax and usage info for each function including detail on all the arguments for each function.

Wikibot also publishes the same documentation on the wiki. You can find function docs in the version specific top level sections; such as Asterisk 13 Dialplan Functions.

