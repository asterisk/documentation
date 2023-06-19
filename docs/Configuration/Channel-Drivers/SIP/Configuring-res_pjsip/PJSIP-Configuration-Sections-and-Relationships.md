---
title: PJSIP Configuration Sections and Relationships
pageid: 30278064
---

Configuration Section Format
----------------------------

pjsip.conf is a flat text file composed of **sections** like most configuration files used with Asterisk. Each **section** defines configuration for a **configuration object** within res\_pjsip or an associated module.

**Sections** are identified by **names in square brackets**. (see SectionName below)

Each section has one or more **configuration options** that can be assigned a value by using an **equal sign** followed by a value. (see ConfigOption and Value below)These options and values are the configuration for a particular component of functionality provided by the configuration object's respective Asterisk modules.

Every section will have a **type** option that defines what kind of section is being configured. You'll see that in every example config section below.

Syntax for res\_sip config objects **[**  SectionName  **]**    
 ConfigOption  **=**  Value   
 ConfigOption  **=**  Value

On this Page


Config Section Help and Defaults
--------------------------------

Reference documentation for all configuration parameters is available on the wiki:

* [Core res\_pjsip configuration options](/Asterisk+12+Configuration_res_pjsip)
* [Configuration options for ACLs in res\_pjsip\_acl](/Asterisk+12+Configuration_res_pjsip_acl)
* [Configuration options for outbound registration, provided by res\_pjsip\_outbound\_registration](/Asterisk+12+Configuration_res_pjsip_outbound_registration)
* [Configuration options for endpoint identification by IP address, provided by res\_pjsip\_endpoint\_identifier\_ip](/Asterisk+12+Configuration_res_pjsip_endpoint_identifier_ip)

The same documentation is available at the Asterisk CLI as well. You can use "config show help <res\_pjsip module name> <configobject> <configoption>" to get help on a particular option. That help will typically describe the default value for an option as well.




---

**Tip:**   ****Defaults**:** For many config options, it's very helpful to understand their default behavior. For example, for the endpoint section "transport=" option, if no value is assigned then Asterisk will \*DEFAULT\* to the first configured transport in pjsip.conf which is valid for the URI we are trying to contact.

  



---


Section Names
-------------

In most cases, you can name a section whatever makes sense to you. For example you might name a transport [transport-udp-nat] to help you remember how that section is being used.

However, in some cases, (endpoint and aor types) the section name has a relationship to its function. In the case of endpoint and aor their names must match the user portion of the SIP URI in the "From" header for inbound SIP requests. The exception to that rule is if you have an identify section configured for that endpoint. In that case the inbound request would be matched by IP instead of against the user in the "From" header.

Section Types
-------------

Below is a brief description of each section type and an example showing configuration of that section only. The module providing the configuration object related to the section is listed in parentheses next to each section name.

There are dozens of config options for some of the sections, but the examples below are very minimal for the sake of simplicity.

 

### ENDPOINT

(provided by module: res\_pjsip)

Endpoint configuration provides numerous options relating to core SIP functionality and ties to other sections such as auth, aor and transport. You can't contact an endpoint without associating one or more AoR sections. An endpoint is essentially a profile for the configuration of a SIP endpoint such as a phone or remote server.

EXAMPLE BASIC CONFIGURATION


---

  
  


```

[6001]
type=endpoint
context=default
disallow=all
allow=ulaw
transport=simpletrans
auth=auth6001
aors=6001

```



---


If you want to define the Caller Id this endpoint should use, then add something like the following:




---

  
  


```

trust\_id\_outbound=yes
callerid=Spaceman Spiff <6001>

```



---


### **TRANSPORT**

(provided by module: res\_pjsip)

Configure how res\_pjsip will operate at the transport layer. For example, it supports configuration options for protocols such as TCP, UDP or WebSockets and encryption methods like TLS/SSL.

You can setup multiple transport sections and other sections (such as endpoints) could each use the same transport, or a unique one. However, there are a couple caveats for creating multiple transports:

* They cannot share the same IP+port or IP+protocol combination. That is, each transport that binds to the same IP as another must use a different port or protocol.
* PJSIP does not allow multiple TCP or TLS transports of the same IP version (IPv4 or IPv6).




---


**Information:**  **Reloading Config:** Configuration for transport type sections can't be reloaded during run-time without a full module unload and load. You'll effectively need to restart Asterisk completely for your transport changes to take effect.

  



