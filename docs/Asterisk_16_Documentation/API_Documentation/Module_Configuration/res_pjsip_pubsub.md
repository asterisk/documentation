---
search:
  boost: 0.5
title: res_pjsip_pubsub
---

# res_pjsip_pubsub: Module that implements publish and subscribe support.

This configuration documentation is for functionality provided by res_pjsip_pubsub.

## Configuration File: pjsip.conf

### [subscription_persistence]: Persists SIP subscriptions so they survive restarts.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| contact_uri| String| | false| The Contact URI of the dialog for the subscription| |
| cseq| Unsigned Integer| 0| false| The sequence number of the next NOTIFY to be sent| |
| endpoint| Custom| | false| The name of the endpoint that subscribed| |
| expires| Custom| | false| The time at which the subscription expires| |
| generator_data| Custom| | false| If set, contains persistence data for all generators of content for the subscription.| |
| local_name| String| | false| The local address the subscription was received on| |
| local_port| Unsigned Integer| 0| false| The local port the subscription was received on| |
| packet| String| | false| Entire SIP SUBSCRIBE packet that created the subscription| |
| prune_on_boot| Boolean| no| false| If set, indicates that the contact used a reliable transport and therefore the subscription must be deleted after an asterisk restart.| |
| src_name| String| | false| The source address of the subscription| |
| src_port| Unsigned Integer| 0| false| The source port of the subscription| |
| tag| Custom| | false| The local tag of the dialog for the subscription| |
| transport_key| String| 0| false| The type of transport the subscription was received on| |


### [resource_list]: Resource list configuration parameters.

This configuration object allows for RFC 4662 resource list subscriptions to be specified. This can be useful to decrease the amount of subscription traffic that a server has to process.<br>


/// note
Current limitations limit the size of SIP NOTIFY requests that Asterisk sends to double that of the PJSIP maximum packet length. If your resource list notifications are larger than this maximum, you will need to make adjustments.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [event](#event)| String| | false| The SIP event package that the list resource belong to.| |
| [full_state](#full_state)| Boolean| no| false| Indicates if the entire list's state should be sent out.| |
| [list_item](#list_item)| Custom| | false| The name of a resource to report state on| |
| [notification_batch_interval](#notification_batch_interval)| Unsigned Integer| 0| false| Time Asterisk should wait, in milliseconds, before sending notifications.| |
| [resource_display_name](#resource_display_name)| Boolean| no| false| Indicates whether display name of resource or the resource name being reported.| |
| type| None| | false| Must be of type 'resource_list'| |


#### Configuration Option Descriptions

##### event

The SIP event package describes the types of resources that Asterisk reports the state of.<br>


* `presence` - Device state and presence reporting.<br>

* `dialog` - This is identical to _presence_.<br>

* `message-summary` - Message-waiting indication (MWI) reporting.<br>

##### full_state

If this option is enabled, and a resource changes state, then Asterisk will construct a notification that contains the state of all resources in the list. If the option is disabled, Asterisk will construct a notification that only contains the states of resources that have changed.<br>


/// note
Even with this option disabled, there are certain situations where Asterisk is forced to send a notification with the states of all resources in the list. When a subscriber renews or terminates its subscription to the list, Asterisk MUST send a full state notification.
///


##### list_item

In general Asterisk looks up list items in the following way:<br>

1. Check if the list item refers to another configured resource list.<br>

2. Pass the name of the resource off to event-package-specific handlers to find the specified resource.<br>

The second part means that the way the list item is specified depends on what type of list this is. For instance, if you have the _event_ set to 'presence', then list items should be in the form of dialplan\_extension@dialplan\_context. For 'message-summary' mailbox names should be listed.<br>


##### notification_batch_interval

When a resource's state changes, it may be desired to wait a certain amount before Asterisk sends a notification to subscribers. This allows for other state changes to accumulate, so that Asterisk can communicate multiple state changes in a single notification instead of rapidly sending many notifications.<br>


##### resource_display_name

If this option is enabled, the Display Name will be reported as resource name. If the _event_ set to 'presence' or 'dialog', the non-empty HINT name will be set as the Display Name. The 'message-summary' is not supported yet.<br>


### [inbound-publication]: The configuration for inbound publications

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| endpoint| Custom| | false| Optional name of an endpoint that is only allowed to publish to this resource| |
| type| None| | false| Must be of type 'inbound-publication'.| |



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 