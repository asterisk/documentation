---
hide: toc
---

# SIP Retransmissions

## What is the problem with SIP retransmits?

Sometimes you get messages in the console like these:

```text
retrans_pkt: Hanging up call XX77yy  - no reply to our critical packet.
retrans_pkt: Cancelling retransmit of OPTIONs
```

The SIP protocol is based on requests and replies. Both sides send
requests and wait for replies. Some of these requests are
important. In a TCP/IP network many things can happen with IP
packets. Firewalls, NAT devices, Session Border Controllers and SIP
Proxys are in the signalling path and they will affect the call.

### SIP Call setup - INVITE-200 OK - ACK

To set up a SIP call, there's an INVITE transaction. The SIP software
that initiates the call sends an INVITE, then wait to get a
reply. When a reply arrives, the caller sends an ACK. This is a
three-way handshake that is in place since a phone can ring for a very
long time and the protocol needs to make sure that all devices are
still on line when call setup is done and media starts to flow.

* The first reply we're waiting for is often a "100 trying". This
  message means that some type of SIP server has received our request
  and makes sure that we will get a reply. It could be the other
  endpoint, but it could also be a SIP proxy or SBC that handles the
  request on our behalf.

* After that, you often see a response in the 18x class, like "180
  ringing" or "183 Session Progress". This typically means that our
  request has reached at least one endpoint and something is alerting
  the other end that there's a call coming in.

* Finally, the other side answers and we get a positive reply, "200
  OK". This is a positive answer. In that message, we get an address
  that goes directly to the device that answers. Remember, there could
  be multiple phones ringing. The address is specified by the Contact:
  header.

* To confirm that we can reach the phone that answered our call, we
  now send an ACK to the Contact: address. If this ACK doesn't reach
  the phone, the call fails. If we can't send an ACK, we can't send
  anything else, not even a proper hangup. Call signaling will simply
  fail for the rest of the call and there's no point in keeping it
  alive.

* If we get an error response to our INVITE, like "Busy" or
  "Rejected", we send the ACK to the same address as we sent the
  INVITE, to confirm that we got the response.

In order to make sure that the whole call setup sequence works and
that we have a call, a SIP client retransmits messages if there's too
much delay between request and expected response. We retransmit a
number of times while waiting for the first response. We retransmit
the answer to an incoming INVITE while waiting for an ACK. If we get
multiple answers, we send an ACK to each of them.

If we don't get the ACK or don't get an answer to our INVITE, even
after retransmissions, we will hangup the call with the first error
message you see above.

### Other SIP requests

Other SIP requests are only based on request - reply. There's no ACK,
no three-way handshake. In Asterisk we mark some of these as
CRITICAL - they need to go through for the call to work as
expected. Some are non-critical, we don't really care what happens
with them, the call will go on happily regardless.

### The qualification process - OPTIONS

If you turn on `qualify=` in sip.conf for a device, Asterisk will send
an OPTIONS request every minute to the device and check if it
replies. Each OPTIONS request is retransmitted a number of times (to
handle packet loss) and if we get no reply, the device is considered
unreachable. From that moment, we will send a new OPTIONS request
(with retransmits) every tenth second.

### Why does this happen?

For some reason signalling doesn't work as expected between your
Asterisk server and the other device. There could be many reasons why
this happens.

* A NAT device in the signalling path. A misconfigured NAT device is
  in the signalling path and stops SIP messages.
* A firewall that blocks messages or reroutes them wrongly in an
  attempt to assist in a too clever way.
* A SIP middlebox (SBC) that rewrites contact: headers so that we
  can't reach the other side with our reply or the ACK.
* A badly configured SIP proxy that forgets to add record-route
  headers to make sure that signalling works.
* Packet loss. IP and UDP are unreliable transports. If you loose too
  many packets the retransmits doesn't help and communication is
  impossible. If this happens with signaling, media would be unusable
  anyway.

### What can I do?

Turn on SIP debug, try to understand the signalling that happens and
see if you're missing the reply to the INVITE or if the ACK gets
lost. When you know what happens, you've taken the first step to track
down the problem. See the list above and investigate your network.

For NAT and Firewall problems, there are many documents to help
you. Start with reading sip.conf.sample that is part of your Asterisk
distribution.

The SIP signalling standard, including retransmissions and timers for
these, is well documented in the IETF RFC 3261.

Good luck sorting out your SIP issues!

/Olle E. Johansson

– oej (at) edvina.net, Sweden, 2008-07-22  
– http://www.voip-forum.com
