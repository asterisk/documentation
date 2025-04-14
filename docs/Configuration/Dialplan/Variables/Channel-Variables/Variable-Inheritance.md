---
title: Variable Inheritance
pageid: 4620353
---

Single Inheritance
==================

[Variable](/Configuration/Dialplan/Variables/Channel-Variables) names which are prefixed by "_" (one underbar character) will be inherited to [channels](/Fundamentals/Key-Concepts/Channels) that are created in the process of servicing the original channel in which the variable was set. When the inheritance takes place, the prefix will be removed in the channel inheriting the variable. Meaning it will not be inherited any further than a single level, that is one child channel.

```
exten = 1234,1,Set(_FOO=bar)

```

Multiple Inheritance
====================

If the name is prefixed by "__" (two underbar characters) in the channel, then the variable is inherited and the "__" will remain intact in the new channel. Therefore any channels then created by the new channel will also receive the variable with "__", continuing the inheritance indefinitely.

In the [Dialplan](/Configuration/Dialplan), all references to these variables refer to the same variable, regardless of having a prefix or not. Note that setting any version of the variable removes any other version of the variable, regardless of prefix.

```
exten = 1234,1,Set(__FOO=bar)

```
