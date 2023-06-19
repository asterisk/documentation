---
title: Resource List Subscription Test Plan
pageid: 29392925
---

For your tests, SIPp is mentioned as a tool to perform the tests; however, given the level of detail that will be necessary when checking the contents of SIP NOTIFY bodies, you will probably be better off not trying to use SIPp's built-in tools for NOTIFY checking. I have added a [pxby](http://pyxb.sourceforge.net)-generated library to the testsuite located at lib/python/rlmi.py that can parse RLMI documents into python classes. There is a demonstration of how to use the module in contrib/scripts/rlmi\_demo.py.

Resource List Tests
===================

The following is a base configuration to use for pjsip.conf for the tests on this page. Individual tests may carry instructions on alterations to make to the configuration.

pjsip.conf:




---

  
  


```

[pres\_list]
type = resource\_list
event = presence
list\_item = alice@default
list\_item = bob@default
 
[mail\_list]
type = resource\_list
event = message-summary
list\_item = alice
list\_item = bob
 
[sipp]
type = endpoint
context = default

```



---


extensions.conf:




---

  
  


```

[default]
exten => alice,hint,Custom:alice
exten => bob,hint,Custom:bob

```



---


It is expected that tests that use the `mail_list` are using external MWI, not app\_voicemail.

Nominal tests
-------------

Each of these tests should be run twice: once subscribing to `pres_list`, once subscribing to `mail_list`.

#### Test 1: Simple subscription establishment

Use SIPp to subscribe to a list. Ensure the following of the SUBSCRIBE response:

* The response code is 200
* There is a Require: eventlist header

For this test, do not worry about the content of the initial NOTIFY from Asterisk.

#### Test 2: Initial NOTIFY content

Use SIPp to establish a subscription to pres\_list. Ensure the following are true in the NOTIFY from Asterisk:

* There is a Require: eventlist header
* The Content-Type header contains "multipart/related"
* The body contains the following:
	+ An application/rlmi+xml part
		- There is only a single "list" element
		- The list element has the attribute version="0"
		- The list element has the attribute fullState="true"
		- The list element contains two "resource" elements
			* Each resource element contains a name element that corresponds to the `list_item` value in the config.
			* Each resource element contains a one "instance" element
				+ There should be an id attribute with a value that corresponds to the `list_item` value in the config.
				+ There should be an attribute state="active"
				+ There should be cid attributes for each instance that correspond to Content-ID headers in the later body parts.
	+ Two event-package-specific body parts: one for alice and one for bob.
		- The alice part has a Content-ID header with value equal to the cid attribute from the instance element of the alice resource from the RLMI part.
		- The bob part has a Content-ID header with value equal to the cid attribute from the instance element of the bob resource from the RLMI part.

#### Test 3: State change with full notification state

Add the following line to each list in pjsip.conf:




---

  
  


```

full\_state = yes

```



---


Use SIPp to subscribe to a list. After Asterisk sends the initial notification, change the state of alice. Ensure that Asterisk sends a NOTIFY and that the following changes from the first NOTIFY are present:

* The list element in the RLMI body part has attribute version="1"
* The body part for alice reflects the change made.
* The Content-ID headers may be different from what they were in the first NOTIFY, but the RLMI body should still have correct matching cid attributes for each resource.

#### Test 4: State change with partial notification state

Add the following line to the configured list in pjsip.conf:




---

  
  


```

full\_state = no

```



---


Repeat Test 3. This time, the NOTIFY sent on the state change should have the following changes from the first NOTIFY sent:

* The RLMI version should be "1".
* The RLMI fullState attribute should be "false".
* The RLMI list contains only the alice resource.
* The resource should have a cid attribute that matches the Content-ID header in the alice body part.
* There should be only one body part besides the RLMI part.
* This body part should accurately reflect the changed state for alice.

#### Test 5: Resubscribing

Use SIPp to subscribe to a list. After receiving the first NOTIFY from Asterisk, have the SIPp scenario resubscribe. Ensure that the NOTIFY that Asterisk sends is the same as the first, with the following changes:

* The RLMI version is "1" instead of "0".
* The Content-ID headers may be different from what they were in the first NOTIFY, but the RLMI body should still have the correct matching cid attributes for each resource.

Run a second iteration of the test with the `full_state` option set to "no" and ensure that the behavior is the same (i.e. the NOTIFY sent from Asterisk does not have partial state).

#### Test 6: Subscription Termination

Use SIPp to subscribe to pres\_list. After receiving the first NOTIFY from Asterisk, have the SIPp scenario end the subscription by sending a subscribe with Expires: 0 to unsubscribe. Like with Test 5, ensure that the NOTIFY that Asterisk sends has bumped the RLMI version number and that the cid attributes in the RLMI body match the Content-ID headers in the simple-message-summary bodies.

