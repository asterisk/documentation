---
title: Setting and Substituting Channel Variables
pageid: 4620350
---

Parameter strings can include variables. Variable names are arbitrary strings. They are stored in the respective channel structure.

To **set** a variable to a particular value, do:




---

  
  


```

exten => 1,2,Set(varname=value)


```



---


You can **substitute** the value of a variable everywhere using ${variablename}.

Here is a simple example.




---

  
  


```

exten => 1,1,Set(COUNT=3)
exten => 1,n,SayNumber(${COUNT})

```



---


In the second line of this example, Asterisk replaces the ${COUNT} text with the value of the COUNT variable, so that it ends up calling SayNumber(3).

For another example, to stringwise append $varname2 to $varname3 and store result in $varname1, do:




---

  
  


```

exten => 1,2,Set(varname1=${varname2}${varname3})


```



---


There are two reference modes - reference by value and reference by name. To refer to a variable with its name (as an argument to a function that requires a variable), just write the name. To refer to the variable's value, enclose it inside ${}. For example, Set takes as the first argument (before the =) a variable name, so:




---

  
  


```

exten => 1,2,Set(varname1=varname2)
exten => 1,3,Set(${varname1}=value)


```



---


The above dialplan stores to the variable "varname1" the value "varname2" and to variable "varname2" the value "value".

In fact, everything contained ${here} is just replaced with the value of the variable "here".

