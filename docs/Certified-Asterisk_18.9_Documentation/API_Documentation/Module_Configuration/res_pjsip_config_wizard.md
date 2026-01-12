---
search:
  boost: 0.5
title: res_pjsip_config_wizard
---

# res_pjsip_config_wizard: Module that provides simple configuration wizard capabilities.

This configuration documentation is for functionality provided by res_pjsip_config_wizard.

## Overview

*PJSIP Configuration Wizard*<br>

This module allows creation of common PJSIP configuration scenarios without having to specify individual endpoint, aor, auth, identify and registration objects.<br>

<br>

For example, the following configuration snippet would create the endpoint, aor, contact, auth and phoneprov objects necessary for a phone to get phone provisioning information, register, and make and receive calls. A hint is also created in the default context for extension 1000.<br>

<br>

\[myphone\]<br>

type = wizard<br>

sends\_auth = no<br>

accepts\_auth = yes<br>

sends\_registrations = no<br>

accepts\_registrations = yes<br>

has\_phoneprov = yes<br>

transport = ipv4<br>

has\_hint = yes<br>

hint\_exten = 1000<br>

inbound\_auth/username = testname<br>

inbound\_auth/password = test password<br>

endpoint/allow = ulaw<br>

endpoint/context = default<br>

phoneprov/MAC = 001122aa4455<br>

phoneprov/PROFILE = profile1<br>

<br>

The first 8 items are specific to the wizard. The rest of the items are passed verbatim to the underlying objects.<br>

<br>

The following configuration snippet would create the endpoint, aor, contact, auth, identify and registration objects necessary for a trunk to another pbx or ITSP that requires registration.<br>

<br>

\[mytrunk\]<br>

type = wizard<br>

sends\_auth = yes<br>

accepts\_auth = no<br>

sends\_registrations = yes<br>

accepts\_registrations = no<br>

transport = ipv4<br>

remote\_hosts = sip1.myitsp.com:5060,sip2.myitsp.com:5060<br>

outbound\_auth/username = testname<br>

outbound\_auth/password = test password<br>

endpoint/allow = ulaw<br>

endpoint/context = default<br>

<br>

Of course, any of the items in either example could be placed into templates and shared among wizard objects.<br>

<br>

For more information, visit:<br>

https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Wizard/<br>


## Configuration File: pjsip_wizard.conf

### [wizard]: Provides config wizard.

For more information, visit:<br>