After the subscription has ended, perform a state change on the alice mailbox. Ensure that Asterisk does not send any SIP traffic as a result.

Run a second iteration of the test with the `full_state` option set to "no" and ensure the behavior is the same (i.e. the NOTIFY sent from Asterisk does not have partial state).

Off-nominal tests
-----------------

Unlike the nominal tests, these should not automatically be run for each supported event type. Each test will specify which lists they apply to.

#### Test 1: Subscriber does not support resource lists

Have the SIPp scenario attempt to subscribe to pres\_list, but include no "Supported: eventlist" header in the SIPp scenario. Ensure that Asterisk responds to the SUBSCRIBE with a 421 error.

#### Test 2: Incorrect event specified

Have the SIPp scenario attempt to subscribe to `mail_list` but set the Event header of the SUBSCRIBE to "presence". Ensure that Asterisk responds to the SUBSCRIBE with a 404 response.




---

**Note:**  If the circumstances are reversed (i.e. SIPp attempts to subscribe to `pres_list` with "Event: message-summary" in the SUBSCRIBE), the SUBSCRIBE will succeed, subscribing to a single mailbox called "mail\_list".

  



---


#### Test 3: List does not exist

For this test, remove the `pres_list` definition from pjsip.conf.

Have the SIPp scenario attempt to subscribe to `pres_list`. Ensure that Asterisk responds with a 404 response.

#### Test 4: No list resources exist

For this test, do not include the extensions.conf file that has been used in previous tests. Have SIPp attempt to subscribe to `pres_list`. Ensure that Asterisk responds to the SUBSCRIBE with a 404 response.

#### Test 5: Some list resources exist

For this test, remove the alice extension from extensions.conf.

Have SIPp attempt to subscribe to `pres_list`. Ensure that Asterisk responds to the SUBSCRIBE with a 200 OK. Ensure that the NOTIFY Asterisk sends contains an RLMI body part with only a single resource (for bob) and only one application/pidf+xml body part with bob's state.

#### Test 6: Resource duplication

For this test, alter the `pres_list` configuration to be the following:




---

  
  


```

[pres\_list]
type = resource\_list
event = presence
list\_item = alice@default
list\_item = alice@default

```



---


Have SIPp subscribe to `pres_list`. Ensure that Asterisk responds to the SUBSCRIBE with a 200 OK. Ensure that the NOTIFY Asterisk sends contains an RLMI body part with only a single resource (for alice) and only one application/pidf+xml body part.

Lists of lists
==============

The following are base configurations to use for these tests. Individual tests may specify changes to make to the configs.

pjsip.conf:




---

  
  


```

[pres\_list]
type = resource\_list
event = presence
list\_item = pres\_sublist
 
[pres\_sublist]
type = resource\_list
event = presence
list\_item = alice@default
list\_item = bob@default
 
[mail\_list]
type = resource\_list
event = message-summary
list\_item = mail\_sublist
 
[mail\_sublist]
type = resource\_list
event = message-summary
list\_item = alice
list\_item = bob
 
[sipp]
type = endpoint
context = default

```



---


extensions.conf:




---

  
  


```

[default]
exten => alice,hint,Custom:alice
exten => bob,hint,Custom:bob

```



---


Nominal Tests
-------------

For nominal tests, each test should be run once for `pres_list` and once for `mail_list`.

### Category 1: List of Lists

#### Test 1: Initial NOTIFY

Have SIPp subscribe to a list. Ensure that Asterisk responds with a 200 OK.

Ensure that the body of the NOTIFY that Asterisk sends contains a multi-part/related body with the following two parts:

1. An application/rlmi+xml part
2. An embedded multipart/related part

The application/rlmi+xml part should have the following properties:

* A list element with attribute version="0", fullState="true".
	+ One resource element within the list. The id for the resource is the name of the sublist.
	+ The cid of the resource should correspond to the Content-ID header in the embedded multipart/related body.

The multipart/related part should satisfy the same properties as the nominal tests from the basic resource list tests




---

**Note:**  It was about at this point while writing this test plan that I decided that if I was going to finish it before I grew old and died, I should pare down the amount of detail

  



---


#### Test 2: State change

Have SIPp subscribe to a list. Change the state of one of the alice resource. Ensure that Asterisk sends a NOTIFY with a multipart/related body consisting of an RLMI part and an embedded multipart/related body. Ensure that the version numbers on both RLMI parts have incremented by 1. Ensure that Content-IDs of appropriate body parts match up with corresponding RLMI cid attributes. Ensure that alice's state has been updated as appropriate.

