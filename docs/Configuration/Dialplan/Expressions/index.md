---
title: Overview
pageid: 4620364
---

Everything contained inside a bracket pair prefixed by a $ (like $[this]) is considered as an expression and it is evaluated. Evaluation works similar to (but is done on a later stage than) variable substitution: the expression (including the square brackets) is replaced by the result of the expression evaluation.

For example, after the sequence:




---

  
  


```

exten => 1,1,Set(lala=$[1 + 2])
exten => 1,2,Set(koko=$[2 \* ${lala}])


```



---


the value of variable koko is "6".

And, further:




---

  
  


```

exten => 1,1,Set(lala=$[ 1 + 2 ]);


```



---


will parse as intended. Extra spaces are ignored.

