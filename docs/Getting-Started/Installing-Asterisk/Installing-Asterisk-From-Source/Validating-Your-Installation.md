---
title: Validating Your Installation
pageid: 4817531
---

Before continuing on, let's check a few things to make sure your system is in good working order.

## Checking DAHDI

/// tip | Are you using DAHDI?
If you're not using DAHDI you can skip to [the next section](#checking-asterisk).
///

First, let's make sure the DAHDI drivers are loaded. You can use the **lsmod** under Linux to list all of the loaded kernel modules, and the **grep** command to filter the input and only show the modules that have **dahdi** in their name.

```
[root@server asterisk-22.X.Y]# lsmod | grep dahdi
```

If the command returns nothing, then DAHDI has not been started. Start DAHDI by running:

```
[root@server asterisk-22.X.Y]# service dadhi start
```

/// tip | Different methods for starting services
Some Linux distributions have different methods for starting
services (traditionally called initscripts). Check your
distribution's documentation if you have any problems with
the commands used here.
///

If you have DAHDI running, the output of **lsmod | grep dahdi** should look something like the output below. (The exact details may be different, depending on which DAHDI modules have been built, and so forth.)

```
[root@server asterisk-22.X.Y]# lsmod | grep dahdi
dahdi_transcode 7928 1 wctc4xxp
dahdi_voicebus 40464 2 wctdm24xxp,wcte12xp
dahdi 196544 12 wctdm24xxp,wcte11xp,wct1xxp,wcte12xp,wct4xxp
crc_ccitt 2096 1 dahdi
```

Now that DAHDI is running, you can run **dahdi_hardware** to list any DAHDI-compatible devices in your system. You can also run the **dahdi_tool** utility to show the various DAHDI-compatible devices, and their current state.

## Checking Asterisk

To check if Asterisk is running, you can run:

```
[root@server asterisk-22.X.Y]# service asterisk status
asterisk is stopped
```

/// tip | Different service command output
The output of the `service` command varies between Linux
distributions. You are likely to see more detail, e.g.
if your distribution uses systemd.
///

To start Asterisk, we'll use `service` again, this time giving it the start action:

```
[root@server asterisk-22.X.Y]# service asterisk start
Starting asterisk:
```

When Asterisk starts, it runs as a background service (or daemon), so you typically won't see any response on the command line. We can check the status of Asterisk and see that it's running using the command below. (The process identifier, or pid, will obviously be different on your system.)

```
[root@server asterisk-22.X.Y]# service asterisk status
asterisk (pid 32117) is running...
```

And there you have it! You've compiled and installed Asterisk, DAHDI, and libpri from source code.