#### Test 3: Resubscription

Have SIPp subscribe to a list. After the first NOTIFY, have SIPp resubscribe to the list. Ensure that the NOTIFY sent by Asterisk contains the same information as the initial NOTIFY, with only appropriate changes made (i.e. RLMI version number and Content-IDs)

#### Test 4: Termination

Have SIPp subscribe to a list. After the first NOTIFY, have SIPp terminate its subscription to the list. Ensure that the NOTIFY sent by Asterisk contains the same information as the initial NOTIFY, with only appropriate changes made (i.e. RLMI version number and Content-IDs).

Change the state of alice, and ensure that Asterisk does not send 

### Category 2: List of resources and Lists

The following tests involve subscribing to a list that is composed of a sublist and a individual resources. You can get this effect by using the following config files:

pjsip.conf:




---

  
  


```

[pres\_list]
type = resource\_list
event = presence
list\_item = pres\_sublist
list\_item = carol@default
 
[pres\_sublist]
type = resource\_list
event = presence
list\_item = alice@default
list\_item = bob@default
 
[mail\_list]
type = resource\_list
event = message-summary
list\_item = mail\_sublist
list\_item = carol
 
[mail\_sublist]
type = resource\_list
event = message-summary
list\_item = alice
list\_item = bob
 
[sipp]
type = endpoint
context = default

```



---


extensions.conf




---

  
  


```

[default]
exten => alice,hint,Custom:alice
exten => bob,hint,Custom:bob
exten => carol,hint,Custom:carol

```



---


#### Test 1: Subscription establishment

#### Test 2: State change: alice or bob, full state

#### Test 3: State change: alice or bob, partial state

#### Test 4: State change: carol, full state

#### Test 5: State change: carol, partial state

#### Test 6: Subscription renewal

#### Test 7: Subscription termination

Off-nominal Tests
-----------------

#### Test 1: Ambiguity: List and resource have same name

Configuration has a list and an individual resource with identical names. Ensure that the list is subscribed to.

#### Test 2: Ambiguity: List and resource have same name, subscriber does not support lists

Configuration has a list and an individual resource with identical names. The subscriber does not have a Supported: eventlist header in its SUBSCRIBE request. Ensure that the individual resource is subscribed to.

#### Test 2: Resource Duplication

Configuration has a list that contains resource "alice" and a sublist that contains resource "alice". Ensure that only one of the duplicated resources appears in the notifications from Asterisk.




---

**Note:**  Once code is written, come back and specify whether we expect the sole resource or the sublist resource to be the one that is listed.

  



---


Batched Notifications
=====================

#### Test 1: Basic Batched Notification

Configure a resource list that enables batched notifications. Ensure that batching does **not** occur on

* Subscription
* Resubscription
* Subscription termination

and that batching does occur on a state change to a subscribed resource. For this test, just make a single change and ensure that the cofigured interval occurs before Asterisk sends the notification.

#### Test 2: Single resource, multiple changes

Configure a resource list that enables batched notifications. Make multiple rapid state changes to a single resource. Ensure that Asterisk sends only a single notification at batching time and that it has the latest state of the resource.

Ensure that if `full_state` is enabled, that the batch contains all subscribed resources' states. Ensure that if `full_state` is disabled, the batch contains only the single resource whose state was changed.

#### Test 3: Multiple resources, single change to each

Configure a resource list that enables batched notifications. Make a single state changes to each resource in the list. Ensure that Asterisk sends only a single notification at batching time and that it has the latest states of all changed resources.

Ensure that if `full_state` is enabled, that the batch contains all subscribed resources' states. Ensure that if `full_state` is disabled, the batch contains only the resources whose states were changed.

#### Test 4: Nested lists

Configure a resource list that is composed of a sub-list. The outer list does not have batching disabled, but the inner list does.

Subscribe to the outer list. Ensure that when a resource in the inner list changes, the notification is sent out immediately.

#### Test 4: Resubscription interruption

Configure a resource list with batching enabled.

Subscribe to the list, then initiate a state change. While the change is being batched, resubscribe to the list. Ensure that the notification Asterisk sends in response to the resubscription contains full state and has the latest correct state for the resource. Ensure that the batching of the notification has been canceled and that Asterisk does not send out another notification.

#### Test 5: Termination interruption

Configure a resource list with batching enabled.

Subscribe to the list, then initiate a state change. While the change is being batched, terminate the subscription to the list. Ensure that the notification Asterisk sends in response to the termination contains full state and has the latest correct state for the resource. Ensure that the batching of the notification has been canceled and that Asterisk does not send out any further notifications.

PUBLISH
=======

