---
search:
  boost: 0.5
title: MATH
---

# MATH()

### Synopsis

Performs Mathematical Functions.

### Description

Performs mathematical functions based on two parameters and an operator. The returned value type is _type_<br>

Example: Set(i=$\{MATH(123%16,int)\}) - sets var i=11<br>


### Syntax


```

MATH(expression,type)
```
##### Arguments


* `expression` - Is of the form: _number1__op__number2_ where the possible values for _op_ are:<br>
+,-,/,*,%,<<,>>,\^,AND,OR,XOR,<,>,<=,>=,== (and behave as their C equivalents)<br>

* `type` - Wanted type of result:<br>
f, float - float(default)<br>
i, int - integer<br>
h, hex - hex<br>
c, char - char<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 