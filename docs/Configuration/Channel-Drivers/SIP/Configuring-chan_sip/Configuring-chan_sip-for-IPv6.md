---
title: Configuring chan_sip for IPv6
pageid: 34013478
---

Configuring chan\_sip for IPv6
==============================

Mostly you can use IPv6 addresses where you would have otherwise used IPv4 addresses within sip.conf. The sip.conf.sample provides several examples of how to use the various options with IPv6 addresses. We'll provide a few examples here as well.

Examples
--------

Binding to a specific IPv6 interface




---

  
  


```

[general]
bindaddr=2001:db8::1

```


Binding to all available IPv6 interfaces (wildcard)




---

  
  


```

[general]
bindaddr=::

```


You can specify a port number by wrapping the address in square brackets and using a colon delimiter.




---

  
  


```

[general]
bindaddr=[::]:5062

```




!!! tip 
    You can choose independently for UDP, TCP, and TLS, by specifying different values for  "udpbindaddr", "tcpbindaddr", and "tlsbindaddr".

    Note that using bindaddr=:: will show only a single IPv6 socket in netstat. IPv4 is supported at the same time using IPv4-mapped IPv6 addresses.)

      
[//]: # (end-tip)



Other Options
=============

Other options such as "outboundproxy" or "permit" can use IPv6 addresses the same as in the above examples.




---

  
  


```

permit=2001:db8::/32

```


