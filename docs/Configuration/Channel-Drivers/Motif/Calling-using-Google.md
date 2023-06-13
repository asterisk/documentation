---
title: Calling using Google
pageid: 5996698
---

This new page replaces the old page. The old page documents behavior that is not functional or supported going forward. This new page documents behavior as of Asterisk 11. For more information, please see the blog posting <http://blogs.digium.com/2012/07/24/asterisk-11-development-the-motive-for-motif/>

Prerequisites
=============

Asterisk communicates with Google Voice and Google Talk using the chan\_motif Channel Driver and the res\_xmpp Resource module. Before proceeding, please ensure that both are compiled and part of your installation. Compilation of res\_xmpp and chan\_motif for use with Google Talk / Voice are dependant on the iksemel library files as well as the OpenSSL development libraries presence on your system.

Calling using Google Voice or via the Google Talk web client requires the use of Asterisk 11.0 or greater. Older versions of Asterisk will not work.

For basic calling between Google Talk web clients, you need a Google Mail account.

For calling to and from the PSTN, you will need a Google Voice account.

In your Google account, you'll want to change the Chat setting from the default of "Automatically allow people that I communicate with often to chat with me and see when I'm online" to the second option of "Only allow people that I've explicitly approved to chat with me and see when I'm online."

IPv6 is currently not supported. Use of IPv4 is required.

Google Voice can now be used with Google Apps accounts.

RTP configuration
-----------------

ICE support is required for chan\_motif to operate. It is disabled by default and must be explicitly enabled in the RTP configuration file rtp.conf as follows.

[general]
icesupport=yes
If this option is not enabled you will receive the following error message.

Unable to add Google ICE candidates as ICE support not available or no candidates available
Motif configuration
-------------------

The Motif channel driver is configured with the motif.conf configuration file, typically located in /etc/asterisk. What follows is an example configuration for successful operation.

### Example Motif Configuration

[google]
context=incoming-motif
disallow=all
allow=ulaw
connection=google
This general section of this configuration specifies several items.

1. That calls will terminate to or originate from the **incoming-motif** context; context=incoming-motif
2. That all codecs are first explicitly disallowed
3. That G.711 ulaw is allowed
4. The an XMPP connection called "google" is to be used

Google lists supported audio codecs on this page - <https://developers.google.com/talk/open_communications>

Per section, 5, the supported codecs are:

1. PCMA
2. PCMU
3. G.722
4. GSM
5. iLBC
6. Speex

Our experience shows this not to be the case. Rather, the codecs, supported by Asterisk, and seen in an invite from Google Chat are:

1. PCMA
2. PCMU
3. G.722
4. iLBC
5. Speex 16kHz
6. Speex 8kHz

It should be noted that calling using Google Voice requires the G.711 ulaw codec. So, if you want to make sure Google Voice calls work, allow G.711 ulaw, at a minimum.

XMPP Configuration
------------------

The res\_xmpp Resource is configured with the xmpp.conf configuration file, typically located in /etc/asterisk. What follows is an example configuration for successful operation.

### Example XMPP Configuration

[general]
[google]
type=client
serverhost=talk.google.com
username=example@gmail.com
secret=examplepassword
priority=25
port=5222
usetls=yes
usesasl=yes
status=available
statusmessage="I am available"
timeout=5
The default general section does not need any modification.

The google section of this configuration specifies several items.

1. The type is set to client, as we're connecting to Google as a service; type=client
2. The serverhost is Google's talk server; serverhost=talk.google.com
3. Our username is configured as your\_google\_username@gmail.com; username=your\_google\_username@gmail.com
4. Our password is configured using the secret option; secret=your\_google\_password
5. Google's talk service operates on port 5222; port=5222
6. Our priority is set to 25; priority=25
7. TLS encryption is required by Google; usetls=yes
8. Simple Authentication and Security Layer (SASL) is used by Google; usesasl=yes
9. We set a status message so other Google chat users can see that we're an Asterisk server; statusmessage="I am available"
10. We set a timeout for receiving message from Google that allows for plenty of time in the event of network delay; timeout=5

#### More about Priorities

