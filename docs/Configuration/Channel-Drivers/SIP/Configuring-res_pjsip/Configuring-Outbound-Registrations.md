---
title: Configuring Outbound Registrations
pageid: 30278351
---




!!! warning 
    This page is under construction. Please refrain from commenting here until this warning is removed.

      
[//]: # (end-warning)



Overview
========

Like with `chan_sip`, Asterisk's PJSIP implementation allows for configuration of outbound registrations. Unlike `chan_sip`, it is not implemented in an obnoxious way. Like with most concepts in PJSIP configuration, outbound registrations are confined to a configuration section of their own.

Configuration options
=====================

A list of outbound registration configuration options can be found on [this page](/Latest_API/API_Documentation/Module_Configuration/res_pjsip_outbound_registration). Here is a simple example configuration for an outbound registration to a provider:

On this Page


pjsip.conf

```
[my_provider]
type = registration
server_uri = sip:registrar@example.com
client_uri = sip:client@example.com
contact_user = inbound-calls

```

This results in the following outbound REGISTER request being sent by Asterisk:

```
<--- Transmitting SIP request (557 bytes) to UDP:93.184.216.119:5060 --->
REGISTER sip:registrar@example.com SIP/2.0
Via: SIP/2.0/UDP 10.24.20.249:5060;rport;branch=z9hG4bKPjd1a32b43-82ed-4f98-ae24-20149cdf0749
From: <sip:client@example.com>;tag=904e0db9-8297-4bb0-89c5-5cfe1cfed654
To: <sip:client@example.com>
Call-ID: 03241f7b-3936-4140-8bad-6840774b78d9
CSeq: 10266 REGISTER
Contact: <sip:inbound-calls@10.24.20.249:5060>
Expires: 3600
Allow: OPTIONS, SUBSCRIBE, NOTIFY, PUBLISH, INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, MESSAGE, REFER, REGISTER
Max-Forwards: 70
Content-Length: 0

```

Let's go over how the options were applied to this REGISTER:

* The `server_uri` is the actual URI where the registrar is located. If you are registering with a SIP provider, they should give this information to you.
* The `client_uri` is used in the To and From headers of the REGISTER. In other words, this is the address of record to which you are binding a contact URI. If registering to a SIP provider, they may require you to provide a specific username in order to identify that the REGISTER is coming from you. Note that the domain of the `client_uri` is the same as the server URI. This is common when indicating that the registrar receiving the REGISTER is responsible for the URI being registered to it.
* The `contact_user` option can be seen in the user portion of the URI in the Contact header. This allows for you to control where incoming calls from the provider will be routed. Calls from the provider will arrive in this extension in the dialplan. Note that this option does not relate to endpoint-related options. For information on relating outbound registrations and endpoints, see the following section.

An English translation of the above REGISTER is "Tell the server at sip:registrar@example.com that when SIP traffic arrives addressed to sip:client@example.com, the traffic should be sent to sip:inbound-calls@10.24.20.249." Note in this example that 10.24.20.249 is the IP address of the Asterisk server that sent the outbound REGISTER request.




!!! tip 
    The transport type, e.g. tcp, for the registration can be specified by appending the details to the client_uri and/or server_uri parameters, e.g.:
[//]: # (end-tip)


  
  

```
[my_provider]
type = registration
server_uri = sip:registrar@example.com\;transport=tcp
client_uri = sip:client@example.com\;transport=tcp
contact_user = inbound-calls  



---

```



Outbound registrations and endpoints
====================================

If you examine the configuration options linked in the previous section, you will notice that there is nothing that ties an outbound registration to an endpoint. The two are considered completely separate from each other, as far as Asterisk is concerned. However, it is likely that if you are registering to an ITSP, you will want to receive incoming calls from that provider. This means that you will need to set up an endpoint that represents this provider. An example of such an endpoint configuration can be found [here](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/res_pjsip-Configuration-Examples), but it is a bit complex. Let's instead make a simpler one just for the sake of explanation. Assuming the previous registration has been configured, we can add the following:

pjsip.conf

```
[my_provider_endpoint]
type = endpoint

[my_provider_identify]
type = identify
match = <ip address of provider>
endpoint = my_provider 

```

This represents the bare minimum necessary in order to accept incoming calls from the provider. The `identify` section makes it so that incoming SIP traffic from the IP address in the `match` option will be associated with the endpoint called `my_provider_endpoint`.

If you also wish to make outbound calls to the provider, then you would also need to add an AoR section so that Asterisk can know where to send calls directed to "my_provider_endpoint".

pjsip.conf

```
[my_provider_endpoint]
type = endpoint
aors = my_provider_aor
 
[my_provider_identify]
type = identify
match = <ip address of provider>
endpoint = my_provider

[my_provider_aor]
type = aor
contact = sip:my_provider@example.com

```




!!! warning 
    Let me reiterate that this is the **bare minimum**. If you want calls to and from the provider to actually work correctly, you will want to set a context, codecs, authentication, etc. on the endpoint.

      
[//]: # (end-warning)



Authentication
==============

It is likely that if you are registering to a provider, you will need to provide authentication credentials. Authentication for outbound registrations is configured much the same as it is for endpoints. The `outbound_auth` option allows for you to point to a `type = auth` section in your configuration to refer to when a registrar challenges Asterisk for authentication. Let's modify our configuration to deal with this:

pjsip.conf

```
[my_provider]
type = registration
server_uri = sip:registrar@example.com
client_uri = sip:client@example.com
contact_user = inbound-calls
outbound_auth = provider_auth

[provider_auth]
type = auth
username = my_username
password = my_password

```

With this configuration, now if the registrar responds to a REGISTER by challenging for authentication, Asterisk will use the authentication credentials in the provider_auth section in order to authenticate. Details about what options are available in auth sections can be found [here](/Latest_API/API_Documentation/Module_Configuration/res_pjsip) in the "auth" section.

Dealing with Failure
====================

Temporary and Permanent Failures
--------------------------------

Whenever Asterisk sends an outbound registration and receives some sort of failure response from the registrar, Asterisk makes a determination about whether a response can be seen as a permanent or temporary failure. The following responses are always seen as temporary failures:

* No Response
* 408 Request Timeout
* 500 Internal Server Error
* 502 Bad Gateway
* 503 Service Unavailable
* 504 Server Timeout
* Any 600-class response

In addition, there is an option called `auth_rejection_permanent` that can be used to determine if authentication-related rejections from a registrar are treated as permanent or temporary failures. By default, this option is enabled, but disabling the setting means the following two responses are also treated as temporary failures:

* 401 Unauthorized
* 407 Proxy Authentication Required

What is meant by temporary and permanent failures? When a temporary failure occurs, Asterisk may re-attempt registering if a `retry_interval` is configured in the outbound registration. The `retry_interval` is the number of seconds Asterisk will wait before attempting to send another REGISTER request to the registrar. By default, outbound registrations have a `retry_interval` of 60 seconds. Another configuration option, `max_retries`, determines how many times Asterisk will attempt to re-attempt registration before permanently giving up. By default, `max_retries` is set to 10.

Permanent failures result in Asterisk immediately ceasing to re-attempt the outbound registration. All responses that were not previously listed as temporary failures are considered to be permanent failures. There is one exception when it comes to permanent failures. The `forbidden_retry_interval` can be set such that if Asterisk receives a 403 Forbidden response from a registrar, Asterisk can wait the number of seconds indicated and re-attempt registration. Retries that are attempted in this manner count towards the same `max_retries` value as temporary failure retries.

Let's modify our outbound registration to set these options to custom values:

pjsip.conf

```
[my_provider]
type = registration
server_uri = sip:registrar@example.com
client_uri = sip:client@example.com
contact_user = inbound-calls
outbound_auth = provider_auth
auth_rejection_permanent = no
retry_interval = 30
forbidden_retry_interval = 300
max_retries = 20

```

In general, this configuration is more lenient than the default. We will retry registration more times, we will retry after authentication requests and forbidden responses, and we will retry more often.

CLI and AMI
===========

Monitoring Status
-----------------

You can monitor the status of your configured outbound registrations via the CLI and the Asterisk Manager Interface. From the CLI, you can issue the command `pjsip show registrations` to list all outbound registrations. Here is an example of what you might see:

```
 <Registration/ServerURI..............................> <Auth..........> <Status.......>
 =========================================================================================
 my_provider/sip:registrar@example.com provider_auth Unregistered 
 outreg/sip:registrar@example.com n/a Unregistered 

```

On this particular Asterisk instance, there are two outbound registrations configured. The headers at the top explain what is in each column. The "Status" can be one of the following values:

* Unregistered: Asterisk is currently not registered. This is most commonly seen when the registration has not yet been established. This can also be seen when the registration has been forcibly unregistered or if the registration times out.
* Registered: Asterisk has successfully registered.
* Rejected: Asterisk attempted to register but a failure occurred. See the above section for more information on failures that may occur.
* Stopped: The outbound registration has been removed from configuration, and Asterisk is attempting to unregister.

In addition, you can see the details of a particular registration by issuing the `pjsip show registration <registration name>` command. If I issue `pjsip show registration my_provider`, I see the following:

```
 <Registration/ServerURI..............................> <Auth..........> <Status.......>
 =========================================================================================

 my_provider/sip:registrar@example.com provider_auth Unregistered 


 ParameterName : ParameterValue
 ====================================================
 auth_rejection_permanent : false
 client_uri : sip:client@example.com
 contact_user : inbound-calls
 expiration : 3600
 forbidden_retry_interval : 300
 max_retries : 20
 outbound_auth : provider_auth
 outbound_proxy : 
 retry_interval : 30
 server_uri : sip:registrar@example.com
 support_path : false
 transport : 

```

This provides the same status line as before and also provides the configured values for the outbound registration.

AMI provides the `PJSIPShowRegistrationsOutbound` command that provides the same information as the CLI commands. Here is an example of executing the command in an AMI session:

```
action: PJSIPShowRegistrationsOutbound


Response: Success
EventList: start
Message: Following are Events for each Outbound registration


Event: OutboundRegistrationDetail
ObjectType: registration
ObjectName: my_provider
SupportPath: false
AuthRejectionPermanent: false
ServerUri: sip:registrar@example.com
ClientUri: sip:client@example.com
RetryInterval: 30
MaxRetries: 20
OutboundProxy: 
Transport: 
ForbiddenRetryInterval: 300
OutboundAuth: provider_auth
ContactUser: inbound-calls
Expiration: 3600
Status: Rejected
NextReg: 0


Event: OutboundRegistrationDetail
ObjectType: registration
ObjectName: outreg
SupportPath: false
AuthRejectionPermanent: true
ServerUri: sip:registrar@example.com
ClientUri: sip:client@example.com
RetryInterval: 60
MaxRetries: 10
OutboundProxy: 
Transport: 
ForbiddenRetryInterval: 0
OutboundAuth: 
ContactUser: inbound-calls
Expiration: 3600
Status: Rejected
NextReg: 0


Event: OutboundRegistrationDetailComplete
EventList: Complete
Registered: 0
NotRegistered: 2

```

The command sends `OutboundRegistrationDetail` events for each configured outbound registration. Most information is the same as the CLI displays, but there is one additional piece of data displayed: NextReg. This is the number of seconds until Asterisk will send a new REGISTER request to the registrar. In this particular scenario, that number is 0 because the two outbound registrations have reached their maximum number of retries.

Manually Unregistering
----------------------

The AMI and CLI provide ways for you to manually unregister if you want. The CLI provides the `pjsip send unregister <registration name>` command. AMI provides the `PJSIPUnregister` command to do the same thing.




!!! note 
    After manually unregistering, the specified outbound registration will continue to reregister based on its last registration expiration.

      
[//]: # (end-note)





Realtime
========

At the time of this wiki article writing, it is not possible, nor would it be recommended, to use dynamic realtime for outbound registrations. The code in `res_pjsip_outbound_registration.so`, the module that allows outbound registrations to occur, does not attempt to look outside of `pjsip.conf` for details regarding outbound registrations. This is done because outbound registrations are composed both of the configuration values as well as state (e.g. how many retries have we attempted for an outbound registration). When pulling configuration from a file, a reload is necessary, which makes it easy to have a safe place to transfer state information or alter configuration values when told that things have changed. With dynamic realtime, this is much harder to manage since presumably the configuration could change at any point.

If you prefer to use a database to store your configuration, you are free to use static realtime for outbound registrations instead. Like with a configuration file, you will be forced to reload (from the CLI, `module reload res_pjsip_outbound_registration.so`) in order to apply configuration changes.

