---
title: DUNDi Dialplan Functions
pageid: 4817221
---

The DUNDIQUERY and DUNDIRESULT dialplan functions will let you initiate a DUNDi query from the dialplan, see how many results there are, and access each one. Here is some example usage:




---

  
  


```

exten => 1,1,Set(ID=${DUNDIQUERY(1,dundi\_test,b)})
exten => 1,n,Set(NUM=${DUNDIRESULT(${ID},getnum)}) 
exten => 1,n,NoOp(There are ${NUM} results) 
exten => 1,n,Set(X=1) 
exten => 1,n,While($[${X} <= ${NUM}]) 
exten => 1,n,NoOp(Result ${X} is ${DUNDIRESULT(${ID},${X})}) 
exten => 1,n,Set(X=$[${X} + 1]) 
exten => 1,n,EndWhile


```


