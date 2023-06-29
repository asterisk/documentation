---
title: Contexts, Extensions, and Priorities
pageid: 4817410
---

Dialplan Format
===============

The dialplan in extensions.conf is organized into sections, called contexts. Contexts are the basic organizational unit within the dialplan, and as such, they keep different sections of the dialplan independent from each other. You can use contexts to separate out functionality and features, enforce security boundaries between the various parts of our dialplan, as well as to provide different classes of service to groups of users.

Dialplan contexts
-----------------

The syntax for a context is exactly the same as any other section heading in the configuration files, as explained in [Sections and Settings](/Sections-and-Settings). Simply place the context name in square brackets. For example, here we define an example context called 'users'.




```javascript title=" " linenums="1"
[users]

```





 

Dialplan extensions
-------------------

Within each context, we can define one or more **extensions**. An extension is simply a named set of actions. Asterisk will perform each action, in sequence, when that extension number is dialed. The syntax for an extension is:




```javascript title=" " linenums="1"
exten => number,priority,application([parameter[,parameter2...]])


```


Let's look at an example extension.




```javascript title=" " linenums="1"
exten => 6001,1,Dial(PJSIP/demo-alice,20)


```


In this case, the extension number is **6001**, the priority number is **1**, the [application](/Configuration/Applications) is **Dial()**, and the two parameters to the application are **PJSIP/demo-alice** and **20**.

Dialplan priorities
-------------------

Within each extension, there must be one or more *priorities*. A priority is simply a sequence number. The first priority on an extension is executed first. When it finishes, the second priority is executed, and so forth.




!!! tip 
    Priority numbers  
[//]: # (end-tip)


  
  


```

javascriptexten => 6123,1,do something
exten => 6123,2,do something else
exten => 6123,4,do something different
  



---


In this case, Asterisk would execute priorities one and two, but would then terminate the call, because it couldn't find priority number three.


```


### Priority letter n

Priority numbers can also be simplified by using the letter **n** in place of the priority numbers greater than one. The letter **n** stands for **next**, and when Asterisk sees priority **n** it replaces it in memory with the previous priority number plus one. Note that you must still explicitly declare priority number one.




```javascript title=" " linenums="1"
exten => 6123,1,NoOp()
exten => 6123,n,Verbose("Do something!")
exten => 6123,n,Verbose("Do something different!")

```




!!! note 
    Every time an extension and priority is executed Asterisk searches for the next best match in priority sequence.

      
[//]: # (end-note)



Consider the dialplan below.




---

  
  


```

exten => 1234,1,Verbose("Valid Number")
exten => 4567,1,Verbose("Another Valid Number")
exten => _.!,1,Verbose("Catch all for invalid numbers")
exten => _.!,n,Verbose("Surprise - executed for all numbers!")

```


It may not be immediately intuitive, but the "_.!" extension with the "n" priority will be executed after any of the preceding lines are executed.

Application calls
-----------------

You'll notice that each priority is calling a dialplan application (such as NoOp, or Verbose in the example above). That is how we tell Asterisk to "do something" with the [channel](/Fundamentals/Key-Concepts/Channels./_Dialplan_Functions/CHANNELS) that is executing dialplan. See the [Applications](/Configuration/Applications) section for more detail.

### Priority labels

You can also assign a label (or alias) to a particular priority number by placing the label in parentheses directly after the priority number, as shown below. Labels make it easier to jump back to a particular location within the extension at a later time.




```javascript title=" " linenums="1"
exten => 6123,1,NoOp()
exten => 6123,n(repeat),Verbose("Do something!")
exten => 6123,n,Verbose("Do something different!")

```


Here, we've assigned a label named **repeat** to the second priority.

Included in the Asterisk 1.6.2 branch (and later) there is a way to avoid having to repeat the extension name/number or pattern using the **same =>** prefix.




```javascript title=" " linenums="1"
exten => 6123,1,NoOp()
 same => n(repeat),Verbose("Do something!")
 same => n,Verbose("Do something different!")

```


Dialplan search order
=====================

The order of matching within a context is always exact extensions, [pattern match](/Configuration/Dialplan/Pattern-Matching) extensions,  [include statements](/Configuration/Dialplan/Include-Statements), and [switch statements](/Configuration/Dialplan/Switch-Statements).  Includes are always processed depth-first.  So for example, if you would like a switch "A" to match before context "B", simply put switch "A" in an included context "C", where "C" is included in your original context before "B".

Search order:

* Explicit extensions
* Pattern match extensions
* Includes
* Switches

Make sure to see the [Pattern Matching](/Configuration/Dialplan/Pattern-Matching) page for a description of pattern matching order.

 

