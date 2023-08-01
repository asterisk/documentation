---
title: Agenda 2019
pageid: 42566556
---

* Talks
	+ **Matt Fredrickson - Introduction**
		- ARI changes
		
			* Automatic context creation, no need for dialplan
			* Ability to move from one stasis application to another- Stasis caching underwent a lot of internal changes to make it easier to use
		- MWI is different, lots of work done internally
		- Attended and BlindTransfer dialplan applications for DTMF custom features
		- Variables for post dial delay calcs
		- Bundled pjproject 2.9
		- Additional ICE mappings in rtp.conf
		
			* Asterisk can mimic a STUN server by setting the IP- DTLS fragmentation support
		- MWI devstate allows subscribing to a voice mailbox as if i t were a device
		- Per member wrap up time using AddQueueMember
		- Performance improvements with internal media indexer by reducing indexing
		- PJSIP_PARSE_URI dialplan function for URI parsing
		- Ability to change strict RTP learning to only care about sequence numbers and not incorporate time
		- Improved CDR/CEL time calcs by using message time instead of processing time
		- AMI actions now also logged when manager debugging is on
		- New internal MWI API improving performance and reducing memory usage
		- All 3 app_voicemail variants can now be built
		- TRANSFERSTATUS from app_transfer
		- Ast 13 security fix only in 2020
		- Ast 15 is end of life
		- Ast 16 is LTS and is security fix only in 2022
		- Ast 17 is a standard release and goes security fix only in 2020
		- Chan_sip marked deprecated this time last year
	+ **Josh Colp - PJSIP**
		- PJSIP recommended for new installs and to migrate existing
		- Chan_sip will still be around for at least 4 years
		- PJSIP used exclusively in switchvox since Feb 2016
		- PJSIP created and maintained by Teluu
		
			* Since Feb 2005
			* Wide platform availability (Linux, Windows, iOS, Android, embedded)- We use PJSIP as low level SIP stack
		- Some high level features used when it makes sense (pubsub, outbound reg)
		- We build on top of it, and contribute to it
		- 12.0.0 was the first release including PJSIP support, back in Dec 2013
		- Things we’ve contributed
		
			* Pluggable DNS support
			* Numerous crash fixes
			* Transport related fixes- PJSIP has been heavily tested on our end
		- We don’t use pjmedia (RTP/RTCP/codecs)
		- We don’t use DNS (we use our own)
		- We don’t use pjsia (too high level)
		- The PJSIP approach needed to be modular and reasonable as possible (and pluggable)
		- We wanted the configuration to be explicit with sensible defaults
		- Bundled is recommended (and automatically included in 16 and above - configuration option for 13)
		- Uses a recent version of PJSIP rested against the Asterisk version in use
		- Includes unreleased PJSIP fixes
		- Each PJSIP build is different and can be customized for Asterisk
		- We have sorcery for “magic” PJSIP configuration
		- Maps configuration into objects using “wizards”, which provide a backend (realtime config file)
		- Configuration values must be validated and make sense
		- Can be controlled using AMI or CLI
		- Sorcery caching is highly configurable memory cache for keeping ephemeral objects in memory
		- Great for use in realtime (Switchvox uses this)
		- Configurable per object type
		- Full backend caching is also possible
		- Won’t allow invalid objects to be created as a result of invalid configuration
		- Outbound registration is simpler compared to chan_sip
		- Creates the needed objects for you based on simple configuration
		- Using templates can reduce the size of config files
		- res_pjsip binds asterisk to PJSIP
		- Provides low level functionality, APIs, and helpers
		- Chan_sip threading
		
			* 1 thread for all UDP traffic and scheduled items
			* 1 thread for each TCP/TLS/WS/WSS connection
			* 1 thread for each channel (generally)- Res_pjsip threading
		
			* 1 thread for network traffic (UDP/TCP/TLS)
			* N threads for network traffic handling (configurable and can grow)
			* 1 thread of each WE/WSS connection
			* 1 thread for each channel (generally)
			* 1 thread of scheduled items
			* Thread pool is configurable- Traffic distributor
		
			* All network traffic is received in 1 thread
			* Network traffic is distributed to worker threads for handling- All traffic is associated with an endpoint
		- Order is not fixed and is instead controlled in the global section
		- Endpoints identifiers are pluggable
		- Always guaranteed to have an endpoint
		- Low level hooks for handling SIP messages of given types
		- Res_pjsip_session
		
			* Handles SIP sessions and lifecycle
			* Provides session level helpers- Session supplements
		
			* Higher level hooks
			* When you register one, you tell it when it should be invoked
			* Example: res_pjsip_caller_id- Chan_pjsip
		
			* Glue between asterisk core and res_pjsip_session
			* Implements API defined by core for channels
			* Implements session supplement API defined by res_pjsip_session- Res_pjsip_sdp_rtp
		
			* Handle SDP negotiation of RTP streams including attributes
			* Acts as glue between RTP engine API and PJSIP sessions
			* Manages lifecycle of RTP sessions themselves- Res_pjsip_registrar
		
			* Provides functionality for REGISTER SIP requests
			* Manages AORs and contacts on them
			* Enforces configuration of AORS- Res_pjsip_pubsub
		
			* Provides functionality for SUBSCRIBE SIP requests
			* Uses PJSIP provided “evsub” API
			* Provides “Subscription/Notifier Handler” API to allow pluggable even and body types
			* Handles lifecycle of subscriptions- Res_pjsip_exten_state
		
			* Handles subs for extension state (hints)
			* Acts as glue between asterisk core and PJSIP- PJSIP vs chan_sip
		
			* “Line” support in outbound registrations
			
				+ Adds randomly generated token to outbound reg
				+ If received the request is associated with the configured endpoint
				+ Removes need for IP matching and other matching mechanisms
				+ Not supported by all SIP implementations, even though RFC says it should be* Multiple IP matching of inbound traffic
			
				+ Identify section allows multiple IP addresses to be specified or discovered
				+ Subnet masks can also be specified to allow ranges
				+ All traffic is associated back to a single endpoint, so no need to configure multiple* SRV/NAPTR load balancing and failover
			
				+ DNS resolution occurs when a SIP request is sent, result is not stored except in external DNS cache
				+ Load balancing will occur based on DNS lookup
				+ We get back a list of targets to send the request to
				+ If connection fails or certain response is received failover to new target occurs
				+ Both A and AAA records are supported with preference for AAA records* Media stream support
			
				+ Multiple streams can be negotiated in SDP
				+ Streams can be added/removed as needed by Asterisk applications
				+ Used for WebRTC SFU video support* Multiple contacts on AOR
			
				+ AOR can be configured to allow multiple contacts with policy
				+ Allows multiple phones to register using same endpoint/auth/AOR
				+ Can all be called at once* Music on hold passthrough
			
				+ If configured causes PJSIP to emit re-invite for hold/unhold
	+ **Sean McCord - Real time speech processing w/ Asterisk**
		- Benefits of external media
		
			* Speech recognition
			* Speech synthesis
			* Dynamic generation
			* External DSP
			* Machine learning
			* Realtime fraud detection
			* Live feedback- Chan_alsa (or oss)
		- App_jack
		- Chan_nbs
		- MRCP (Media Resource COntrol Protocol)
		- Chan_rtp
		- AudioSocket
		
			* Network-first
			* No telephony knowledge
			* Simple TCP protocol
			* Dialplan application interface
			* Channel interface
			* Go reference server library
			* Fully open source
			
				+ GPL (Asterisk side)
				+ Apache 2.0 (Go library)- Chan_audiosocket and app_audiosocket
		
			* AudioSocket/ip:port/UUID
			* Exten => 100,1,Answer()  
			 Same => n,AUdioSocket(UUID, ip:port)- AudioSocket: [github.com/CyCoreSystems/audiosocket](http://github.com/CyCoreSystems/audiosocket)
	+ **George Joseph - Update on Realtime speech processing**
		- Focus on call transcription with external media
		- Asterisk to ARI app to cloud speech recognition provider and vice versa
		- The audio needs to be transcoded into a format that the speech recognition server can read
		- Demo uses chan_rtp
		- For the demo, node ARI is used to communicate with Asterisk
		- There’s a UDP network listener that takes in RTP packets and strips off the RTP header
		- The speech adapter just pipes the packets that come in from the UDP socket and pipe them to Google’s libraries
		- Google sends back the transcript and we take it and use the websocket broadcaster to send it to anyone who wants to consume it
		- Using cyber mega phone for the demo, you can see the transcript appear in the chat box
		- The websocket server is the server that pipes the transcription from the provider to interested parties
		- The transcriber is the main entry point. It starts an ARI controller and sits there
		- We start the websocket server and the RTP/UDP server socket
		- Then we pass that config to Google and connect the ARI controller
		- The ARI controller connects back to ARI and starts setting things up, like creating the bridge, etc
		- For cyber mega phone, we had to create a local channel that goes into a mixing bridge, but the other side actually dials the confbridge
		- The speech provider is largely provided by Google
		- All you have to do is pass in the socket from the UDP RTP datagram socket and pipe it to the input stream
		- Google will send back a final transcription once it detects a long enough pause
		- Video would be a good addition but will more than likely be more difficult than audio
		- Websocket is another transport option that should be on the radar
		- Goals to make an external media type channel that can generically encapsulate all the necessary information and make it possible to originate via dialplan
	+ **Pascal MIchaud - More Websocket**
	
	
		- Another websocket implementation
		- You get a stream channel, give it an ID, and you can start receiving voice over the websocket
		- Sends audio to URL and prints out transcript, similar to George’s demonstration with cyber mega phone
	+ **Sylvain Boily - AMQP**
		- AMQP support for Asterisk
		- Find solutions to abstract telephony complexity
		- Simplify the scaling without any proxy
		- Multiple applications on single stasis
		- Remove direction connection to AMI (no parsing)
		- Auto-scaling
		- Remove external proxy for ARI
		- First version presented at astricon 2017
		- AMQP support for Stasis in
		
			* AMI
			* ARI
			* Channels- But it wasn’t possible to use websocket and AMQP at same time
		- Now, additions made to use websocket or AMQP for an application
		- Added ARI endpoint to activate the application
		- Add support for subscribing to ARMP for res_amqp
		- 3 modules now
		
			* With vision of adding for (pluggable systems)- Res_amqp
		
			* Client for Asterisk
			* Publish and subscribe (on a branch)
			* Based on librabbitmq
			* Configuration in /etc/asterisk/amqp.conf
			* Serves solely as a client- Res_stasis_amqp
		
			* Publish stasis messages to AMQP
			* Support for stasis AMI, ARI, channel
			* Depends on res_aqmp- Res_ari_aqmp
		
			* Activate application to use AMQP instead of websocket
			* Stateless and not stateful
			* Application is not connected, bt events are still sent
			* Create a new endpoint on ARI to permit to activate an application- Asterisk is used to send and receive messages for AMQP
		- You can subscribe to specific events as well
		- Future integration to Asterisk with Gerrit
		- Addresses the issue of having a single event to multiple clients
		- Disassociate a singular presence with the existence of an ARI application
		- If this could be added in a way that multiple people would be able to support it (or have an agreed upon approach rather than many ways of doing the same thing), then integration into Asterisk (or with Asterisk) would make more sense
		- If a connection is present on said websocket, event goes out to that application
		- Something to think about: event filtering
* Lunch ? (12 - 1)
* Topical Discussion:
	+ Test coverage: ok, can always use more tests. Test status: not as ok. We should really focus on ensuring that the tests we do have pass, so we aren’t worried about test failures that aren’t relevant when testing new code, especially for new (and old) contributors
	+ Some confusion on core support vs extended support, “burden” on Sangoma (in the sense that someone needs to be responsible for issues coming in that are extended support), community picking up the torch for support on modules, etc
	+ Multiple applications being registered as a single Stasis applications
		- Separate connection from application
		- Establish n number of connections and bind to applications
	+ Allowing a Stasis application to connect to a URI.
		- Kind of like FastAGI for ARI
		- Pass in a URI instead of app name
		- Then you can pass in the parameters in the URI and so on
	+ PJSIP DNS question by Fred Posner.
	+ Open ended discussion about external media streaming.
		- Adding more transports like websocket, TCP, etc
		- Codec selection is important
		- ARI support is nice because you can specify all the different options you want
	+ Moving swagger forward to a more modern/actual version.
		- We’ve just not had the resources to switch to a newer spec
		- Upgrading caused so many problems
		- Their upgrade path was all over the place at the time we looked at this
		- It sounds like it’s completely different now than what it was
	+ Future Development in Asterisk - What are fun new frontiers?  
	
		- High availability (active call failover)
			* Minimal configuration to have defense against a call being dropped (active call failover / Asterisk failover)
			* Way down the road, what happens with bridges? Stasis? State in general?
		- WebRTC simulcast / layered encoding
			* With certain codecs, you can encode multiple qualities in stream, and then extract them out
		- STIR/SHAKEN (maybe not "fun", but definitely important)
		- Missing ARI functionality?
			* Ability to hook dialplan applications into ARI execution flow.
			* Lower transaction count necessary to setup SIP headers on outbound channels in ARI.
	+ Opus improvements
		- Adaptive bitrate support
		- Has anybody done multichannel
		- Allowing Opus to be more than a single channel
	+ Bindings of ARI to AGI like we had with AMI
	+ Opportunistic DTLS
	
		- The sending side
		- If the first try fails, what do we do?



