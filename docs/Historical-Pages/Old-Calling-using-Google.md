---
title: Old Calling using Google
pageid: 20189120
---


Note that Google's changes to their Google Voice system have rendered the functionality of chan\_gtalk and res\_jabber unreliable. Additionally, ongoing maintenance of of chan\_gtalk and res\_jabber for Asterisk versions prior to Asterisk 11 is not provided by Digium and is instead in the charge of the community. For more information, please see the current page , where things have changed, as well as the blog posting <http://blogs.digium.com/2012/07/24/asterisk-11-development-the-motive-for-motif/>


Prerequisites
-------------


Asterisk communicates with Google Voice and Google Talk using the chan\_gtalk Channel Driver and the res\_jabber Resource module. Before proceeding, please ensure that both are compiled and part of your installation. Compilation of res\_jabber and chan\_gtalk for use with Google Talk / Voice are dependant on the iksemel library files as well as the OpenSSL development libraries presence on your system.


Calling using Google Voice or via the Google Talk web client requires the use of Asterisk 1.8.1.1 or greater. The 1.6.x versions of Asterisk only support calls made using the legacy GoogleTalk external client.


For basic calling between Google Talk web clients, you need a Google Mail account.


For calling to and from the PSTN, you will need a Google Voice account.


In your Google account, you'll want to change the Chat setting from the default of "Automatically allow people that I communicate with often to chat with me and see when I'm online" to the second option of "Only allow people that I've explicitly approved to chat with me and see when I'm online."


IPv6 is currently not supported. Use of IPv4 is required.


Google Voice can now be used with Google Apps accounts.


Gtalk configuration
-------------------


The chan\_gtalk Channel Driver is configured with the gtalk.conf configuration file, typically located in /etc/asterisk. What follows is the minimum required configuration for successful operation.


##### Minimum Gtalk Configuration



[general]
context=local
allowguest=yes
bindaddr=0.0.0.0
externip=216.208.246.1

[guest]
disallow=all
allow=ulaw
context=local
connection=asterisk

This general section of this configuration specifies several items.


1. That calls will terminate to or originate from the **local** context; context=local
2. That guest calls are allowd; allowguest=yes
3. That RTP sessions will be bound to a local address (an IPv4 address must be present); bindaddr=0.0.0.0
4. (optional) That your external (the one outside of your NAT) IP address is defined; externip=216.208.246.1


The guest section of this configuration specifies several items.


1. That no codecs are allowed; disallow=all
2. That the ulaw codec is explicitly allowed; allow=ulaw
3. That calls received by the guest user will be terminated into the **local** context; context=local
4. That the Jabber connection used for guest calls is called "asterisk;" connection=asterisk


Jabber Configuration
--------------------


The res\_jabber Resource is configured with the jabber.conf configuration file, typically located in /etc/asterisk. What follows is the minimum required configuration for successful operation.


##### Minimum Jabber Configuration



[general]
autoregister=yes

[asterisk]
type=client
serverhost=talk.google.com
username=your\_google\_username@gmail.com/Talk
secret=your\_google\_password
port=5222
usetls=yes
usesasl=yes
statusmessage="I am an Asterisk Server"
timeout=100

The general section of this configuration specifies several items.


1. Debug mode is enabled, so that XMPP messages can be seen on the Asterisk CLI; debug=yes
2. Automated buddy pruning is disabled, otherwise buddies will be automatically removed from your list; autoprune=no
3. Automated registration of users from the buddy list is enabled; autoregister=yes


The asterisk section of this configuration specifies several items.


1. The type is set to client, as we're connecting to Google as a service; type=client
2. The serverhost is Google's talk server; serverhost=talk.google.com
3. Our username is configured as your\_google\_username@gmail.com/resource, where our resource is "Talk;" username=your\_google\_username@gmail.com/Talk
4. Our password is configured using the secret option; secret=your\_google\_password
5. Google's talk service operates on port 5222; port=5222
6. TLS encryption is required by Google; usetls=yes
7. Simple Authentication and Security Layer (SASL) is used by Google; usesasl=yes
8. We set a status message so other Google chat users can see that we're an Asterisk server; statusmessage="I am an Asterisk Server"
9. We set a timeout for receiving message from Google that allows for plenty of time in the event of network delay; timeout=100


Phone configuration
-------------------


Now, let's place a phone into the same context as the Google calls. The configuration of a SIP device for this purpose would, in sip.conf, typically located in /etc/asterisk, look something like:



[malcolm]
type=peer
secret=my\_secure\_password
host=dynamic
context=local

