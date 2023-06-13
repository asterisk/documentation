---
title: Using Callfiles and Local Channels
pageid: 4817183
---

Another example is to use callfiles and Local channels so that you can execute some dialplan prior to performing a Dial(). We'll construct a callfile which will then utilize a Local channel to lookup a bit of information in the AstDB and then place a call via the channel configured in the AstDB.

First, lets construct our callfile that will use the Local channel to do some lookups prior to placing our call. More information on constructing callfiles is located in the doc/callfiles.txt file of your Asterisk source.

Our callfile will simply look like the following:

Channel: Local/201@devices
Application: Playback
Data: silence/1&tt-weasels 
Add the callfile information to a file such as 'callfile.new' or some other appropriately named file.

Our dialplan will perform a lookup in the AstDB to determine which device to call, and will then call the device, and upon answer, Playback() the silence/1 (1 second of silence) and the tt-weasels sound files.

Before looking at our dialplan, lets put some data into AstDB that we can then lookup from the dialplan. From the Asterisk CLI, run the following command:

\*CLI> database put phones 201/device SIP/0004f2040001 
We've now put the device destination (SIP/0004f2040001) into the 201/device key within the phones family. This will allow us to lookup the device location for extension 201 from the database.

We can then verify our entry in the database using the 'database show' CLI command:

\*CLI> database show /phones/201/device : SIP/0004f2040001 
Now lets create the dialplan that will allow us to call SIP/0004f2040001 when we request extension 201 from the extensions context via our Local channel.

[devices]
exten => 201,1,NoOp() 
exten => 201,n,Set(DEVICE=${DB(phones/${EXTEN}/device)}) 
exten => 201,n,GotoIf($[${ISNULL(${DEVICE})}]?hangup) ; if nothing returned, 
 ; then hangup
exten => 201,n,Dial(${DEVICE},30) 
exten => 201,n(hangup),Hangup()
Then, we can perform a call to our device using the callfile by moving it into the /var/spool/asterisk/outgoing/ directory.

mv callfile.new /var/spool/asterisks/outgoing\*
Then after a moment, you should see output on your console similar to the following, and your device ringing. Information about what is going on during the output has also been added throughout.

– Attempting call on Local/201@devices for application Playback(silence/1&tt-weasels) (Retry 1)
You'll see the line above as soon as Asterisk gets the request from the callfile.

– Executing [201@devices:1] NoOp("Local/201@devices-ecf0;2", "") in new stack
– Executing [201@devices:2] Set("Local/201@devices-ecf0;2", "DEVICE=SIP/0004f2040001") in new stack
This is where we performed our lookup in the AstDB. The value of SIP/0004f2040001 was then returned and saved to the DEVICE channel variable.

– Executing [201@devices:3] GotoIf("Local/201@devices-ecf0;2", "0?hangup") in new stack
We perform a check to make sure ${DEVICE} isn't NULL. If it is, we'll just hangup here.

– Executing [201@devices:4] Dial("Local/201@devices-ecf0;2", "SIP/0004f2040001,30") in new stack
– Called 000f2040001
– SIP/0004f2040001-00000022 is ringing
Now we call our device SIP/0004f2040001 from the Local channel.

SIP/0004f2040001-00000022 answered Local/201@devices-ecf0;2\*
We answer the call.

> Channel Local/201@devices-ecf0;1 was answered.
> Launching Playback(silence/1&tt-weasels) on Local/201@devices-ecf0;1
We then start playing back the files.

– <Local/201@devices-ecf0;1> Playing 'silence/1.slin' (language 'en')
== Spawn extension (devices, 201, 4) exited non-zero on 'Local/201@devices-ecf0;2'
At this point we now see the Local channel has been optimized out of the call path. This is important as we'll see in examples later. By default, the Local channel will try to optimize itself out of the call path as soon as it can. Now that the call has been established and audio is flowing, it gets out of the way.

– <SIP/0004f2040001-00000022> Playing 'tt-weasels.ulaw' (language 'en')
[Mar 1 13:35:23] NOTICE[16814]: pbx\_spool.c:349 attempt\_thread: Call completed to Local/201@devices
We can now see the tt-weasels file is played directly to the destination (instead of through the Local channel which was optimized out of the call path) and then a NOTICE stating the call was completed.

