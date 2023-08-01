---
title: Installing Sample Files
pageid: 4817519
---




!!! warning Asterisk Sample Configs: not a sample PBX configuration
    For many of the sample configuration files that **make samples** installs, the configuration contains more than just an example configuration. The sample configuration files historically were used predominately for documentation of available options. As such, they contain many examples of configuring Asterisk that may not be ideal for standard deployments.

    While installing the sample configuration files may be a good starting point for some people, they should not be viewed as recommended configuration for an Asterisk system.

      
[//]: # (end-warning)





To install a set of sample configuration files for Asterisk, type:

```
[root@server asterisk-14.X.Y]# make samples

```

Any existing sample files which have been modified will be given a **.old** file extension. For example, if you had an existing file named **extensions.conf**, it would be renamed to **extensions.conf.old** and the sample dialplan would be installed as **extensions.conf**.