Dialplan configuration
----------------------


##### Incoming calls


Next, let's configure our dialplan to receive an incoming call from Google and route it to the SIP phone we created. To do this, our dialplan, extensions.conf, typically located in /etc/asterisk, would look like:



exten => s,1,Answer()
exten => s,n,Wait(2)
exten => s,n,SendDTMF(1)
exten => s,n,Dial(SIP/malcolm,20)


Note that you might have to adjust the "Wait" time from 2 (in seconds) to something larger, like 8, depending on the current mood of Google. Otherwise, your incoming calls might not be successfully picked up.


This example uses the "s" unmatched extension, because Google does not forward any DID when it sends the call to Asterisk.


In this example, we're Answering the call, Waiting 2 seconds, sending the DTMF "1" back to Google, and **then** dialing the call.  

We do this, because inbound calls from Google enable, even if it's disabled in your Google Voice control panel, call screening.  

Without this SendDTMF event, you'll have to confirm with Google whether or not you want to answer the call.


Using Google's voicemail
Another method for accomplishing the sending of the DTMF event is to use the D dial option. The D option tells Asterisk to send a specified DTMF string after the called party has answered. DTMF events specified before a colon are sent to the **called** party. DTMF events specified after a colon are sent to the **calling** party.


In this example then, one does not need to actually answer the call first. This means that if the called party doesn't answer, Google will resort to sending the call to one's Google Voice voicemail box, instead of leaving it at Asterisk.



exten => s,1,Dial(SIP/malcolm,20,D(:1))

Filtering Caller ID
The inbound CallerID from Google is going to look a bit nasty, e.g.:



+15555551212@voice.google.com/srvres-MTAuMjE4LjIuMTk3Ojk4MzM=

Your VoIP client (SIPDroid) might not like this, so let's simplify that Caller ID a bit, and make it more presentable for your phone's display. Here's the example that we'll step through:



exten => s,1,Set(crazygooglecid=${CALLERID(name)})
exten => s,n,Set(stripcrazysuffix=${CUT(crazygooglecid,@,1)})
exten => s,n,Set(CALLERID(all)=${stripcrazysuffix})
exten => s,n,Dial(SIP/malcolm,20,D(:1))

First, we set a variable called **crazygooglecid** to be equal to the name field of the CALLERID function. Next, we use the CUT function to grab everything that's before the @ symbol, and save it in a new variable called **stripcrazysuffix.** We'll set this new variable to the CALLERID that we're going to use for our Dial. Finally, we'll actually Dial our internal destination.


##### Outgoing calls


Outgoing calls to Google Talk users take the form of:



exten => 100,1,Dial(gtalk/asterisk/mybuddy@gmail.com)

Where the technology is "gtalk," the dialing peer is "asterisk" as defined in jabber.conf, and the dial string is the Google account name.


Outgoing calls made to Google Voice take the form of:



exten => \_1XXXXXXXXXX,1,Dial(gtalk/asterisk/+${EXTEN}@voice.google.com)

Where the technology is "gtalk," the dialing peer is "asterisk" as defined in jabber.conf, and the dial string is a full E.164 number (plus character followed by country code, followed by the rest of the digits).


### Interactive Voice with Text Response (IVTR)


Because the Google Talk web client provides both audio and text interface, you can use it to provide a text-based way of traversing Interactive Voice Response (IVR) menus. This is necessary since the client does not have any DTMF inputs.


In the following dialplan example, we will answer the call, wait a bit, send some text that will show up in the caller's Google Talk client, play back a prompt, capture the caller's text-based response, and then dial the appropriate SIP device.



exten => s,1,Answer()
exten => s,n,SendText("If you know the extension of the party you wish to reach, dial it now.")
exten => s,n,Background(if-u-know-ext-dial)
exten => s,n,Set(OPTION=${JABBER\_RECEIVE(asterisk,${CALLERID(name)::15},5)})
exten => s,n,Dial(SIP/${OPTION},20)

Note that with the JABBER\_RECEIVE function, we're receiving the text from **asterisk** which we defined earlier in this page as our connection to Google. We're also specifying with **${CALLERID(name)::15}** that we want to strip off the last 15 characters from the CallerID name string - which is the number of characters that Google is appending, as of this writing, to represent an internal call ID number, and that we want to wait **5** seconds for a response.


### Webinar


A Webinar was conducted on Tuesday, March 24, 2011 detailing Asterisk configuration for calling using Google as well as several usage cases. A copy of the slides, in PDF format, is available here - 

