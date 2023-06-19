---
title: Verbosity in Core and Remote Consoles
pageid: 28315852
---

If one issues the "`core show settings`" command from the Asterisk CLI it will show both a "Root" and "Current" console verbosity levels.  This is because each console, core or remote has an independent verbosity setting.  For instance, if you start asterisk with the following command:




---

  
  


```

asterisk -cv

```



---


This starts Asterisk in console mode (will be the root console) with a verbose level set to "1".  Now if one issues a "`core show settings`" from this console's CLI the following should be observed (note, not showing all settings):




---

  
  


```

\*CLI> core show settings

PBX Core settings
-----------------
...
Root console verbosity: 1
Current console verbosity: 1
...

```



---


A remote console can now be attached with an initial verbosity level of "3" and a "`core show settings`" on that console should show a root console verbosity of "1" and a current console verbosity of "3":




---

  
  


```

asterisk -rvvv

\*CLI> core show settings

PBX Core settings
-----------------
...
Root console verbosity: 1
Current console verbosity: 3
...

```



---


Changing the root console's verbosity will be reflected on both:




---

  
  


```

\*CLI> core set verbose 2
Console verbose was 1 and is now 2.
\*CLI> core show settings

PBX Core settings
-----------------
...
Root console verbosity: 2
Current console verbosity: 2
...

```



---


and then on the remote console:




---

  
  


```

\*CLI> core show settings

PBX Core settings
-----------------
...
Root console verbosity: 2
Current console verbosity: 3
...

```



---


