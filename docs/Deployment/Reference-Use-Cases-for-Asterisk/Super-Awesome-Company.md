---
title: Super Awesome Company
pageid: 31752244
---

Overview
========

This page describes the usage of Asterisk within Super Awesome Company (SAC), a fictitious entity for the purpose of example only. All companies, entities and peoples on this page should be assumed fictitious.

Original creator and humourist - the notorious Malcolm Davenport.

This document will be one of a few [Reference Use Cases for Asterisk](/Deployment/Reference-Use-Cases-for-Asterisk) and will be used as a basis for examples and tutorials on this wiki and included with Asterisk.

Background
==========

SAC, founded in 2015 by the noted daredevil Lindsey Freddie, the first person to BASE jump the Burj Khalifa with a paper napkin in place of a parachute, designs and delivers strategic software solutions for the multi-level marketing industry. Humbly beginning in Freddie’s garage as a subsidiary of her paper delivery route, SAC has recently moved into modern offices, complete with running water, garbage collection, and access to the Internet and the regular telephone network - a substantial upgrade from the garage-based two cans and a string, water well and composting landfill.

On this Page


Phase 1, "We're a Business"
===========================

Upon the advice of the IT staff, SAC has decided to deploy a communications system using Asterisk. For desktop endpoints, SAC has decided to deploy Digium’s IP telephones.

SAC requires:

* desk phones for each of its employees
* the ability for each employee to receive direct calls from their loved ones at home as well as kind-hearted telemarketers
* the ability for each employee to place calls to their loved ones at home, their bookies, and also potential customers
* the ability for employees to call one another inside of the office
* a main number that can be dialed by the public and that is answered by a friendly and sarcastic voice that can direct callers about what might be best for them
* a queue for inbound customers inquiring about many of the fine SAC software offerings
* a queue for inbound customers wondering why many of the fine SAC software offerings fail to live up to what customers refer to as "promises"
* an operator to handle callers that spend too much time waiting in queues
* voicemail boxes for each of the employees
* a conference bridge for use by customers and employees
* a conference bridge for use by employees only

Company Organization
--------------------

SAC employees 15 people with the following corporate structure:

