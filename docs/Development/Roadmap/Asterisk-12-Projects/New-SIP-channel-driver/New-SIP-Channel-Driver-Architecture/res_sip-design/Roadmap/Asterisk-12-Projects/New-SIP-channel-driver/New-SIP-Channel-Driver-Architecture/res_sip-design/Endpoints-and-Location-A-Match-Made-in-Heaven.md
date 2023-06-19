---
title: Endpoints and Location, A Match Made in Heaven
pageid: 22773920
---

Fundamentals
------------

Endpoints within chan\_pjsip are a representation of the configuration information for a remote device that is to be communicated with, either unidirectionally or bidirectionally. The information within an endpoint configures and changes the behavior of the SIP infrastructure for that device. For example, you may want to specify a subset of formats for a specific endpoint while others are free to use what they wish. This is accomplished by configuring the endpoint differently.




---


**Information:**  An endpoint **MUST** be available at all times. For cases where anonymous inbound calls are permitted an explicit anonymous endpoint could be used.

  



---


Locations are broken up into AORs and contacts. An AOR is a local identifying name for reaching a specific destination. A contact contains the information required to actually contact the destination and is associated with an AOR. An AOR may have multiple contacts if configured with them or if configured to allow multiple to be externally added. The APIs which collectively provide this functionality are referred to as the "location service". For cases where an AOR is configured to allow external manipulation the system can be configured using sorcery to persist the contact information to an external persistence mechanism, such as the local astdb or another database. This allows location information to persist in case Asterisk has to be restarted or suddenly quits. The location service is a thin wrapper around the data access layer which uses sorcery. Any available sorcery wizard can be used as a persistence mechanism.




---


**Information:**  An AOR and contact is not required to reach arbitrary destinations. An explicit SIP or SIPS URI can be provided.

  



---


 

Endpoint Identifiers
--------------------

Modules which are responsible for identifying what endpoint should be used for incoming traffic are referred to as endpoint identifiers. A running system may have multiple endpoint identifiers which individually use different logic to find a potential endpoint. One endpoint identifier may use the user portion of the From header while another may do simple IP based matching.




---

**Note:**  The load order of the endpoint identifiers determines the order in which they are called for endpoint identification purposes.

  



---


Endpoint identifiers are given whole incoming requests and are expected to execute logic to retrieve an endpoint. If no endpoint is returned from all available endpoint identifiers the incoming request is rejected. A system running without any endpoint identifiers will not accept any incoming requests.

Registrar
---------

The registrar is an external interface to the location service within the SIP infrastructure. It permits external manipulation of AORs when the AOR is configured to allow it. External devices can add contacts, remove contacts, or query to get the current contacts. The registrar is responsible for enforcing any policy restrictions on the AOR such as maximum number of contacts. Due to the modular nature of the SIP infrastructure it is possible to remove registrar functionality by not loading the registrar module. If done so any registration attempts will be met with a SIP response with code 501 indicating the functionality has not been implemented.

Incoming Requests
-----------------

The first step when a request is received is delegating handling of it to another thread using a thread pool and optionally a specific task processor for serialization purposes.

If a dialog is available and it contains a cached endpoint the endpoint is placed into the request and processing continues for subsequent services.

If a dialog is not available each endpoint identifier is called until one returns an endpoint. If after all endpoint identifiers are called no endpoint is available the request is rejected. If an endpoint is returned it is placed into the request and processing continues.

By placing the endpoint into the request the number of endpoint identifier invocations, and potentially database queries, is kept to a minimum.

Outgoing Requests
-----------------

 Each outgoing request has to have a specific destination. A destination is comprised of an explicit endpoint and an explicit SIP or SIPS URI, or AOR name.

When dialing only an endpoint the list of AORs configured on it is examined. Each AOR is queried for the available contacts. The first contact returned ends the search process and \*only\* that contact is contacted.

When dialing an explicit AOR the available contacts are queried on it. The first contact returned ends the search process and \*only\* that contact is contacted.

When dialing an explicit SIP or SIPS URI only the provided URI is contacted.




---

**Tip:**  For end users who want to establish sessions with all contacts for an AOR from the dialplan the PJSIP\_DIAL\_CONTACTS dialplan function can be used to construct a dial string which dials all contacts. This is done to leverage the core support for multiple outgoing sessions.

  



---


Configuration Examples
----------------------

An example endpoint configuration is as follows:




---

  
  


```

[5000]
type=endpoint
context=default
disallow=all
allow=g722
allow=ulaw
aors=5000


```



---


 If explicitly dialed without specifying a URI or AOR the configured AOR of "5000" will be used.

An example AOR configuration, with support for external manipulation, is as follows:




---

  
  


```

[5000]
type=aor
max\_contacts=10

```



---


 This will allow a maximum of 10 contacts to be externally added to it. If exceeded the registrar will reject the registration attempt.

An example AOR configuration, with support for external manipulation but with the same behavior as chan\_sip, is as follows:




---

  
  


```

[5000]
type=aor
max\_contacts=1
remove\_existing=yes

```



---


This will cause only a single contact to be registered. Any subsequent registration attempts will cause the existing contact to be removed.

An example AOR configuration, with no support for external manipulation, is as follows:




---

  
  


```

[5000]
type=aor
static=sip:5000@internal.mypbx

```



---


 Since a static contact has been specified it will be used if this AOR is queried.




---

**WARNING!:**   
The example configuration can be used with the user endpoint identifier by configuring a SIP device with username "5000". Note that no authentication is configured so authentication will not occur. This is not recommended for a production environment.

  



---


Dialing an endpoint can be accomplished using the following:




---

  
  


```

Dial(PJSIP/5000)

```



---


Dialing an explicit AOR using an endpoint can be accomplished using the following:




---

  
  


```

Dial(PJSIP/5000/5000)

```



---


Dialing an explicit SIP URI using an endpoint can be accomplished using the following:




---

  
  


```

Dial(PJSIP/5000/sip:1234@test.com)

```



---


