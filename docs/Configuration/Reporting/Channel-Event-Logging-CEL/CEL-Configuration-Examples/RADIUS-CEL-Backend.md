---
title: RADIUS CEL Backend
pageid: 5242961
---

### What is needed

* FreeRADIUS server
* Radiusclient-ng library
* Asterisk PBX

### Installation of the Radiusclient library

##### Download the sources

From <http://developer.berlios.de/projects/radiusclient-ng/> 

##### Untar the source tarball:

```

root@localhost:/usr/local/src# tar xvfz radiusclient-ng-0.5.2.tar.gz 

```

##### Compile and install the library:

```

root@localhost:/usr/local/src# cd radiusclient-ng-0.5.2
root@localhost:/usr/local/src/radiusclient-ng-0.5.2#./configure 
root@localhost:/usr/local/src/radiusclient-ng-0.5.2# make 
root@localhost:/usr/local/src/radiusclient-ng-0.5.2# make install

```

##### Configuration of the Radiusclient library

By default all the configuration files of the radiusclient library will be in /usr/local/etc/radiusclient-ng directory. 

File "radiusclient.conf" Open the file and find lines containing the following: 

```

authserver localhost 

```

This is the hostname or IP address of the RADIUS server used for authentication. You will have to change this unless the server is running on the same host as your Asterisk PBX. 

```

acctserver localhost 

```

This is the hostname or IP address of the RADIUS server used for accounting. You will have to change this unless the server is running on the same host as your Asterisk PBX. 

##### File "servers"

RADIUS protocol uses simple access control mechanism based on shared secrets that allows RADIUS servers to limit access from RADIUS clients. 

A RADIUS server is configured with a secret string and only RADIUS clients that have the same secret will be accepted. 

You need to configure a shared secret for each server you have configured in radiusclient.conf file in the previous step. The shared secrets are stored in /usr/local/etc/radiusclient-ng/servers file. 

Each line contains hostname of a RADIUS server and shared secret used in communication with that server. The two values are separated by white spaces. Configure shared secrets for every RADIUS server you are going to use. 

```

File "dictionary" 

```

Asterisk uses some attributes that are not included in the dictionary of radiusclient library, therefore it is necessary to add them. A file called dictionary.digium (kept in the contrib dir) was created to list all new attributes used by Asterisk. Add to the end of the main dictionary 

file /usr/local/etc/radiusclient-ng/dictionary the line: 

```bash title=" " linenums="1"
$INCLUDE /path/to/dictionary.digium

```

### Install FreeRADIUS Server (Version 1.1.1)

##### Download sources tarball from:

<http://freeradius.org/> 

##### Untar, configure, build, and install the server:

```

root@localhost:/usr/local/src# tar xvfz freeradius-1.1.1.tar.gz 
root@localhost:/usr/local/src# cd freeradius-1.1.1 
root@localhost"/usr/local/src/freeradius-1.1.1# ./configure 
root@localhost"/usr/local/src/freeradius-1.1.1# make 
root@localhost"/usr/local/src/freeradius-1.1.1# make install 

```

All the configuration files of FreeRADIUS server will be in /usr/local/etc/raddb directory.

##### Configuration of the FreeRADIUS Server

There are several files that have to be modified to configure the RADIUS server. These are presented next. 

##### File "clients.conf"

File /usr/local/etc/raddb/clients.conf contains description of RADIUS clients that are allowed to use the server. For each of the clients you need to specify its hostname or IP address and also a shared secret. The shared secret must be the same string you configured in radiusclient library. 

Example: 

```

client myhost { secret = mysecret shortname = foo } 

```

This fragment allows access from RADIUS clients on "myhost" if they use "mysecret" as the shared secret. The file already contains an entry for localhost (127.0.0.1), so if you are running the RADIUS server on the same host as your Asterisk server, then modify the existing entry instead, replacing the default password. 

##### File "dictionary"

!!! note 
    As of version 1.1.2, the dictionary.digium file ships with FreeRADIUS.

[//]: # (end-note)

The following procedure brings the dictionary.digium file to previous versions of FreeRADIUS. 

File /usr/local/etc/raddb/dictionary contains the dictionary of FreeRADIUS server. You have to add the same dictionary file (dictionary.digium), which you added to the dictionary of radiusclient-ng library. You can include it into the main file, adding the following line at the end of file /usr/local/etc/raddb/dictionary: 

```bash title=" " linenums="1"
$INCLUDE /path/to/dictionary.digium 

```

That will include the same new attribute definitions that are used in radiusclient-ng library so the client and server will understand each other.

### Asterisk Accounting Configuration

##### Compilation and installation:

The module will be compiled as long as the radiusclient-ng library has been detected on your system. 

By default FreeRADIUS server will log all accounting requests into /usr/local/var/log/radius/radacct directory in form of plain text files. The server will create one file for each hostname in the directory. The following example shows how the log files look like. 

Asterisk now generates Call Detail Records. See /include/asterisk/cel.h for all the fields which are recorded. By default, records in comma separated values will be created in /var/log/asterisk/cel-csv. 

The configuration file for cel_radius.so module is :   

This is where you can set CDR related parameters as well as the path to the radiusclient-ng library configuration file.

##### Logged Values

* "Asterisk-Acc-Code", The account name of detail records
* "Asterisk-CidName",
* "Asterisk-CidNum",
* "Asterisk-Cidani",
* "Asterisk-Cidrdnis",
* "Asterisk-Ciddnid",
* "Asterisk-Exten",
* "Asterisk-Context", The destination context
* "Asterisk-Channame", The channel name
* "Asterisk-Appname", Last application run on the channel
* "Asterisk-App-Data", Argument to the last channel
* "Asterisk-Event-Time",
* "Asterisk-Event-Type",
* "Asterisk-AMA-Flags", DOCUMENTATION, BILL, IGNORE etc, specified on a per channel basis like accountcode.
* "Asterisk-Unique-ID", Unique call identifier
* "Asterisk-User-Field" User field set via SetCELUserField
* "Asterisk-Peer" Name of the Peer for 2-channel events (like bridge)
