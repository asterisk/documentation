---
title: Block Comments
pageid: 4817457
---

Asterisk also allows us to create block comments. A block comment is a comment that begins on one line, and continues for several lines. Block comments begin with the character sequence 




---

  
  


```

;--

```



---


 and continue across multiple lines until the character sequence 




---

  
  


```

--;

```



---


 is encountered. The block comment ends immediately after --; is encountered.




---

  
  


```

[section-name]
setting=true
;-- this is a block comment that begins on this line
and continues across multiple lines, until we
get to here --;

```



---


