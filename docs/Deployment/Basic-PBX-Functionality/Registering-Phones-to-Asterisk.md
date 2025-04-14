---
title: Registering Phones to Asterisk
pageid: 4817418
---

The next step is to configure the phones themselves to communicate with Asterisk. The way we have configured the accounts in the SIP channel driver, Asterisk will expect the phones to **register** to it. Registration is simply a mechanism where a phone communicates "Hey, I'm Bob's phone... here's my username and password. Oh, and if you get any calls for me, I'm at this particular IP address."

Configuring your particular phone is obviously beyond the scope of this guide, but here are a list of common settings you're going to want to set in your phone, so that it can communicate with Asterisk:

* **Registrar/Registration Server** - The location of the server which the phone should register to. This should be set to the IP address of your Asterisk system.
* **SIP User Name/Account Name/Address** - The SIP username on the remote system. This should be set to demo-alice on one phone and demo-bob on the other. This username corresponds directly to the section name in square brackets in sip.conf.
* **SIP Authentication User/Auth User** - On Asterisk-based systems, this will be the same as the SIP user name above.
* **Proxy Server/Outbound Proxy Server** - This is the server with which your phone communicates to make outside calls. This should be set to the IP address of your Asterisk system.

When using chan_sip you can tell whether or not your phone has registered successfully to Asterisk by checking the output of the **sip show peers** command at the Asterisk CLI. If the **Host** column says **(Unspecified)**, the phone has not yet registered. On the other hand, if the **Host** column contains an IP address and the **Dyn** column contains the letter **D**, you know that the phone has successfully registered.

```
server\*CLI> sip show peers
Name/username Host Dyn NAT ACL Port Status
demo-alice (Unspecified) D A 5060 Unmonitored
demo-bob 192.168.5.105 D A 5060 Unmonitored
2 sip peers [Monitored: 0 online, 0 offline Unmonitored: 2 online, 0 offline]

```

In the example above, you can see that Alice's phone has not registered, but Bob's phone has registered.

For chan_pjsip you can use **pjsip show endpoints**.

!!! tip 
    Debugging SIP Registrations

    If you're having troubles getting a phone to register to Asterisk, make sure you watch the Asterisk CLI with the verbosity level set to at least three while you reboot the phone. You'll likely see error messages indicating what the problem is, like in this example:
[//]: # (end-tip)

```
NOTICE[22214]: chan_sip.c:20824 handle_request_register: Registration from '"Alice"&nbsp;
<sip:demo-alice@192.168.5.50>' failed for '192.168.5.103' - Wrong password

---

As you can see, Asterisk has detected that the password entered into the phone doesn't match the secret setting in the [demo-alice] section of sip.conf.

```
