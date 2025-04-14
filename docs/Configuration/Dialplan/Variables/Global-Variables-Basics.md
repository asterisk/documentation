---
title: Global Variables Basics
pageid: 4817403
---

Global variables are variables that don't live on one particular channel — they pertain to all calls on the system. They have global scope. There are two ways to set a global variable. The first is to declare the variable in the **[globals]** section of **extensions.conf**, like this:

```conf title=" " linenums="1"
[globals]
MYGLOBALVAR=somevalue

```

You can also set global variables from dialplan logic using the **GLOBAL()** dialplan function along with the **Set()** application. Simply use the syntax:

```conf title=" " linenums="1"
exten=>6124,1,Set(GLOBAL(MYGLOBALVAR)=somevalue)

```

To retrieve the value of a global channel variable, use the same syntax as you would if you were retrieving the value of a channel variable.
