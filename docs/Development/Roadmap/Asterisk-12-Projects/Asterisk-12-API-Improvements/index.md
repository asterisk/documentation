---
title: Overview
pageid: 21464586
---



{warning}
This page contains the original development plans and notes for Stasis and ARI. The names and organization of the final implementation are slightly different (notably, Stasis HTTP became known as ARI).
{warning}

{toc:style=none|maxlevel=3}

# Project Overview

While Asterisk has a number of interfaces one could use for building telephony applications, they suffer from several significant problems.

\* Channels identifiers are not stable. Some operations (like [masquerades|AST:Asterisk 11 ManagerEvent_Masquerade]) will change the id out from under you.
\* The protocols (AMI and AGI) are non-standard and poorly documented, making them difficult to work with.
\* AMI's message format is restricted to simple name/value pairs. Commands that need to pass back lists or structured data are very hackish.
\* AMI event filtering is very course grained, and established in configuration instead of at runtime. This has lead to some creative solutions to dealing with the flood of events (most of which are not of interest).
\* AGI is a synchronous interface, which really hinders making truly interactive applications.
\*\* While AsyncAGI attempts to address this issue, it is an asynchronous wrapper around a synchronous implementation. Commands queue up after one another, and are not interruptible, leading to many of the same problems with AGI or FastAGI.
\* Internally, AMI events are formatted into strings at the time they are created. This makes it very difficult to do anything with the events, except send them out AMI connections. This also makes using different protocol formats difficult.
\* Different interfaces tend to implement the same logical command in different ways.

We're going to start with fixing one of the most glaring problems with the current APIs: [add a stable identifier to channels|https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-20725], and use that identifier consistently throughout AMI. This solves a big problem for current AMI+AGI based applications.

Unfortunately, solving some of the larger problems would be very intrusive with the current API's, and introduce a host of breaking changes. Some are so fundamental, we would essentially be rewriting the interface. That's not acceptable; the current API's aren't going anywhere anytime soon.

