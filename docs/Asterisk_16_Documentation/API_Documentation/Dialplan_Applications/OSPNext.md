---
search:
  boost: 0.5
title: OSPNext
---

# OSPNext()

### Synopsis

Lookup next destination by OSP.

### Description

Looks up the next destination via OSP.<br>

Input variables:<br>


* `OSPINHANDLE` - The inbound call OSP transaction handle.<br>

* `OSPOUTHANDLE` - The outbound call OSP transaction handle.<br>

* `OSPINTIMELIMIT` - The inbound call duration limit in seconds.<br>

* `OSPOUTCALLIDTYPES` - The outbound Call-ID types.<br>

* `OSPDESTREMAILS` - The number of remained destinations.<br>
Output variables:<br>


* `OSPOUTTECH` - The outbound channel technology.<br>

* `OSPDESTINATION` - The destination IP address.<br>

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

* `OSPOUTCALLID` - The outbound Call-ID. Only for H.323.<br>

* `OSPDIALSTR` - The outbound Dial command string.<br>
This application sets the following channel variable upon completion:<br>


* `OSPNEXTSTATUS` - The status of the OSPNext attempt as a text string, one of<br>

    * `SUCCESS`

    * `FAILED`

    * `ERROR`

### Syntax

### See Also

* [Dialplan Applications OSPAuth](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/OSPAuth)
* [Dialplan Applications OSPLookup](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/OSPLookup)
* [Dialplan Applications OSPFinish](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/OSPFinish)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 