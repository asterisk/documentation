---
title: Installing Initialization Scripts
pageid: 4817521
---

Now that you have Asterisk compiled and installed, the last step is to install the initialization script, or `initscript`. This script starts Asterisk when your server starts, will monitor the Asterisk process in case anything *bad* happens to it, and can be used to stop or restart Asterisk as well. To install the `initscript`, use the **make** **config** command.




---

  
  


```

[root@server asterisk-14.X.Y]# make config


```



---


As your Asterisk system runs, it will generate logfiles. It is recommended to install the `logrotation` script in order to compress and rotate those files, to save disk space and to make searching them or cataloguing them easier. To do this, use the **make install-logrotate** command.




---

  
  


```

[root@server asterisk-14.X.Y]# make install-logrotate


```



---