---


EXAMPLE BASIC CONFIGURATIONA basic UDP transport bound to all interfaces




---

  
  


```

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0



```



---


Or a TLS transport, with many possible options and parameters:




---

  
  


```

[simpletrans]
type=transport
protocol=tls
bind=0.0.0.0
;various TLS specific options below:
cert\_file=
priv\_key\_file=
ca\_list\_file=
cipher=
method=

```



---


### **AUTH**

(provided by module: res\_pjsip)

Authentication sections hold the options and credentials related to inbound or outbound authentication. You'll associate other sections such as endpoints or registrations to this one. Multiple endpoints or registrations can use a single auth config if needed.

EXAMPLE BASIC CONFIGURATIONAn example with username and password authentication




---

  
  


```

[auth6001]
type=auth
auth\_type=userpass
password=6001
username=6001



```



---


And then an example with MD5 authentication




---

  
  


```

[auth6001]
type=auth
auth\_type=md5
md5\_cred=51e63a3da6425a39aecc045ec45f1ae8
username=6001 

```



---


### **AOR**

(provided by module: res\_pjsip)

A primary feature of AOR objects (Address of Record) is to tell Asterisk where an endpoint can be contacted. Without an associated AOR section, an endpoint cannot be contacted. AOR objects also store associations to mailboxes for MWI requests and other data that might relate to the whole group of contacts such as expiration and qualify settings.

When Asterisk receives an inbound registration, it'll look to match against available AORs.

**Registrations:** The name of the AOR section must match the user portion of the SIP URI in the "To:" header of the inbound SIP registration. That will usually be the "user name" set in your hard or soft phones configuration.

EXAMPLE BASIC CONFIGURATIONFirst, we have a configuration where you are expecting the SIP User Agent (likely a phone) to register against the AOR. In this case, the contact objects will be created automatically. We limit the maximum contact creation to 1. We could do 10 if we wanted up to 10 SIP User Agents to be able to register against it.




---

  
  


```

[6001]
type=aor
max\_contacts=1

```



---


Second, we have a configuration where you are **not** expecting the SIP User Agent to register against the AOR. In this case, you can assign contacts manually as follows. We don't have to worry about max\_contacts since that option only affects the maximum allowed contacts to be created through external interaction, like registration.




---

  
  


```

[6001]
type=aor
contact=sip:6001@192.0.2.1:5060

```



---


Third, it's useful to note that you could define only the domain and omit the user portion of the SIP URI if you wanted. Then you could define the **user** portion dynamically in your dialplan when calling the Dial application. You'll likely do this when building an AOR/Endpoint combo to use for dialing out to an ITSP.  For example: "Dial(PJSIP/${EXTEN}@mytrunk)"




---

  
  


```

[mytrunk]
type=aor
contact=sip:203.0.113.1:5060

```



---


### **REGISTRATION**

(provided by module: res\_pjsip\_outbound\_registration)

The registration section contains information about an outbound registration. You'll use this when setting up a registration to another system whether it's local or a trunk from your ITSP.

EXAMPLE BASIC CONFIGURATIONThis example shows you how you might configure registration and outbound authentication against another Asterisk system, where the other system is using the older chan\_sip peer setup.

This example is just the registration itself. You'll of course need the associated transport and auth sections. Plus, if you want to receive calls from the far end (who now knows where to send calls, thanks to your registration!) then you'll need endpoint, AOR and possibly identify sections setup to match inbound calls to a context in your dialplan.




---

  
  


```

[mytrunk]
type=registration
transport=simpletrans
outbound\_auth=mytrunk
server\_uri=sip:myaccountname@203.0.113.1:5060
client\_uri=sip:myaccountname@192.0.2.1:5060
retry\_interval=60


```



---


And an example that may work with a SIP trunking provider




---

  
  


```

[mytrunk]
type=registration
transport=simpletrans
outbound\_auth=mytrunk
server\_uri=sip:sip.example.com
client\_uri=sip:1234567890@sip.example.com
retry\_interval=60

```



---


What if you don't need to authenticate? You can simply omit the **outbound\_auth** option.

### **DOMAIN\_ALIAS**

(provided by module: res\_pjsip)

