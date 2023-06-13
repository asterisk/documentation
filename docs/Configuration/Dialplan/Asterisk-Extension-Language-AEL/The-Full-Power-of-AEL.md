---
title: The Full Power of AEL
pageid: 4816920
---

A newcomer to Asterisk will look at the above constructs and descriptions, and ask, "Where's the string manipulation functions?", "Where's all the cool operators that other languages have to offer?", etc. 


The answer is that the rich capabilities of Asterisk are made available through AEL, via:


* Applications: See Asterisk - documentation of application commands
* Functions: Functions were implemented inside ${ .. } variable references, and supply many useful capabilities.
* Expressions: An expression evaluation engine handles items wrapped inside $[...]. This includes some string manipulation facilities, arithmetic expressions, etc.
* Application Gateway Interface: Asterisk can fork external processes that communicate via pipe. AGI applications can be written in any language. Very powerful applications can be added this way.
* Variables: Channels of communication have variables associated with them, and asterisk provides some global variables. These can be manipulated and/or consulted by the above mechanisms.