As many different connections to Google are possible simultaneously via different client mechanisms, it is important to understand the role of priorities in the routing of inbound calls. Proper usage of the priority setting can allow use of a Google account that is not otherwise entirely dedicated to voice services.

With priorities, the higher the setting value, the more any client using that value is preferred as a destination for inbound calls, in deference to any other client with a lower priority value. Known values of commonly used clients include the Gmail chat client, which maintains a priority of **20**, and the Windows GTalk client, which uses a priority of **24**. The maximum allowable value is **127**. Thus, setting one's **priority** option for the XMPP peer in res\_xmpp.conf to a value higher than 24 will cause inbound calls to flow to Asterisk, even while one is logged into either Gmail or the Windows GTalk client.

Outbound calls are unaffected by the priority setting.

Phone configuration
-------------------

Now, let's create a phone. The configuration of a SIP device for this purpose would, in sip.conf, typically located in /etc/asterisk, look something like:

[malcolm]
type=peer
secret=my\_secure\_password
host=dynamic
context=local
Dialplan configuration
----------------------

### Incoming calls

Next, let's configure our dialplan to receive an incoming call from Google and route it to the SIP phone we created. To do this, our dialplan, extensions.conf, typically located in /etc/asterisk, would look like:

[incoming-motif]
exten => s,1,NoOp()
 same => n,Wait(1)
 same => n,Answer()
 same => n,SendDTMF(1)
 same => n,Dial(SIP/malcolm,20)
Did you know that the Google Chat client does this same thing; it waits, and then sends a DTMF 1. Really.

This example uses the "s" unmatched extension, because we're only configuring one client connection in this example.

In this example, we're Waiting 1 second, answering the call, sending the DTMF "1" back to Google, and **then** dialing the call.  
 We do this, because inbound calls from Google enable, even if it's disabled in your Google Voice control panel, call screening.  
 Without this SendDTMF event, you'll have to confirm with Google whether or not you want to answer the call.

Using Google's voicemailAnother method for accomplishing the sending of the DTMF event is to use Dial option "D." The D option tells Asterisk to send a specified DTMF string after the called party has answered. DTMF events specified before a colon are sent to the **called** party. DTMF events specified after a colon are sent to the **calling** party.

In this example then, one does not need to actually answer the call first, though one should still wait at least a second for things, like STUN setup, to finish. This means that if the called party doesn't answer, Google will resort to sending the call to one's Google Voice voicemail box, instead of leaving it at Asterisk.

exten => s,1,Dial(SIP/malcolm,20,D(:1))
Filtering Caller IDThe inbound CallerID from Google is going to look a bit nasty, e.g.:

+15555551212@voice.google.com/srvres-MTAuMjE4LjIuMTk3Ojk4MzM=
Your VoIP client (SIPDroid) might not like this, so let's simplify that Caller ID a bit, and make it more presentable for your phone's display. Here's the example that we'll step through:

exten => s,1,NoOp()
 same => n,Set(crazygooglecid=${CALLERID(name)})
 same => n,Set(stripcrazysuffix=${CUT(crazygooglecid,@,1)})
 same => n,Set(CALLERID(all)=${stripcrazysuffix})
 same => n,Dial(SIP/malcolm,20,D(:1))
First, we set a variable called **crazygooglecid** to be equal to the name field of the CALLERID function. Next, we use the CUT function to grab everything that's before the @ symbol, and save it in a new variable called **stripcrazysuffix.** We'll set this new variable to the CALLERID that we're going to use for our Dial. Finally, we'll actually Dial our internal destination.

### Outgoing calls

Outgoing calls to Google Talk users take the form of:

exten => 100,1,Dial(Motif/google/mybuddy@gmail.com,,r)
Where the technology is "Motif," the dialing peer is "google" as defined in xmpp.conf, and the dial string is the Google account name.

We use the Dial option "r" because Google doesn't provide ringing indications.

Outgoing calls made to Google Voice take the form of:

exten => \_1XXXXXXXXXX,1,Dial(Motif/google/${EXTEN}@voice.google.com,,r)
Where the technology is "Motif," the dialing peer is "google" as defined in motif.conf, and the dial string is a full E.164 number, sans the plus character.

Again, we use Dial option "r" because Google doesn't provide ringing indications.

