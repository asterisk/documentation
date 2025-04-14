---
title: Building and Installing LibPRI
pageid: 4817517
---

!!! note Have you installed DAHDI?**  Before you can build **libpri
    , you'll need to [Build and Install DAHDI](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Building-and-Installing-DAHDI).

[//]: # (end-note)

As in the other build and install sections, we'll assume that you'll replace the letters X, Y, and Z with the actual version numbers from the tarballs you downloaded.

```
[root@server src]# cd libpri-1.X.Y

```

This command changes directories to the **libpri** source directory.

```
[root@server libpri-1.X.Y]# make

```

This command compiles the **libpri** source code into a system library.

```
[root@server libpri-1.X.Y]# make install

```

This command installs the **libpri** library into the proper system library directory
