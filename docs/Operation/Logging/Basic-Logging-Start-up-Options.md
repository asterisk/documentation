---
title: Basic Logging Start-up Options
pageid: 28315850
---

As previously indicated, at start up both the debug and verbose levels can also be set via command line arguments.  To set the debug level on start up use the "-d" argument optionally followed by more "d"s. Asterisk will start with a debug level represented by the number of "d"s specified.  As an example, the following will start Asterisk with a debug level of "3":




---

  
  


```

asterisk -ddd

```



---


To set the verbose level on start up use the "-v" argument optionally followed by more "v"s. Asterisk will start with a verbose level represented by the number of "v"s specified.  As an example, the following will start Asterisk with a verbose level of "3":




---

  
  


```

asterisk -vvv

```



---


And of course both of these arguments can be specified at the same time:




---

  
  


```

asterisk -dddvvv

```



---