This leads us down the path of adding a new interface to Asterisk. We've got some time to put some though into this, so let's do it right. Since things are easier to talk about when they have a name, the new API work has the working title [Stasis|#bad-name].

We want the API to be familiar and approachable to developers. We don't want to force them to use C. In fact, we don't want to force them to use any particular programming language; the API should be accessible from the language and platform of their choice.

The API should be relatively high level, and not get stuck down in the details of what's happening inside of Asterisk. Asterisk may go through all sorts of shenanigans to do what it needs to do, but the API should provide a nice, clean abstraction.

In building out the new API, we don't want to repeat past mistakes by re-implement the same functionality several times in slightly different ways. There should be a single core implementation, that all of the API's use. This would improve consistency between the API's and reduce code duplication.

To accomplish this, Stasis will be a set of new modules for providing control and management interfaces into Asterisk. While Stasis will initially be focused on third party call control and monitoring, it should be extensible enough to provide configuration and provisioning API's in the future.

Internally to Asterisk, {{stasis-core}} will provide a message bus for interfacing with Asterisk objects. The {{stasis-http}} component will be built upon this message bus to expose a RESTful API, also utilizing WebSockets for asynchronous communication to the external applications.

The split between {{stasis-core}} and {{stasis-http}} should allow for other protocol bindings to be added in the future. This could even go so far as replacing the existing API's with Stasis implementations.

The selection of HTTP as the first binding for Stasis allows for very broad appeal, ease of use, and simplicity for writing client libraries to make it easier to write applications to the API.

# Requirements and Specification

## Stasis Requirements

\* \*Asynchronous Everything\* \- Most applications need to be able to interrupt activities, and receive events as they happen. Blocking operations are the devil.
\* \*Version Stability\* \- This is important. Like, really important. The current mechanisms may change dramatically between releases, which causes developers/integrators/etc. to keep running on older versions of Asterisk than anyone would like.
\* \*Interoperability\* \- Stasis must work in a variety of environments, detailed below.
\*\* \*Programming Language\* \- Stasis applications should be able to be easily written in a variety of languages.
\* \*Security\* \- Reasonable security measures should be taken.
\*\* Encryption: Since the API should not be accessible on a public network, encryption is not high in the priority list.
\*\*\* Even if connections are plain text, reasonable precautions should be taken with sensitive information (e.g. use challenge handshakes for authentication instead of passing plaintext passwords over the wire).
\*\*\* If a binding protocol (say, HTTP) supports encryption (say, HTTPS), then it should be supported for Stasis as well.
Not needed immediately, and way down on the priority list.
\*\* Authentication: Client only authentication is sufficient. Should not be any more complicated than passwords/pre-shared secrets.
\*\* Authorization: See [below|#Stasis Authorization Requirements].

h3. Authorization Requirements

Unfortunately, authorization is a tricky subject.

There are many different schemes for implementing authorization, and we've learned that if you're not careful you can end up with a scheme that doesn't provide the value that you hoped for, and is more costly than you expected. And this cost shows up in the complexity of both the implementation and the API.

It's also important to understand who you are authorizing. In the case of the API, we are authorizing applications for API access; not (necessarily) the end users of the phone system. It's somewhat similar to the three tier client/application/database relationship. The database authenticates the application, and determines what data the application can access. The application authenticates the client, and determines what subset of that data it exposes to the client. It's not a perfect comparison, but you get the idea.

Possible use cases to consider:

\* \*Host multiple companies in one PBX\* \- "which channels are one particular user (or group) allowed to follow, manipulate and originate".
\* \*Read only applications\* \- A monitoring application should not be able to affect the state of the system.

## Internal Improvements

\* \*Stable channel identifier\* \- this is necessary for a reasonable Stasis API. Since so much of the world still depends on AMI, it should be updated to allow the stable id to be used in place of the current channel id
\* \*AMI Event Structure\* \- AMI events should be generated into a key/value object pair instead of the {{printf}}\-style string formatting currently used. This would allow Stasis to reuse the existing events.
\* \*Improved implementation consistency\* \- While not something we would address in the initial Stasis work, existing disparate implementations could be reworked to use a single, consistent {{stasis-core}} implementation.
\* \*Fix AMI Bridge Events\*
\*\* Current event precludes multi-party bridges (Only has {{Channel1}} and {{Channel2}})
\*\* Some events in the system result in spurious Bridge events (such as [DTMF|https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-18639])

## Use Cases

Note that at this point this it the list of _candidate_ use cases. Which ones we get to, and in what priority, have not been determined yet.

h3. Summary Level

Highest level use cases; more or less applications that could be build on top of Stasis.

\* \*Standard two party call\* \- Very standard use case for Asterisk.
\* \*Conference\* \- Multi-participant calls, in which media from one endpoint may be sent to two or more endpoints.
\*\* Some participants may control the conference via DTMF key presses
\*\* Some participants may be muted
\*\* Indicate who is speaking
\* \*IVR\* \- Interactive Voice Response.
\*\* Plays media to caller
\*\* Detects DTMF key presses from caller
\*\* Record media from caller
\* \*Queue\* \- Call dispatch queue.
\*\* Get presence information from queue agents
\*\* Originate calls to agents as needed
\*\* When agent answers, bridge to most appropriate call from queue
\*\* May add supervisor to agent/caller conversation
\* \*Voicemail\*
\*\* Record audio from caller
\*\* Playback recorded audio
\*\* Detect DTMF for media control (fast forward, skip, delete)

h3. User Level

\* \*Answer\*&nbsp;\- An application may answer a ringing channel.
\* \*Hangup/Reject\* \- An application may hangup an active channel, or reject a ringing channel.
\* \*Return to dialplan\* \- An application may send a channel back to the dialplan to continue processing.
\* \*Originate\* \- An application may originate a new channel.
\* \*DTMF Detection\* \- DTMF, and other channel events.
\* \*Bridge\* \- Two or more channels may be bridged together, so that media from any channel may be mixed and sent to the others
\*\* \*Speaker Events\* \- Events indicating which channel(s) on the bridge are speaking.
\* \*Play\* \- An application may specify media to be played on a channel.
\* \*Presence\* \- An application may query the presence state of endpoints, and subscribe to presence updates.
\* \*Record\* \- An application may record the media from a channel/bridge.
\* \*BLF\* \- The application may light up the BLF on an endpoint.

h3. Sub-function Level

\* \*Media Control\* \- During the playback of media, the application may issue fine-grained media control commands. (fast forward, pause, stop, etc.)
\* \*Mute participant\* \- Within a bridge, an application may (un)mute individual channels, controlling which media streams are mixed and sent to other participants.

## Guidelines

h3. PBX vs. Toolkit

From the README in trunk: "Asterisk is an Open Source PBX and telephony toolkit." However, whether or not we are PBX-centric has implications for the API.

Currently, Asterisk leans more toward being a toolkit than a PBX. There is a very loose coupling between extensions and endpoints, as is typically defined by dialplan code in the extensions.conf file. There is no concept of 'inside' versus 'outside', unless you put it in the dialplan yourself. There is no standard definition of a 'call', or a 'user'. All of these vary depending upon your application, and being able to be applied to a variety of applications is what has made Asterisk so successful.

However, the primary application Asterisk is applied to is being a PBX. It is important that developers writing PBX applications aren't bogged down with general telephony toolkit details.

So while the PBX use cases are important, they should not undermine the general purpose toolkit use cases. Largely, this will influence default values and conventions of the API.

h3. Convention over Configuration

Continuing on with the theme of PBX vs. Toolkit, the API should adopt an approach of convention over configuration: reasonable defaults should be used wherever possible. Configuration should be possible, allowing users to specify their own values in place of these defaults.

## Configuration

h3. stasis-http.conf

Configuration for the HTTP binding for Stasis.

h4. \[general\]

|| Parameter || Description || Type || Default Value ||
| enabled | Turns Stasis HTTP binding on or off \\
HTTP server must be enabled in http.conf for this to take effect | Boolean | yes |
| pretty | When set to yes, responses from stasis-http are formatted to be human readable | Boolean | no |
| allowed_origins | Comma separated list of allowed origins, for Cross-Origin Resource Sharing. May be set to {{\\*}} to allow all origins. | Comma separated strings | |
| use_manager_auth | Share authentication with AMI over HTTP. | Boolean | no |

h4. \[username\]

|| Parameter || Description || Type || Default Value ||
| read_only | When set to yes, user is only authorized for read-only requests. | Boolean | no |
| crypt_password | Method of encryption used on password. | \{ crypt, plain \} | plain |
| password | Crypted or plaintext password for username. See [authentication|#HTTP Authentication] below | String | n/a |

h3. stasis-core.conf

Configuration for the Stasis Message Bus.

h4. \[threadpool\]

|| Parameter || Description || Type || Default Value ||
| initial_size | Initial size of the threadpool | Integer | 0 |
| idle_timeout | Number of seconds a thread should be idle before dying | Integer (seconds) | 20 |
| max_size | Maximum number of threads in the threadpool | Integer | 200 |

h3. RealTime schemas

## APIs

h3. Dialplan Applications

\*Stasis\* \- direct a call to a Stasis application.

\*Arguments\*
\* \*name\* \- Name of the application to direct the call to.
\* \*args\* \- List of arguments to pass to the application.

The {{Stasis}} application is how a channel goes from the dialplan to a Stasis application. When a channel enters the {{Stasis}} application in the dialplan, a [StasisStart|AST:Asterisk 12 REST Data Models#StasisStart] event is sent to the application's associated WebSocket. The application can then control the channel using the [REST API|Asterisk 12 RESTful API], returning the channel to the dialplan using the [/channels/\{channelId\}/continue|AST:Asterisk 12 Channels REST API#continueInDialplan] resource.

h3. RESTful HTTP API

As [detailed below|#res_stasis_http], Stasis will expose a RESTful HTTP API for third party call control. This API should be documented using [Swagger|http://swagger.wordnik.com/], which allows for not only the generation of usable, interactive documentation, but also allows for the generation of server stubs, reducing a lot of the tediousness required in implementing a web application in C.

See the [Asterisk 12 RESTful API] page for full descriptions of the proposed RESTful API, including URL's, supported methods, and the schema of the returned resources.

The Swagger API documentation lives in the {{rest-api/}} directory in source. The generated code may be regenerated using {{make stasis-stubs}}, and requires Python and [pystache|https://github.com/defunkt/pystache] to be installed. In addition to generating a ton of boilerplate code for implementing the API, it also generates [the documentation mentioned above|AST:Asterisk 12 RESTful API].

A project is underway to write an [Asterisk Client Library Generator] which will be capable of producing comprehensive client libraries in several languages. The generator uses the Swagger resource files included in Asterisk to generate the libraries.

Message formats will initially be in JSON, but care will be taken with message design so that adding support for XML will be straightforward.

h4. Error Responses

The RESTful API will follow HTTP conventions for [HTTP return codes|http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html]. If you try to access a channel that does not exist, you will get a 404 Not Found. If you try to play audio on a channel that isn't currently in a Stasis application, you will get a 409 Conflict. If Asterisk encounters an unexpected error, you will get a 500 Internal Server Error.

In addition to the HTTP error code, the response body will be a JSON doc (or XML, when we support it) describing the error in further detail.

h4. WebSocket Events

{note}
Originally it was thought that the WebSocket would also accept commands for managing subscriptions, applications, etc. It turned out to complicate a lot more than it simplified, so it made more sense to make the WebSocket simply an asynchronous event channel from Asterisk to the Stasis-HTTP client.
{note}

In addition to responding to commands from the application, Stasis-HTTP will also need to asynchronously send events to the application, notifying the application of new channels, state changes, etc.

While it's not strictly a part of the RESTful API, it is treated as if it were. The WebSocket API is [documented using Swagger|AST:Asterisk 12 Events REST API], and its URL will be {{/stasis/events}}, alongside the RESTful URL's. The events that will be sent on the WebSocket are document in the [RESTfu API data models|AST:Asterisk 12 REST Data Models#Event].

h4. HTTP Authentication

Usernames and passwords for Stasis-HTTP are configured in stasis-http.conf ([see above|#stasis-http.conf]).

If a user is configured without a password, their username is treated as an API key. They can authenticate to Stasis-HTTP by simply passing their API key along using the {{api_key=}} request parameter.

If the user is configured with a password, they must authenticate using HTTP Basic authentication.

The password may be stored as plaintext, or can be stored using [crypt(3)|http://man7.org/linux/man-pages/man3/crypt.3.html]. A crypted password can be generated using the {{mkpasswd -m sha-512}} command.

# Design 

## Pretty Picture

{gliffy:name=PrettyPicture|align=left|size=L|version=1}

{anchor:message-bus} 
## {{stasis.c}} - Stasis Message Bus 

\*Header\*: {{asterisk/stasis.h}} 

The [Stasis Message Bus|AST:Stasis Message Bus] is how message producers and consumers are decoupled within the new API work. 

Please see the [API docs|http://doxygen.asterisk.org/trunk/stasis.html] and the [wiki page|AST:Stasis Message Bus] for further details. 

## {{res_stasis.c}} - Stasis Application API 

\*Header\*: {{asterisk/stasis_app.h}} 

High level application API's for Asterisk. The [Message Bus|#message-bus] provides a read-only view into Asterisk. This API gives you high level manipulation. The functions in this API should correspond roughly one-to-one to the sorts of methods you would put into an external API. 

Please see the [API docs|http://doxygen.asterisk.org/trunk/d8/d9c/stasis__app_8h.html] for further details.. 

## {{app_stasis.c}} - Stasis Dialplan Application 

\*Application\*: Stasis 

The {{app\_stasis.so}} module simply exports the {{res\_stasis.so}} functionality as a dialplan application. This allows you to send channels to a Stasis application from within the dialplan. 

{code:none} 
; Send channel to the 'Queue' application, with the args 'enqueue,sales' 
exten => 7001,1,Stasis(Queue,enqueue,sales) 
{code} 

## {{stasis_\{channels,bridges,endpoints\}.c}} 

\*Headers\*: {{stasis_\{channels,bridges,endpoints\}.h}} 

Channels, endpoints and bridges will have their own Stasis topics and messages for publishing state and event messages about themselves. Each object also has a _snapshot_, which is a immutable struct representing the state of the underlying object at a particular point in time. 

Each object has its own topic, to which it posts snapshots and messages regarding events that happen to that object. These messages are all forwarded to an aggregation topic ({{ast\_\{channel,endpoint,bridge}\_topic\_all}}), which is cached by a caching topic ({{ast\_\{channel,endpoint,bridge}\_topic\_all\_cached}}). 

The aggregation and caching topics allow for components that need to monitor the overall state of the system (such as Manager). The caching topics allows components to query for the most recent snapshot of an object without querying the actual object itself. The reduces contention on the object itself, and reduces the opportunities for deadlock. 

See the [API docs|http://doxygen.asterisk.org/trunk/df/deb/group__StasisTopicsAndMessages.html] for further details. 

## {{manager_\{channels,bridges,endpoints\}.c}} - Existing component refactoring. 

Existing Manager events and CLI commands can (and should) be refactored to receive events from the appropriate aggregator topics, and retrieve state from the cache topics. 

The topics and messages for the main components of Asterisk are defined in {{main/stasis\_\{channel,endpoint,bridge}.c}}. The refactored Manager code will be implemented in {{main/manager\_\{channel,endpoint,bridge}.c}}. 

## Stasis RESTful API 

\*API docs\*: {{rest-api}} 

The RESTful Stasis HTTP implementation is broken down into several components. Much of the boiler plate code declaring routes and parsing parameters is done by code generated by the API docs. The generated code can be regenerated by running {{make stasis-stubs}}. 

h3. {{res_stasis_http.c}} - Request handling and routing 

\*Header\*: {{asterisk/stasis\_http.h}} 

The {{res\_stasis\_http.so}} module has the common code for handling and routing requests. HTTP resource modules register themselves with the RESTful API by using the {{stasis_http_add_handler()}} and {{stasis_http_remove_handler()}} functions. 

h3. {{res_stasis_http_\{resource\}.c}} (generated) 

The structures declaring the routing for requests for a specific resource, and callbacks for parsing request arguments for the request. 

h3. {{stasis_http/resource_\{resource\}.c}} 

\*Header\*: {{stasis_http/resource_\{resource\}.h}} (generated) 

Implementation code for RESTful HTTP requests. The bulk of this code should be in consuming the request and producing the response. The bulk of the logic to carry out the request belongs in {{res_stasis.so}}, or in the underlying component. By keeping the HTTP modules free of business logic, we give ourselves a better shot at implementing other API bindings in a way that the different interfaces actually act consistently.

# Test Plan

Each controller in the RESTful API should have at least one integration test validating that function. Many will have multiple tests to validate failure conditions (originate failed, etc.).

|| Test || Level || Description ||
| stasis_obj_to_json | Unit | Tests Stasis object to JSON codec |
| stasis_obj_to_xml | Unit | Tests Stasis object to XML codec |

# Project Planning

## JIRA Issues

{jiraissues:url=https://github.com/asterisk/asterisk/issues/jira/sr/jira.issueviews:searchrequest-xml/11923/SearchRequest-11923.xml?tempMax=1000|anonymous=true}

## Contributors

|| Name || E-mail Address ||
| [~dlee] | dlee@digium.com |

# Reference Information

\* Stable identifier for channels:
\*\* [~dlee:Stable Identifiers for Asterisk]
\*\* [http://lists.digium.com/pipermail/asterisk-dev/2009-May/038430.html](http://lists.digium.com/pipermail/asterisk-dev/2009-May/038430.html)
\*\* [http://lists.digium.com/pipermail/asterisk-dev/2010-June/044754.html](http://lists.digium.com/pipermail/asterisk-dev/2010-June/044754.html)
\*\* [https://reviewboard.asterisk.org/r/760/](https://reviewboard.asterisk.org/r/760/)
\* Stasis API:
\*\* [http://lists.digium.com/pipermail/asterisk-dev/2012-November/057814.html](http://lists.digium.com/pipermail/asterisk-dev/2012-November/057814.html)
\*\*\* Thread continues here: [http://lists.digium.com/pipermail/asterisk-dev/2012-December/057853.html](http://lists.digium.com/pipermail/asterisk-dev/2012-December/057853.html)
\*\* [http://lists.digium.com/pipermail/asterisk-dev/2012-December/057893.html](http://lists.digium.com/pipermail/asterisk-dev/2012-December/057893.html)

# Footnotes

\* {anchor:bad-name} While it may stand for "Some Thought Actually Spent In Specification", suggestions for a better name are welcome.

