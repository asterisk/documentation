---
title: Validating Your Installation
pageid: 4817531
---

Before continuing on, let's check a few things to make sure your system is in good working order. First, let's make sure the DAHDI drivers are loaded. You can use the **lsmod** under Linux to list all of the loaded kernel modules, and the **grep** command to filter the input and only show the modules that have **dahdi** in their name.




---

  
  


```

[root@server asterisk-14.X.Y]# lsmod | grep dahdi


```


If the command returns nothing, then DAHDI has not been started. Start DAHDI by running:




---

  
  


```

[root@server asterisk-14.X.Y]# /etc/init.d/dadhi start


```




!!! tip Different Methods for Starting Initscripts
    Many Linux distributions have different methods for starting initscripts. On most Red Hat based distributions (such as Red Hat Enterprise Linux, Fedora, and CentOS) you can run:
[//]: # (end-tip)


  
  


```

[root@server asterisk-14.X.Y]# service dahdi start
  



---


Distributions based on Debian (such as Ubuntu) have a similar command, though it's not commonly used:

[root@server asterisk-14.X.Y]# invoke-rc.d dahdi start


```


If you have DAHDI running, the output of **lsmod | grep dahdi** should look something like the output below. (The exact details may be different, depending on which DAHDI modules have been built, and so forth.)




---

  
  


```

[root@server asterisk-14.X.Y]# lsmod | grep dahdi
dahdi\_transcode 7928 1 wctc4xxp
dahdi\_voicebus 40464 2 wctdm24xxp,wcte12xp
dahdi 196544 12 wctdm24xxp,wcte11xp,wct1xxp,wcte12xp,wct4xxp
crc\_ccitt 2096 1 dahdi


```


Now that DAHDI is running, you can run **dahdi\_hardware** to list any DAHDI-compatible devices in your system. You can also run the **dahdi\_tool** utility to show the various DAHDI-compatible devices, and their current state.

To check if Asterisk is running, you can use the Asterisk `initscript`.




---

  
  


```

[root@server asterisk-14.X.Y]# /etc/init.d/asterisk status
asterisk is stopped


```


To start Asterisk, we'll use the `initscript` again, this time giving it the start action:




---

  
  


```

[root@server asterisk-14.X.Y]# /etc/init.d/asterisk start
Starting asterisk:


```


When Asterisk starts, it runs as a background service (or daemon), so you typically won't see any response on the command line. We can check the status of Asterisk and see that it's running using the command below. (The process identifier, or pid, will obviously be different on your system.)




---

  
  


```

[root@server asterisk-14.X.Y]# /etc/init.d/asterisk status
asterisk (pid 32117) is running...


```


And there you have it! You've compiled and installed Asterisk, DAHDI, and libpri from source code.