https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Wizard/<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [accepts_auth](#accepts_auth)| | no| | Accept incoming authentication from remote hosts.| |
| [accepts_registrations](#accepts_registrations)| | no| | Accept inbound registration from remote hosts.| |
| [aor/*](#aor/*)| | | | Variables to be passed directly to the aor.| |
| [client_uri_pattern](#client_uri_pattern)| | sip:USERNAMEREMOTE_HOST| | A pattern to use for constructing outbound registration client_uris.| |
| [contact_pattern](#contact_pattern)| | sip:REMOTE_HOST| | A pattern to use for constructing outbound contact uris.| |
| endpoint/*| | | | Variables to be passed directly to the endpoint.| |
| [has_hint](#has_hint)| | no| | Create hint and optionally a default application.| |
| [has_phoneprov](#has_phoneprov)| | no| | Create a phoneprov object for this endpoint.| |
| [hint_application](#hint_application)| | | | Application to call when 'hint_exten' is dialed.| |
| [hint_context](#hint_context)| | endpoint/context or 'default'| | The context in which to place hints.| |
| [hint_exten](#hint_exten)| | | | Extension to map a PJSIP hint to.| |
| [identify/*](#identify/*)| | | | Variables to be passed directly to the identify.| |
| inbound_auth/*| | | | Variables to be passed directly to the inbound auth.| |
| outbound_auth/*| | | | Variables to be passed directly to the outbound auth.| |
| [outbound_proxy](#outbound_proxy)| | | | Shortcut for specifying proxy on individual objects.| |
| [phoneprov/*](#phoneprov/*)| | | | Variables to be passed directly to the phoneprov object.| |
| registration/*| | | | Variables to be passed directly to the outbound registrations.| |
| [remote_hosts](#remote_hosts)| | | | List of remote hosts.| |
| [sends_auth](#sends_auth)| | no| | Send outbound authentication to remote hosts.| |
| [sends_line_with_registrations](#sends_line_with_registrations)| | no| | Sets "line" and "endpoint parameters on registrations.| |
| [sends_registrations](#sends_registrations)| | no| | Send outbound registrations to remote hosts.| |
| [server_uri_pattern](#server_uri_pattern)| | sip:REMOTE_HOST| | A pattern to use for constructing outbound registration server_uris.| |
| [transport](#transport)| | | | The name of a transport to use for this object.| |
| type| | | | Must be 'wizard'.| |


#### Configuration Option Descriptions

##### accepts_auth

At least inbound\_auth/username is required.<br>


##### accepts_registrations

An AOR with dynamic contacts will be created. If the number of contacts nneds to be limited, set aor/max\_contacts.<br>


##### aor/*

If an aor/contact is explicitly defined then remote\_hosts will not be used to create contacts automatically.<br>


##### client_uri_pattern

The literals '$\{REMOTE\_HOST\}' and '$\{USERNAME\}' will be substituted with the appropriate remote\_host and outbound\_auth/username.<br>


##### contact_pattern

The literal '$\{REMOTE\_HOST\}' will be substituted with the appropriate remote\_host for each contact.<br>


##### has_hint

Create hint and optionally a default application.<br>


##### has_phoneprov

A phoneprov object will be created. phoneprov/MAC must be specified.<br>


##### hint_application

Ignored if 'hint\_exten' isn't specified otherwise will create the following priority 1 extension in 'hint\_context':<br>

'exten => <hint\_exten>,1,<hint\_application>'<br>

<br>

You can specify any valid extensions.conf application expression.<br>

Examples:<br>

'Dial($\{HINT\})'<br>

'Gosub(stdexten,$\{EXTEN\},1($\{HINT\}))'<br>

<br>

Any extensions.conf style variables specified are passed directly to the dialplan.<br>

<br>

Normal dialplan precedence rules apply so if there's already a priority 1 application for this specific extension in 'hint\_context', this one will be ignored. For more information, visit:<br>

https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Wizard/<br>


##### hint_context

Ignored if 'hint\_exten' is not specified otherwise specifies the context into which the dialplan hints will be placed. If not specified, defaults to the endpoint's context or 'default' if that isn't found.<br>


##### hint_exten

Will create the following entry in 'hint\_context':<br>

'exten => <hint\_exten>,hint,PJSIP/<wizard\_id>'<br>

<br>

Normal dialplan precedence rules apply so if there's already a hint for this extension in 'hint\_context', this one will be ignored. For more information, visit:<br>

https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Wizard/<br>


##### identify/*

If an identify/match is explicitly defined then remote\_hosts will not be used to create matches automatically.<br>


##### outbound_proxy

Shortcut for specifying endpoint/outbound\_proxy, aor/outbound\_proxy, and registration/outbound\_proxy individually.<br>


##### phoneprov/*

To activate phoneprov, at least phoneprov/MAC must be set.<br>


##### remote_hosts

A comma-separated list of remote hosts in the form of _host_\[:_port_\]. If set, an aor static contact and an identify match will be created for each entry in the list. If send\_registrations is also set, a registration will also be created for each.<br>


##### sends_auth

At least outbound\_auth/username is required.<br>


##### sends_line_with_registrations

Setting this to true will cause the wizard to skip the creation of an identify object to match incoming requests to the endpoint and instead add the line and endpoint parameters to the outbound registration object.<br>


##### sends_registrations

remote\_hosts is required and a registration object will be created for each host in the remote \_hosts string. If authentication is required, sends\_auth and an outbound\_auth/username must also be supplied.<br>


##### server_uri_pattern

The literal '$\{REMOTE\_HOST\}' will be substituted with the appropriate remote\_host for each registration.<br>


##### transport

If not specified, the default will be used.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 