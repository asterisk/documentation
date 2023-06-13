---
title: Making a Phone Call
pageid: 4817414
---

At this point, you should be able to pick up Alice's phone and dial extension **6002** to call Bob, and dial **6001** from Bob's phone to call Alice. As you make a few test calls, be sure to watch the Asterisk command-line interface (and ensure that your verbosity is set to a value three or higher) so that you can see the messages coming from Asterisk, which should be similar to the ones below:

server\*CLI>     -- Executing [6002@from-internal:1] Dial("SIP/demo-alice-00000000", "SIP/demo-bob,20") in new stack
 -- Called demo-bob
 -- SIP/demo-bob-00000001 is ringing
 -- SIP/demo-bob-00000001 answered SIP/demo-alice-00000000
 -- Native bridging SIP/demo-alice-00000000 and SIP/demo-bob-00000001
 == Spawn extension (from-internal, 6002, 1) exited non-zero on 'SIP/demo-alice-00000000'
As you can see, Alice called extension **6002** in the [from-internal] context, which in turn used the **Dial** application to call Bob's phone. Bob's phone rang, and then answered the call. Asterisk then bridged the two calls (one call from Alice to Asterisk, and the other from Asterisk to Bob), until Alice hung up the phone.

At this point, you have a very basic PBX. It has two extensions which can dial each other, but that's all. Before we move on, however, let's review a few basic troubleshooting steps that will help you be more successful as you learn about Asterisk.

##### Basic PBX Troubleshooting

The most important troubleshooting step is to set your verbosity level to three (or higher), and watch the command-line interface for errors or warnings as calls are placed.

To ensure that your SIP phones are registered, type **sip show peers**(chan\_sip), or **pjsip show endpoints**(chan\_pjsip) at the Asterisk CLI.

To see which context your SIP phones will send calls to, type **sip show users**(chan\_sip) or **pjsip show endpoint <endpoint name>**(chan\_pjsip).

To ensure that you've created the extensions correctly in the **[from-internal]** context in the dialplan, type **dialplan show from-internal**.

To see which extension will be executed when you dial extension **6002**, type **dialplan show 6002@from-internal**.

