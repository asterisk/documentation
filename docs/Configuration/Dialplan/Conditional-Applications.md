---
title: Conditional Applications
pageid: 4620384
---

There is one conditional application - the conditional goto :

```
exten => 1,2,GotoIf(condition?label1:label2)

```

If condition is true go to label1, else go to label2. Labels are interpreted exactly as in the normal goto command.

"condition" is just a string. If the string is empty or "0", the condition is considered to be false, if it's anything else, the condition is true. This is designed to be used together with the expression syntax described above, eg :

```
exten => 1,2,GotoIf($[${CALLERID(all)} = 123456]?2,1:3,1)

```

Example of use :

```
exten => s,2,Set(vara=1)
exten => s,3,Set(varb=$[${vara} + 2])
exten => s,4,Set(varc=$[${varb} \* 2])
exten => s,5,GotoIf($[${varc} = 6]?99,1:s,6)

```
