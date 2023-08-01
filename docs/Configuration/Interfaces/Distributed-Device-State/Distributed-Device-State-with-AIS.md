---
title: Distributed Device State with AIS
pageid: 4259996
---





# Introduction

Various changes have been made related to "event handling" in Asterisk. One of the most important things included in these changes is the ability to share certain events between servers. The two types of events that can currently be shared between servers are:

# \*MWI\* - _Message Waiting Indication_ - This gives you a high performance option for letting servers in a cluster be aware of changes in the state of a mailbox. Instead of having each server have to poll an ODBC database, this lets the server that actually made the change to the mailbox generate an event which will get distributed to the other servers that have subscribed to this information.
# \*Device State\* - This lets servers in a local cluster inform each other about changes in the state of a device on that particular server. When the state of a device changes on any server, the overall state of that device across the cluster will get recalculated. So, any subscriptions to the state of a device, such as hints in the dialplan or an application like Queue() which reads device state, will then reflect the state of a device across a cluster.

# OpenAIS Installation

### Description

The current solution for providing distributed events with Asterisk is done by using the AIS (Application Interface Specification), which provides an API for a distributed event service. While this API is standardized, this code has been developed exclusively against the open source implementation of AIS called OpenAIS.

For more information about OpenAIS, visit their web site [http://www.openais.org/](http://www.openais.org/).

### Install Dependencies

* Ubuntu
    * libnss3-dev
* Fedora
    * nss-devel

### Download

Download the latest versions of Corosync and OpenAIS from [http://www.corosync.org/](http://www.corosync.org/) and [http://www.openais.org/](http://www.openais.org/).

### Compile and Install

```
$ tar xvzf corosync-1.2.8.tar.gz
$ cd corosync-1.2.8
$ ./configure
$ make
$ sudo make install
```
```
$ tar xvzf openais-1.1.4.tar.gz
$ cd openais-1.1.4
$ ./configure
$ make
$ sudo make install
```
# OpenAIS Configuration

Basic OpenAIS configuration to get this working is actually pretty easy. Start by copying in a sample configuration file for Corosync and OpenAIS.

```
$ sudo mkdir -p /etc/ais
$ cd openais-1.1.4
$ sudo cp conf/openais.conf.sample /etc/ais/openais.conf
```
```
$ sudo mkdir -p /etc/corosync
$ cd corosync-1.2.8
$ sudo cp conf/corosync.conf.sample /etc/corosync/corosync.conf
```
Now, edit openais.conf using the editor of your choice.

```
$ ${EDITOR:-vim} /etc/ais/openais.conf
```
The only section that you should need to change is the totem - interface section.

```
totem {
 ...
 interface {
 ringnumber: 0
 bindnetaddr: 10.24.22.144
 mcastaddr: 226.94.1.1
 mcastport: 5405
 }
}

```

The default mcastaddr and mcastport is probably fine. You need to change the bindnetaddr to match the address of the network interface that this node will use to communicate with other nodes in the cluster.

Now, edit /etc/corosync/corosync.conf, as well. The same change will need to be made to the totem-interface section in that file.

# Running OpenAIS

While testing, I recommend starting the aisexec application in the foreground so that you can see debug messages that verify that the nodes have discovered each other and joined the cluster.

```
$ sudo aisexec -f
```
For example, here is some sample output from the first server after starting aisexec on the second server:

```
Nov 13 06:55:30 corosync [CLM ] CLM CONFIGURATION CHANGE
Nov 13 06:55:30 corosync [CLM ] New Configuration:
Nov 13 06:55:30 corosync [CLM ] r(0) ip(10.24.22.144) 
Nov 13 06:55:30 corosync [CLM ] r(0) ip(10.24.22.242) 
Nov 13 06:55:30 corosync [CLM ] Members Left:
Nov 13 06:55:30 corosync [CLM ] Members Joined:
Nov 13 06:55:30 corosync [CLM ] r(0) ip(10.24.22.242) 
Nov 13 06:55:30 corosync [TOTEM ] A processor joined or left the membership and a new membership was formed.
Nov 13 06:55:30 corosync [MAIN ] Completed service synchronization, ready to provide service.
```
# Installing Asterisk

Install Asterisk as usual. Just make sure that you run the configure script after OpenAIS gets installed. That way, it will find the AIS header files and will let you build the res_ais module. Check menuselect to make sure that res_ais is going to get compiled and installed.

```
$ cd asterisk-source
$ ./configure

$ make menuselect
 ---> Resource Modules
```
If you have existing configuration on the system being used for testing, just be sure to install the addition configuration file needed for res_ais.

```
$ sudo cp configs/ais.conf.sample /etc/asterisk/ais.conf
```
# Configuring Asterisk

First, ensure that you have a unique "entity ID" set for each server.

```
\*CLI> core show settings
 ...
 Entity ID: 01:23:45:67:89:ab
```
The code will attempt to generate a unique entity ID for you by reading MAC addresses off of a network interface. However, you can also set it manually in the \[options\] section of asterisk.conf.

```
$ sudo ${EDITOR:-vim} /etc/asterisk/asterisk.conf
```
```
[options]

entity_id=01:23:45:67:89:ab

```

Edit the Asterisk ais.conf to enable distributed events. For example, if you would like to enable distributed device state, you should add the following section to the file:

```
$ sudo ${EDITOR:-vim} /etc/asterisk/ais.conf
```
```
[device_state]
type=event_channel
publish_event=device_state
subscribe_event=device_state

```

For more information on the contents and available options in this configuration file, please see the sample configuration file:

```
$ cd asterisk-source
$ less configs/ais.conf.sample
```
# Basic Testing of Asterisk with OpenAIS

If you have OpenAIS successfully installed and running, as well as Asterisk with OpenAIS support successfully installed, configured, and running, then you are ready to test out some of the AIS functionality in Asterisk.

The first thing to test is to verify that all of the nodes that you think should be in your cluster are actually there. There is an Asterisk CLI command which will list the current cluster members using the AIS Cluster Membership Service
(CLM).

```
\*CLI> ais clm show members 

=============================================================
=== Cluster Members =========================================
=============================================================
===
=== ---------------------------------------------------------
=== Node Name: 10.24.22.144
=== ==> ID: 0x9016180a
=== ==> Address: 10.24.22.144
=== ==> Member: Yes
=== ---------------------------------------------------------
===
=== ---------------------------------------------------------
=== Node Name: 10.24.22.242
=== ==> ID: 0xf216180a
=== ==> Address: 10.24.22.242
=== ==> Member: Yes
=== ---------------------------------------------------------
===
=============================================================
```
{tip}
If you're having trouble getting the nodes of the cluster to see each other, make sure you do not have firewall rules that are blocking the multicast traffic that is used to communicate amongst the nodes.
{tip}

The next thing to do is to verify that you have successfully configured some event channels in the Asterisk ais.conf file. This command is related to the event service (EVT), so like the previous command, uses the syntax: `ais <service name> <command>`.

```
\*CLI> ais evt show event channels 

=============================================================
=== Event Channels ==========================================
=============================================================
===
=== ---------------------------------------------------------
=== Event Channel Name: device_state
=== ==> Publishing Event Type: device_state
=== ==> Subscribing to Event Type: device_state
=== ---------------------------------------------------------
===
=============================================================
```

# Testing Distributed Device State

The easiest way to test distributed device state is to use the DEVICE_STATE() diaplan function. For example, you could have the following piece of dialplan on every server:

```
[devstate_test]

exten => 1234,hint,Custom:mystate

```

Now, you can test that the cluster-wide state of "Custom:mystate" is what you would expect after going to the CLI of each server and adjusting the state.

```
server1\*CLI> dialplan set global DEVICE_STATE(Custom:mystate) NOT_INUSE
 ...

server2\*CLI> dialplan set global DEVICE_STATE(Custom:mystate) INUSE
 ...
```
Various combinations of setting and checking the state on different servers can be used to verify that it works as expected. Also, you can see the status of the hint on each server, as well, to see how extension state would reflect the
state change with distributed device state:

```
server2\*CLI> core show hints
 -= Registered Asterisk Dial Plan Hints =-
 1234@devstate_test : Custom:mystate State:InUse Watchers 0
```
One other helpful thing here during testing and debugging is to enable debug logging. To do so, enable debug on the console in /etc/asterisk/logger.conf. Also, enable debug at the Asterisk CLI.

```
\*CLI> core set debug 1
```
When you have this debug enabled, you will see output during the processing of every device state change. The important thing to look for is where the known state of the device for each server is added together to determine the overall
state.

