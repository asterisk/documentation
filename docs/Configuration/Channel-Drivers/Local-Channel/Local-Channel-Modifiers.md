---
title: Local Channel Modifiers
pageid: 4817188
---

## Usage

Dial-string modifiers exist that allow changing the default behavior of a Local Channel.

The modifiers are added to a channel by adding a slash followed by a flag onto the end of the Local Channel dial-string.

For example below we are adding the "n" modifier to the dial-string.

```
Local/101@mycontext/n

```

You can add more than one modifier by adding them directly adjacent to the previous modifier.

```
Local/101@mycontext/nj

```

## List of Modifiers

* 'n' - Instructs the Local channel to not do a native transfer (the "n" stands for *No release*) upon the remote end answering the line. This is an esoteric, but important feature if you expect the Local channel to handle calls exactly like a normal channel. If you do not have the "no release" feature set, then as soon as the destination (inside of the Local channel) answers the line and one audio frame passes, the variables and dial plan will revert back to that of the original call, and the Local channel will become a zombie and be removed from the active channels list. This is desirable in some circumstances, but can result in unexpected dialplan behavior if you are doing fancy things with variables in your call handling. Read about [Local Channel Optimization](../Local-Channel-Optimization) to better understand when this option is necessary.
* 'j' - Allows you to use the generic jitterbuffer on incoming calls going to Asterisk applications. For example, this would allow you to use a jitterbuffer for an incoming SIP call to Voicemail by putting a Local channel in the middle. The 'j' option must be used in conjunction with the 'n' option to make sure that the Local channel does not get optimized out of the call.
* 'm' - Will cause the Local channel to forward music on hold (MoH) start and stop requests. Normally the Local channel acts on them and it is started or stopped on the Local channel itself. This options allows those requests to be forwarded through the Local channel.
* 'b' - This option causes the Local channel to return the actual channel that is behind it when queried. This is useful for transfer scenarios as the actual channel will be transferred, not the Local channel.
