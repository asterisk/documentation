---
title: Objects
pageid: 4817451
---

Some Asterisk configuration files also create objects. The syntax for objects is slightly different than for settings. To create an object, you specify the type of object, an arrow formed by the equals sign and a greater-than sign (=>), and the settings for that object.




---

  
  


```

[section-name]
some\_object => settings

```



---




---

**Tip:**  Confused by Object Syntax?  





---

  
  


```


some\_object => settings
some\_object=settings
  



---



It is common to see both versions of the syntax, especially in online Asterisk documentation and examples. This book, however, will denote objects by using the arrow instead of the equals sign.



```




---




---

  
  


```

javascript[section-name]
label1=value1
label2=value2
object1 => name1

label1=value0
label3=value3
object2 => name2

```



---


In this example, **object1** inherits both **label1** and **label2**. It is important to note that **object2** also inherits **label2**, along with **label1** (with the new overridden value **value0**) and **label3**.


In short, objects inherit all the settings defined above them in the current section, and later settings override earlier settings.