Allows you to specify an alias for a domain. If the domain on a session is not found to match an AoR then this object is used to see if we have an alias for the AoR to which the endpoint is binding. This sections name as defined in configuration should be the domain alias and a config option (domain=) is provided to specify the domain to be aliased. 

EXAMPLE BASIC CONFIGURATION


---

  
  


```

[example2.com]
type=domain\_alias
domain=example.com

```



---


### **ACL**

(provided by module: res\_pjsip\_acl)

The ACL module used by 'res\_pjsip'. This module is independent of 'endpoints' and operates on all inbound SIP communication using res\_pjsip. Features such as an Access Control List, as defined in the configuration section itself, or as defined in **acl.conf**. ACL's can be defined specifically for source IP addresses, or IP addresses within the contact header of SIP traffic.

EXAMPLE BASIC CONFIGURATIONA configuration pulling from the acl.conf file:




---

  
  


```

[acl]
type=acl
acl=example\_named\_acl1

```



---


A configuration defined in the object itself:




---

  
  


```

[acl]
type=acl
deny=0.0.0.0/0.0.0.0
permit=209.16.236.0
permit=209.16.236.1

```



---


A configuration where we are restricting based on contact headers instead of IP addresses.




---

  
  


```

[acl]
type=acl
contactdeny=0.0.0.0/0.0.0.0
contactpermit=209.16.236.0
contactpermit=209.16.236.1

```



---


All of these configurations can be combined.

### **IDENTIFY**

(provided by module: res\_pjsip\_endpoint\_identifier\_ip)

Controls how the res\_pjsip\_endpoint\_identifier\_ip module determines what endpoint an incoming packet is from. If you don't have an identify section defined, or else you have res\_pjsip\_endpoint\_**identifier\_ip** loading **after** res\_pjsip\_endpoint\_**identifier\_user**, then res\_pjsip\_endpoint\_**identifier\_user** will identify inbound traffic by pulling the user from the "From:" SIP header in the packet. Basically the module load order, and your configuration will both determine whether you identify by IP or by user.

EXAMPLE BASIC CONFIGURATIONIts use is quite straightforward. With this configuration if Asterisk sees inbound traffic from 203.0.113.1 then it will match that to Endpoint 6001.




---

  
  


```

[6001]
type=identify
endpoint=6001
match=203.0.113.1

```



---


### **CONTACT**

(provided by module: res\_pjsip)

The contact config object effectively acts as an alias for a SIP URIs and holds information about an inbound registrations. Contact objects can be associated with an individual SIP User Agent and contain a few config options related to the connection. Contacts are created automatically upon registration to an AOR, or can be created manually by using the "contact=" config option in an AOR section. Manually configuring a CONTACT config object itself is outside the scope of this "getting started" style document.

Relationships of Configuration Objects in pjsip.conf
----------------------------------------------------

Now that you understand the various configuration sections related to each config object, lets look at how they interrelate.

You'll see that the new SIP implementation within Asterisk is extremely flexible due to its modular design. A diagram will help you to visualize the relationships between the various configuration objects. The following entity relationship diagram covers only the configuration relationships between the objects. For example if an **endpoint** object requires authorization for registration of a SIP device, then you may associate a single **auth** object with the endpoint object. Though many endpoints could use the same or different auth objects.

**Configuration Flow**: This lets you know which direction the objects are associated to other objects. e.g. The identify config section has an option "endpoint=" which allows you to associate it with an endpoint object.



| Entity Relationships | Relationship Descriptions |
| --- | --- |
| res\_sip\_configrelationships25919621 | ENDPOINT* Many ENDPOINTs can be associated with many AORs
* Zero to many ENDPOINTs can be associated with zero to one AUTHs
* Zero to many ENDPOINTs can be associated with at least one TRANSPORT
* Zero to one ENDPOINTs can be associated with an IDENTIFY

REGISTRATION* Zero to many REGISTRATIONs can be associated with zero to one AUTHs
* Zero to many REGISTRATIONs can be associated with at least one TRANSPORT

AOR* Many ENDPOINTs can be associated with many AORs
* Many AORs can be associated with many CONTACTs

CONTACT* Many CONTACTs can be associated with many AORs

IDENTIFY* Zero to One ENDPOINTs can be associated with an IDENTIFY object

ACL, DOMAIN\_ALIAS* These objects don't have a direct configuration relationship to the other objects.
 |

Unfamiliar with ERD? Click here to see a key...![](ERD_key.PNG)

 

 

