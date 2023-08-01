---
title: Blinky Lights API
pageid: 26479969
---

Use Cases
=========

Mailboxes/MWI
-------------

1. App can create a custom mailbox
	1. Are mailboxes given names, or do they have unique id's?
		1. names
	2. Does a mailbox's existence persist across restarts? What about it's state?
		1. No persistence; Asterisk requests a refresh at restart/registration
2. App can publish a new state for a mailbox  

	1. Are there any common attributes for mailbox state (unplayed message count, last message timestamp, etc.)
		1. `ast_mwi_state` is defined as new message count, old message count

Presence
--------

1. App can create new presence state
	1. Apps are named
2. App can publish new presence state
	1. Are there any common attributes for presence state (state, last change timestamp, etc.)

Device State
------------

1. App can create a custom device state
	1. This can be used as an extension state in the dialplan
2. App can publish new device state
	1. Are there any common attributes for device state (state, last change timestamp, etc.)

Proposal one: Generic topics
============================

API
---

GET /topics List[Topic] - list all topics, with optional filter for type

GET /topics/{topicId} Topic - get information about a specific topic

DELETE /topics/{topidId} - destroy a topic. This should implicitly unsubscribe all subscribers.

POST /topics Topic - create a new topic. When you create a topic, you are implicitly subscribed to that topic.

    type: The type of topic to create. Valid types initially would be 'mailbox', 'device', 'presence'

    uri: The URI subscribers will use to subscribe to the topic

POST /topics/{topicId}/publish - publish an event to a topic. Events are passed as JSON, and are opaque from the perspective of ARI. It would be up to the specific topic types to understand the  event packages.



/applications/{applicationName}/subscription will be updated to allow for an ARI client to subscribe to any topic in Asterisk.

Data model
----------

Topic:

* type: string - Valid types initially would be 'mailbox', 'device', 'presence'
* uri: string - The URI subscribers use to subscribe to the topic
* subscribers: List[Subscriber] - A list of active subscriptions
* id: string - A unique ID for the topic



Subscriber

* id: string - A unique ID for the subscriber
* topic_id: string - The topic ID this subscription refers to
* endpoint: Endpoint - If available, the endpoint that subscribed to this Topic



TopicSubscriptionCreated : Event - Event raised when a new subscription is created for a topic

* subscriber : Subscriber
* topic: Topic



TopicSubscriptionDestroyed : Event - Event raised when a subscription is destroyed for a topic

* subscriber : Subscriber
* topic : Topic



TopicEvent : Event - Event raised in relation to a topic

* topic : Topic
* body : JSON



TopicCreated : Event - Event raised when a new topic is created

* topic : Topic



TopicDestroyed : Event - Event raised when a topic is destroyed

* topic : Topic

Proposal two: First class resources
===================================

API
---



| Method | URL | Return type | Description |
| --- | --- | --- | --- |
| GET | /mailboxes/{mailboxName} | Mailbox | Returns the current state of a mailbox |
| PUT | /mailboxes/{mailboxName} | void | Changes the state of a mailbox |
| DELETE | /mailboxes/{mailboxName} | void | Removes a mailbox controlled by ARI |
| GET | /presence-states/{presenceName} | Presence | Returns the current state of a Presence |
| PUT | /presence-states/{presenceName} | void | Changes presence state |
| DELETE | /presence-states/{presenceName} | void | Removes a presence state controlled by ARI |
| GET | /device-states/{deviceName} | DeviceState | Returns the current state of a device |
| PUT | /device-states/{deviceName} | void | Changes the state of a device |
| DELETE | /device-states/{deviceName} | void | Removes a device state controlled by ARI |

* Because names can include `:` or `/`, be sure to urlencode them.
* PUT is appropriate, since status updates are idempotent, and these objects are explicitly named
* You can only PUT or DELETE /presence-state for `CustomPresence:`
* You can only PUT or DELETE /device-state for `Custom:`
* If you PUT or DELETE /mailboxes when app_voicemail or app_minivm is in use, the results are undefined
* /applications/{applicationName}/subscription will be updated to handle mailbox:, presence:, and device: URI's
	+ The implementation should be generalized so that handlers for URI schemes can be pluggable

Data Model
----------

Mailbox

* name: string
* new_messages: int
* old_message: int

DeviceState

* name: string
* state: string {}

PresenceState

* name: string
* state: string

Events
------

MailboxStateChanged

* mailbox: Mailbox

DeviceStateChanged

* device_state: DeviceState

PresenceStateChanged

* presence_state: PresenceState

MailboxUpdateRequested - This is an odd event. When Asterisk starts, it has no mailbox state from the external application. This event requests that the external voicemail application PUT the current mailbox state back into Asterisk.

* mailbox_name: string
