---
search:
  boost: 0.5
title: OSPLookup
---

# OSPLookup()

### Synopsis

Lookup destination by OSP.

### Description

Looks up destination via OSP.<br>

Input variables:<br>


* `OSPINACTUALSRC` - The actual source device IP address in indirect mode.<br>

* `OSPINPEERIP` - The last hop IP address.<br>

* `OSPINTECH` - The inbound channel technology for the call.<br>

* `OSPINHANDLE` - The inbound call OSP transaction handle.<br>

* `OSPINTIMELIMIT` - The inbound call duration limit in seconds.<br>

* `OSPINNETWORKID` - The inbound source network ID.<br>

* `OSPINNPRN` - The inbound routing number.<br>

* `OSPINNPCIC` - The inbound carrier identification code.<br>

* `OSPINNPDI` - The inbound number portability database dip indicator.<br>

* `OSPINSPID` - The inbound service provider identity.<br>

* `OSPINOCN` - The inbound operator company number.<br>

* `OSPINSPN` - The inbound service provider name.<br>

* `OSPINALTSPN` - The inbound alternate service provider name.<br>

* `OSPINMCC` - The inbound mobile country code.<br>

* `OSPINMNC` - The inbound mobile network code.<br>

* `OSPINTOHOST` - The inbound To header host part.<br>

* `OSPINRPIDUSER` - The inbound Remote-Party-ID header user part.<br>

* `OSPINPAIUSER` - The inbound P-Asserted-Identify header user part.<br>

* `OSPINDIVUSER` - The inbound Diversion header user part.<br>

* `OSPINDIVHOST` - The inbound Diversion header host part.<br>

* `OSPINPCIUSER` - The inbound P-Charge-Info header user part.<br>

* `OSPINCUSTOMINFON` - The inbound custom information, where 'n' is the index beginning with '1' upto '8'.<br>
Output variables:<br>


* `OSPOUTHANDLE` - The outbound call OSP transaction handle.<br>

* `OSPOUTTECH` - The outbound channel technology for the call.<br>

* `OSPDESTINATION` - The outbound destination IP address.<br>

* `OSPOUTCALLING` - The outbound calling number.<br>

* `OSPOUTCALLED` - The outbound called number.<br>

* `OSPOUTNETWORKID` - The outbound destination network ID.<br>

* `OSPOUTNPRN` - The outbound routing number.<br>

* `OSPOUTNPCIC` - The outbound carrier identification code.<br>

* `OSPOUTNPDI` - The outbound number portability database dip indicator.<br>

* `OSPOUTSPID` - The outbound service provider identity.<br>

* `OSPOUTOCN` - The outbound operator company number.<br>

* `OSPOUTSPN` - The outbound service provider name.<br>

* `OSPOUTALTSPN` - The outbound alternate service provider name.<br>

* `OSPOUTMCC` - The outbound mobile country code.<br>

* `OSPOUTMNC` - The outbound mobile network code.<br>

* `OSPOUTTOKEN` - The outbound OSP token.<br>

* `OSPDESTREMAILS` - The number of remained destinations.<br>

* `OSPOUTTIMELIMIT` - The outbound call duration limit in seconds.<br>

* `OSPOUTCALLIDTYPES` - The outbound Call-ID types.<br>

* `OSPOUTCALLID` - The outbound Call-ID. Only for H.323.<br>

* `OSPDIALSTR` - The outbound Dial command string.<br>
This application sets the following channel variable upon completion:<br>


* `OSPLOOKUPSTATUS` - The status of OSPLookup attempt as a text string, one of<br>

    * `SUCCESS`

    * `FAILED`

    * `ERROR`

### Syntax


```

OSPLookup(exten,[provider,[options]])
```
##### Arguments


* `exten` - The exten of the call.<br>

* `provider` - The name of the provider that is used to route the call.<br>

* `options`

    * `h` - generate H323 call id for the outbound call<br>

    * `s` - generate SIP call id for the outbound call. Have not been implemented<br>

    * `i` - generate IAX call id for the outbound call. Have not been implemented<br>

### See Also

* [Dialplan Applications OSPAuth](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/OSPAuth)
* [Dialplan Applications OSPNext](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/OSPNext)
* [Dialplan Applications OSPFinish](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/OSPFinish)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 