* Lindsey Freddie (lindsey@[example.com](http://example.com)), President for Life
	+ Temple Morgan (temple@ [example.com](http://example.com) ), Life Assistant to the President for Life
	+ Terry Jules (terry@ [example.com](http://example.com) ), Director of Sales
		- Garnet Claude (garnet@ [example.com](http://example.com) ), Sales Associate
		- Franny Ocean (franny@ [example.com](http://example.com) ), Sales Associate
	+ Maria Berny (maria@ [example.com](http://example.com) ), Director of Customer Experience
		- Dusty Williams (dusty@ [example.com](http://example.com) ), Customer Advocate
		- Tommie Briar (tommie@ [example.com](http://example.com) ), Customer Advocate
	+ Penelope Bronte (penelope@ [example.com](http://example.com) ), Director of Engineering
		- Hollis Justy (hollis@ [example.com](http://example.com) ), Software Engineer
		- Richard Casey (richard@ [example.com](http://example.com) ), Software Engineer
		- Sal Smith (sal@ [example.com](http://example.com) ), Software Engineer
		- Laverne Roberts (laverne@ [example.com](http://example.com) ), Software Engineer
		- Colby Hildred (colby@ [example.com](http://example.com) ), IT Systems
	+ Aaron Courtney (aaron@ [example.com](http://example.com) ), Accounting and Records

  
By a stroke of luck, Freddie was also the original registrant of the [example.com](http://example.com) domain name, which, having been lost in years past, she recently managed to win back from ICANN in a game of high-stakes chubby bunny.

Outside Connectivity and Networking
-----------------------------------

SAC, located in the ghost town of Waldo, Alabama, is fortunate to have access to any type of telecommunications. In spite of Waldo’s sole telecom company, WaldoCom, having turned off the lights and locked the doors on their way out, gigabit Internet connectivity over Metro Ethernet is available and operational. It is rumored that WaldoCom left behind a skeleton crew to maintain equipment on an ongoing basis.

WaldoCom, as a traditional communications provider will allow SAC to purchase telephone service.  But, because the calling plans across the WaldoCom telephone network must be paid in Confederate dollars, SAC has instead decided to contract with Digium, Inc. for voice services.  Digium provides inbound and outbound calling over the Internet as a "SIP Trunk" using SAC's existing Internet connectivity.




!!! note 
    WaldoCom has ceased trading in Bitcoin after having been accused by the FBI of running the Silk Road as the Dread Pirate Roberts.

      
[//]: # (end-note)



SAC has purchased a well-loved Linksys WRT54G, aka "Old Unreliable," from the now defunct Waldo Happy Hands Club.  They intend to use it to terminate the Ethernet connectivity from WaldoCom.  WaldoCom provides a single IPv4 address across the link - 203.0.113.1.  The Linksys will provide NAT translation from the Internet to the internal SAC campus network.  Within the SAC network, the 10.0.0.0/8 address space will be used.

### DIDs / Telephone Numbers

Digium has provided SAC with a block of 300 DIDs (Telephone numbers) beginning with 256-555-1100 and ending with 256-555-1299.

For inbound calls, each SAC employee has a direct DID that rings them.

For outbound calls, each SAC employee’s 10-digit DID number is provided as their Caller ID.

Internal Calls
--------------

As a shortcut to dialing 10 digits, SAC uses 4-digit dialing for calls between internal employees. The 4 digits assigned to each employee match that employees last 4 digits of their inbound DID. Each employee has been individually assigned a number that can be dialed by any other employee.

SAC has other direct-dial numbers assigned to Queues and menus.

SAC also has several internal extensions that do not map directly to DIDs.

### Calls to an Extension

Calls made directly to an extension should ring for 30 sec. After 30 seconds, callers should be directed to the voicemail box of the employee. If the employee was on the phone at the time, callers should hear the voicemail busy greeting; otherwise, callers should hear the voicemail unavailable greeting.

### Voicemail

When Asterisk records a voicemail for an SAC employee, it should forward a copy of that voicemail to the employee's e-mail.

Main IVR
--------

SAC has a main IVR. Potential multi-level marketing brand ambassadors or disgruntled bottom-tier customers who find SAC in the WaldoCom Yellow Pages are greeted with a friendly voice and the following helpful message:

“Thank you for calling Super Awesome Company, Waldo’s premier provider of perfect products. If you know your party’s extension, you may dial it at any time. To establish a sales partnership, press one. To speak with a customer advocate, press two. For accounting and other receivables, press three. For a company directory, press four. For an operator, press zero.”

If no DTMF entry is detected, the main IVR repeats twice and then hangs up on the caller.

Employee Number Plan
--------------------

Temple Morgan, Esquire, Life Assistant to the President for Life, Lindsey Freddie, has randomly assigned the following phone numbers for each of the employees:

Internal Extensions

* Maria Berny - 256-555-1101
* Tommie Briar - 256-555-1102
* Penelope Bronte - 256-555-1103
* Richard Casey - 256-555-1104
* Garnet Claude - 256-555-1105
* Aaron Courtney - 256-555-1106
* Lindsey Freddie - 256-555-1107
* Colby Hildred - 256-555-1108
* Terry Jules - 256-555-1109
* Hollis Justy - 256-555-1110
* Temple Morgan - 256-555-1111
* Franny Ocean - 256-555-1112
* Laverne Roberts - 256-555-1113
* Sal Smith - 256-555-1114
* Dusty Williams - 256-555-1115

### Other Numbers

* SAC provides an extension, 8000, that lets internal employees directly dial their voicemail box. When internal SAC employees dial their voicemail box, they’re not prompted for their mailbox number or their PIN code.
* Voicemail may be accessed remotely by employees who dial 256-555-1234. When employees dial voicemail remotely, they must input both their mailbox number and their pin code.
* The Main IVR may be reached externally by dialing 256-555-1100, or internally by dialing 1100.
* The Sales Queue may be reached externally by dialing 256-555-1200, or internally by dialing 1200.
* The Customer Experience Queue may be reached externally by dialing 256-555-1250, or internally by dialing 1250.
* An Operator may be reached from any IVR menu or calling queue by dialing 0.
* The company has a party-line conference room, for use by any employee, on extension 6000.
* The company has a conference room that can be used by customers and employees on extension 6500.

Sales Queue
-----------

Calls to the Sales Queue should ring Terry, Garnet and Franny in ring-all fashion

If no one answers a call to the Sales Queue after 5 minutes, the caller should be directed to the Operator so that the Operator can take a message and have a Sales person contact the caller at a later time.

Customer Advocate Queue
-----------------------

Calls to the Customer Advocate Queue should ring Maria, Dusty and Tommie in ring-all fashion.

If no one answers a call to the Customer Advocate queue after 20 minutes, the caller should be directed to the Operator so that the Operator can take a message and have a Customer Advocate contact the caller at a later time.

Operator
--------

Temple Morgan serves as the Operator for SAC.

Deskphones
----------

Each SAC employee is provided with a Digium D70 model telephone.

Outbound calls
--------------

Because WaldoCom never upgraded their switches beyond 5-digit dialing, which now covers the entire metropolis of Waldo, SAC employees are not used to dialing 10-digit numbers.  Since most calls to potential customers will be made inside the local Waldo area, SAC has managed, through extensive training, to convince their employees to dial 7-digits for local Waldo numbers dialed over their Digium trunk.  Because Freddie believes there may be a market for the Broomshakalaka and other products outside of Waldo, perhaps even as far away as Montgomery or Mobile, she has also insisted that 10-digit dialing and 1+10-digit dialing be possible.

 

