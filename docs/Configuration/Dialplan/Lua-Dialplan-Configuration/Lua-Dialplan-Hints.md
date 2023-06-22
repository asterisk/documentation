---
title: Lua Dialplan Hints
pageid: 16548017
---

In Asterisk 10 dialplan hints can be specified in `extensions.lua` in a manner similar to the way extensions are specified.




---

  
extensions.lua  


```


hints = {
 default = {
 ["100"] = "SIP/100";
 };

 office = {
 ["500"] = "SIP/500";
 };

 home = {
 ["200"] = "SIP/200";
 ["201"] = "SIP/201";
 };
}


```


