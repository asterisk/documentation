---
title: Distributed Device State with XMPP PubSub
pageid: 4259993
---





# Introduction

This document describes installing and utilizing XMPP PubSub events to distribute device state and message waiting indication (MWI) events between servers. The difference between this method and OpenAIS (see [Distributed Device State with AIS]) is that OpenAIS can only be used in low latency networks; meaning only on the LAN, and not across the internet.

If you plan on distributing device state or MWI across the internet, then you will require the use of XMPP PubSub events.

# Tigase Installation

### Description

Currently the only server supported for XMPP PubSub events is the Tigase open source XMPP/Jabber environment. This is the server that the various Asterisk servers will connect to in order to distribute the events. The Tigase server can even be clustered in order to provide high availability for your device state; however, that is beyond the scope of this document.

For more information about Tigase, visit their web site [http://www.tigase.org/](http://www.tigase.org/).

### Download

To download the Tigase environment, get the latest version at [http://www.tigase.org/content/tigase-downloads](http://www.tigase.org/content/tigase-downloads). Some distributions have Tigase packaged, as well.

### Install

The Tigase server requires a working Java environment, including both a JRE (Java Runtime Environment) and a JDK (Java Development Kit), currently at least version 1.6.

For more information about how to install Tigase, see the web site [http://www.tigase.org/content/quick-start](http://www.tigase.org/content/quick-start).

## Tigase Configuration

While installing Tigase, be sure you enable the PubSub module. Without it, the PubSub events won't be accepted by the server, and your device state will not be distributed.

There are a couple of things you need to configure in Tigase before you start it in order for Asterisk to connect. The first thing we need to do is generate the self-signed certificate. To do this we use the keytool application. More
information can be found here [http://www.tigase.org/content/server-certificate](http://www.tigase.org/content/server-certificate).

### Generating the keystore file

Generally, we need to run the following commands to generate a new keystore file.

```
# cd /opt/Tigase-4.3.1-b1858/certs
```

Be sure to change the 'yourdomain' to your domain.

```
# keytool -genkey -alias yourdomain -keystore rsa-keystore -keyalg RSA -sigalg MD5withRSA
```

The keytool application will then ask you for a password. Use the password 'keystore' as this is the default password that Tigase will use to load the keystore file.

You then need to specify your domain as the first value to be entered in the security certificate.

```
What is your first and last name?
 [Unknown]: asterisk.mydomain.tld
What is the name of your organizational unit?
 [Unknown]:
What is the name of your organization?
 [Unknown]:
What is the name of your City or Locality?
 [Unknown]:
What is the name of your State or Province?
 [Unknown]:
What is the two-letter country code for this unit?
 [Unknown]:
Is CN=asterisk.mydomain.tld, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?
 [no]: yes
```

You will then be asked for another password, in which case you must just press enter for the same password as Tigase will not work without them being the same.

```
Enter key password for <mykey>
 (RETURN if same as keystore password):
```

### Configuring init.properties

The next step is to configure the init.properties file which is used by Tigase to generate the tigase.xml file. Whenever you change the init.properties file because sure to remove the current tigase.xml file so that it will be regenerated at start up.

```
# cd /opt/Tigase-4.3.1-b1858/etc
```

Then edit the init.properties file and add the following:

```
config-type=--gen-config-def
--admins=admin@asterisk.mydomain.tld
--virt-hosts=asterisk.mydomain.tld
--debug=server
--user-db=derby
--user-db-uri=jdbc:derby:/opt/Tigase-4.3.1-b1858
--comp-name-1=pubsub
--comp-class-1=tigase.pubsub.PubSubComponent
```

Be sure to change the domain in the --admin and --virt-hosts options. The most important lines are --comp-name-1 and --comp-class-1 which tell Tigase to load the PubSub module.

## Running Tigase

You can then start the Tigase server with the tigase.sh script.

```
# cd /opt/Tigase-4.3.1-b1858
# ./scripts/tigase.sh start etc/tigase.conf
```

## Adding Buddies to Tigase

At this time, Asterisk is not able to automatically register your peers for you, so you'll need to use an external application to do the initial registration.

Pidgin is an excellent multi-protocol instant messenger application which supports XMPP. It runs on Linux, Windows, and OSX, and is open source. You can get Pidgin from http://www.pidgin.im

Then add the two buddies we'll use in Asterisk with Pidgin by connecting to the Tigase server. For more information about how to register new buddies, see the Pidgin documentation.

Once the initial registration is done and loaded into Tigase, you no longer need to worry about using Pidgin. Asterisk will then be able to load the peers into memory at start up.

The example peers we've used in the following documentation for our two nodes are:

```
server1@asterisk.mydomain.tld/astvoip1
server2@asterisk.mydomain.tld/astvoip2
```

# Installing Asterisk

Install Asterisk as usual. However, you'll need to make sure you have the res_jabber module compiled, which requires the iksemel development library. Additionally, be sure you have the OpenSSL development library installed so you can connect securly to the Tigase server.

Make sure you check menuselect that res_jabber is selected so that it will compile.

```
# cd asterisk-source
# ./configure

# make menuselect
 ---> Resource Modules
```

If you don't have jabber.conf in your existing configuration, because sure to copy the sample configuration file there.

```
# cd configs
# cp jabber.conf.sample /etc/asterisk/jabber.conf
```

## Configuring Asterisk

We then need to configure our servers to communicate with the Tigase server. We need to modify the jabber.conf file on the servers. The configurations below are for a 2 server setup, but could be expanded for additional servers easily.

The key note here is to note that the pubsub_node option needs to start with pubsub, so for example, pubsub.asterisk.mydomain.tld. Without the 'pubsub' your Asterisk system will not be able to distribute events.

Additionally, you will need to specify each of the servers you need to connec to using the 'buddy' option.


\*Asterisk Server 1


```

[general]
debug=no ;;Turn on debugging by default.
;autoprune=yes ;;Auto remove users from buddy list. Depending on your
 ;;setup (ie, using your personal Gtalk account for a test)
 ;;you might lose your contacts list. Default is 'no'.
autoregister=yes ;;Auto register users from buddy list.
;collection_nodes=yes ;;Enable support for XEP-0248 for use with
 ;;distributed device state. Default is 'no'.
;pubsub_autocreate=yes ;;Whether or not the PubSub server supports/is using
 ;;auto-create for nodes. If it is, we have to
 ;;explicitly pre-create nodes before publishing them.
 ;;Default is 'no'.

[asterisk]
type=client
serverhost=asterisk.mydomain.tld
pubsub_node=pubsub.asterisk.mydomain.tld
username=server1@asterisk.mydomain.tld/astvoip1
secret=welcome
distribute_events=yes
status=available
usetls=no
usesasl=yes
buddy=server2@asterisk.mydomain.tld/astvoip2

```


\*Asterisk Server 2\*


```

[general]
debug=yes ;;Turn on debugging by default.
;autoprune=yes ;;Auto remove users from buddy list. Depending on your
 ;;setup (ie, using your personal Gtalk account for a test)
 ;;you might lose your contacts list. Default is 'no'.
autoregister=yes ;;Auto register users from buddy list.
;collection_nodes=yes ;;Enable support for XEP-0248 for use with
 ;;distributed device state. Default is 'no'.
;pubsub_autocreate=yes ;;Whether or not the PubSub server supports/is using
 ;;auto-create for nodes. If it is, we have to
 ;;explicitly pre-create nodes before publishing them.
 ;;Default is 'no'.

[asterisk]
type=client
serverhost=asterisk.mydomain.tld
pubsub_node=pubsub.asterisk.mydomain.tld
username=server2@asterisk.mydomain.tld/astvoip2
secret=welcome
distribute_events=yes
status=available
usetls=no
usesasl=yes
buddy=server1@asterisk.mydomain.tld/astvoip1

```


# Basic Testing of Asterisk with XMPP PubSub

Once you have Asterisk installed with XMPP PubSub, it is time to test it out.

We need to start up our first server and make sure we get connected to the XMPP server. We can verify this with an Asterisk console command to determine if we're connected.

On Asterisk 1 we can run 'jabber show connected' to verify we're connected to the XMPP server.

```
\*CLI> jabber show connected 
Jabber Users and their status:
 User: server1@asterisk.mydomain.tld/astvoip1 - Connected
----
 Number of users: 1
```

The command above has given us output which verifies we've connected our first server.

We can then check the state of our buddies with the 'jabber show buddies' CLI command.

```
\*CLI> jabber show buddies
Jabber buddy lists
Client: server1@asterisk.mydomain.tld/astvoip1
 Buddy: server2@asterisk.mydomain.tld
 Resource: None
 Buddy: server2@asterisk.mydomain.tld/astvoip2
 Resource: None
```

The output above tells us we're not connected to any buddies, and thus we're not distributing state to anyone (or getting it from anyone). That makes sense since we haven't yet started our other server.

Now, let's start the other server and verify the servers are able to establish a connection between each other.

On Asterisk 2, again we run the 'jabber show connected' command to make sure we've connected successfully to the XMPP server.

```
\*CLI> jabber show connected 
Jabber Users and their status:
 User: server2@asterisk.mydomain.tld/astvoip2 - Connected
----
 Number of users: 1
```

And now we can check the status of our buddies.

```
\*CLI> jabber show buddies
Jabber buddy lists
Client: server2@scooter/astvoip2
 Buddy: server1@asterisk.mydomain.tld
 Resource: astvoip1
 node: http://www.asterisk.org/xmpp/client/caps
 version: asterisk-xmpp
 Jingle capable: yes
 Status: 1
 Priority: 0
 Buddy: server1@asterisk.mydomain.tld/astvoip1
 Resource: None
```

Excellent! So we're connected to the buddy on Asterisk 1, and we could run the same command on Asterisk 1 to verify the buddy on Asterisk 2 is seen.

# Testing Distributed Device State

The easiest way to test distributed device state is to use the DEVICE_STATE() diaplan function. For example, you could have the following piece of dialplan on every server:

```
[devstate_test]

exten => 1234,hint,Custom:mystate

exten => set_inuse,1,Set(DEVICE_STATE(Custom:mystate)=INUSE)
exten => set_not_inuse,1,Set(DEVICE_STATE(Custom:mystate)=NOT_INUSE)

exten => check,1,NoOp(Custom:mystate is ${DEVICE_STATE(Custom:mystate)})
```

Now, you can test that the cluster-wide state of "Custom:mystate" is what you would expect after going to the CLI of each server and adjusting the state.

```
server1\*CLI> console dial set_inuse@devstate_test
 ...

server2\*CLI> console dial check@devstate_test
 -- Executing [check@devstate_test:1] NoOp("OSS/dsp", "Custom:mystate is INUSE") in new stack
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

# Notes On Large Installations

On larger installations where you want a fully meshed network of buddies (i.e. all servers have all the buddies of the remote servers), you may want some method of distributing those buddies automatically so you don't need to modify
all servers (N+1) every time you add a new server to the cluster.

The problem there is that you're confined by what's allowed in XEP-0060, and unfortunately that means modifying affiliations by individual JID (as opposed to the various subscription access models, which are more flexible).

See here for details http://xmpp.org/extensions/xep-0060.html#owner-affiliations

One method for making this slightly easier is to utilize the #exec functionality in configuration files, and dynamically generate the buddies via script that pulls the information from a database, or to #include a file which is automatically generated on all the servers when you add a new node to the cluster.

Unfortunately this still requires a reload of res_jabber.so on all the servers, but this could also be solved through the use of the Asterisk Manager Interface (AMI).

So while this is not the ideal situation, it is programmatically solvable with existing technologies and features found in Asterisk today.

