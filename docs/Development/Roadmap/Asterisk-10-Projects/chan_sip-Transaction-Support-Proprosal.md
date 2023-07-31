---
title: chan_sip Transaction Support Proprosal
pageid: 10649861
---



# Introduction
SIP is a transactional protocol. Asterisk's chan_sip has no transaction concept of a transaction layer. Developers have spent countless hours providing workarounds for bugs caused by this situation. In fact, more hours have been spent trying to work around the issue than it would take to actually implement a transaction layer for chan_sip. This document outlines how a transaction layer can be added to chan_sip with a relatively minimal amount of change to existing code.

# Table of Contents

{toc:style=disc|indent=20px}

# Project Requirements

* RFC 3261-compliant transactions
    * Client/Server INVITE/Non-INVITE transactions
    * Connection-oriented protocols (TCP/TLS)
    * Connectionless protocols (UDP)
    * Handle transport layer errors
* Code should be as self-contained as possible to minimize bug introduction
* Possibly should be optional for backward compatibility

# What is a transaction layer?
SIP is a transactional protocol. A transaction is basically a single request and all of the responses to that request. Essentially, the SIP transaction layer sits between the User Agent core code and the transmission layer. The purpose of the transaction layer is to handle sending retransmissions of messages that have not received a timely response (with some exceptions) and to filter out (most) retransmissions and invalid messages instead of having the UA core code handle them.

# What does chan_sip currently do instead of using a transaction layer?

chan_sip, instead of maintaining a full transaction layer, tries to identify incoming retransmissions and marks them with an "ignore" flag. Then, in every request/response handling function where we think it might be important, we try to handle falling through the code to "do the right thing." This has led to many, many bugs. Many times we end up trying to reconstruct the same response to a request based on some state that isn't guaranteed not to have changed. The core code, in most circumstances should not even be aware that a retransmission has been received, let alone make a response to it one.

For retransmitting messages that chan_sip's UA code sends, chan_sip relies on the retrans_pkt function which is scheduled to run from sip_reliable_xmit.

# Proposed solution

If transaction support is enabled (either by having it be the only option, or by a config option), the "ignore" flag should never be set. The transaction layer code itself can absorb the retransmissions and the legacy code will only receive the "non-ignored" requests and responses. The existing code checking for "ignore" can be cleaned up at leisure without worrying about it causing a problem.

For handling retransmissions for messages that we send, we should always have a copy of the packet that we are sending and re-send that.

The transaction handling code should be self-contained and should rely on copies of data where possible, since retransmissions will be happening from a separate thread.

