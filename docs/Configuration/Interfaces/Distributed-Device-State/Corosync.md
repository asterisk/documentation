---
title: Corosync
pageid: 21463349
---

##### Corosync


[Corosync](http://www.corosync.org) is an open source group messaging system typically used in clusters, cloud computing, and other high availability environments.


The project, at it's core, provides four C api features:


* A closed process group communication model with virtual synchrony guarantees for creating replicated state machines.
* A simple availability manager that restarts the application process when it has failed.
* A configuration and statistics in-memory database that provide the ability to set, retrieve, and receive change notifications of information.
* A quorum system that notifies applications when quorum is achieved or lost.


##### Corosync and Asterisk


Using Corosync together with res_corosync allows events to be shared amongst a local cluster of Asterisk servers. Specifically, the types of events that may be shared include:


* Device state
* Message Waiting Indication, or MWI (to allow voicemail to live on a server that is different from where the phones are registered)


##### Setup and Configuration


###### Corosync


* ###### Installation


Debian / Ubuntu



---

  
  


```


apt-get install corosync corosync-dev


```



Red Hat / Fedora



---

  
  


```


yum install corosync corosynclib corosynclib-devel


```


* ###### Authkey


To create an authentication key for secure communications between your nodes you need to do this on, what will be, the active node.



---

  
  


```


corosync-keygen


```



This creates a key in /etc/corosync/authkey.



---

  
  


```


asterisk_active:~# scp /etc/corosync/authkey asterisk_standby:


```



Now, on the standby node, you'll need to stick the authkey in it's new home and fix it's permissions / ownership.



---

  
  


```


asterisk_standby:~# mv ~/authkey /etc/corosync/authkey
asterisk_standby:~# chown root:root /etc/corosync/authkey
asterisk_standby:~# chmod 400 /etc/corosync/authkey


```
* ###### /etc/corosync/corosync.conf


The interface section under the totem block defines the communication path(s) to the other Corosync processes running on nodes within the cluster. These can be either IPv4 or IPv6 ip addresses but can not be mixed and matched within an interface. Adjustments can be made to the cluster settings based on your needs and installation environment.
	+ ###### IPv4
	
	
	###### Active Node Example
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	
	totem {
	 version: 2
	 token: 160
	 token_retransmits_before_loss_const: 3
	 join: 30
	 consensus: 300
	 vsftype: none
	 max_messages: 20
	 threads: 0
	 nodeid: 1
	 rrp_mode: none
	 interface {
	 ringnumber: 0
	 bindnetaddr: 192.168.1.0
	 mcastaddr: 226.94.1.1
	 mcastport: 5405
	 }
	}
	
	
	```
	
	
	
	---
	
	
	###### Standby Node Example
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	
	totem {
	 version: 2
	 token: 160
	 token_retransmits_before_loss_const: 3
	 join: 30
	 consensus: 300
	 vsftype: none
	 max_messages: 20
	 threads: 0
	 nodeid: 2
	 rrp_mode: none
	 interface {
	 ringnumber: 0
	 bindnetaddr: 192.168.1.0
	 mcastaddr: 226.94.1.1
	 mcastport: 5405
	 }
	}
	
	
	```
	
	
	
	---


* ###### Start Corosync




---

  
  


```


service corosync start


```


###### Asterisk


* ###### Installation


In your Asterisk source directory:



---

  
  


```


./configure
make
make install


```


* ###### /etc/asterisk/res_corosync.conf




---

  
  


```


;
; Sample configuration file for res_corosync.
;
; This module allows events to be shared amongst a local cluster of
; Asterisk servers. Specifically, the types of events that may be
; shared include:
;
; - Device State (for shared presence information)
;
; - Message Waiting Indication, or MWI (to allow Voicemail to live on
; a server that is different from where the phones are registered)
;
; For more information about Corosync, see: http://www.corosync.org/
;

[general]

;
; Publish Message Waiting Indication (MWI) events from this server to the
; cluster.
publish_event = mwi
;
; Subscribe to MWI events from the cluster.
subscribe_event = mwi
;
; Publish Device State (presence) events from this server to the cluster.
publish_event = device_state
;
; Subscribe to Device State (presence) events from the cluster.
subscribe_event = device_state
;


```



In the general section of the res_corosync.conf file we are specifying which events we'd like to publish and subscribe to (at the moment this is either device_state or mwi).


* ###### Verifying Installation


If everything is setup correctly, you should see this output after executing a 'corosync show members' on the Asterisk CLI.



---

  
  


```


\*CLI> corosync show members

=============================================================
=== Cluster members =========================================
=============================================================
===
=== Node 1
=== --> Group: asterisk
=== --> Address 1: <host #1 ip goes here>
===
=============================================================


```


After starting Corosync and Asterisk on your second node, the 'corosync show members' output should look something like this:




---

  
  


```


\*CLI> corosync show members 

=============================================================
=== Cluster members =========================================
=============================================================
===
=== Node 1
=== --> Group: asterisk
=== --> Address 1: <host #1 ip goes here>
=== Node 2
=== --> Group: asterisk
=== --> Address 1: <host #2 ip goes here>
===
=============================================================


```


