---
title: Using Include Statements to Create Classes of Service
pageid: 4817347
---

Now that we've shown the basic syntax of include statements, let's put some include statements to good use. Include statements are often used to build chains of functionality or classes of service. In this example, we're going to build several different contexts, each with its own type of outbound calling. We'll then use include statements to chain these contexts together.

/// tip | Numbering Plans
The examples in this section use patterns designed for the North American Number Plan, and may not fit your individual circumstances. Feel free to use this example as a guide as you build your own dialplan.

In these examples, we're going to assuming that a seven-digit number that does not begin with a zero or a one is a local (non-toll) call. Ten-digit numbers (where neither the first or fourth digits begin with zero or one) are also treated as local calls. A one, followed by ten digits (where neither the first or fourth digits begin with zero or one) is considered a long-distance (toll) call. Again, feel free to modify these examples to fit your own particular circumstances.
///

/// warning | Outbound dialing
These examples assume that you have a SIP provider named provider configured in **sip.conf**. The examples dial out through this SIP provider using the **SIP/provider/number** syntax.  
///

First, let's create a new context for local calls.

```text linenums="1"
[local]
; seven-digit local numbers
exten => _NXXXXXX,1,Dial(SIP/provider/${EXTEN})

; ten-digit local numbers
exten => _NXXNXXXXXX,1,Dial(SIP/provider/${EXTEN})

; emergency services (911), and other three-digit services
exten => NXX,1,Dial(SIP/provider/${EXTEN})

; if you don't find a match in this context, look in [users]
include => users

```

Remember that the variable **${EXTEN}** will get replaced with the dialed extension. For example, if Bob dials **5551212** in the **local** context, Asterisk will execute the Dial application with **SIP/provider/5551212** as the first parameter. (This syntax means "Dial out to the account named provider using the SIP channel driver, and dial the number **5551212**.)

Next, we'll build a long-distance context, and link it back to the **local** context with an include statement. This way, if you dial a local number and your phone's channel driver sends the call to the **longdistance** context, Asterisk will search the **local** context if it doesn't find a matching pattern in the **longdistance** context.

```conf title=" " linenums="1"
[longdistance]
; 1+ ten digit long-distance numbers
exten => _1NXXNXXXXXX,1,Dial(SIP/provider/${EXTEN})

; if you don't find a match in this context, look in [local]
include => local

```

Last but not least, let's add an **international** context. In North America, you dial 011 to signify that you're going to dial an international number.

```conf title=" " linenums="1"
[international]
; 1+ ten digit long-distance numbers
exten => _011.,1,Dial(SIP/provider/${EXTEN})

; if you don't find a match in this context, look in [longdistance]
include => longdistance

```

And there we have it -- a simple chain of contexts going from most privileged (international calls) down to lease privileged (local calling).

At this point, you may be asking yourself, "What's the big deal? Why did we need to break them up into contexts, if they're all going out the same outbound connection?" That's a great question! The primary reason for breaking the different classes of calls into separate contexts is so that we can enforce some security boundaries.

Do you remember what we said earlier, that the channel drivers point inbound calls at a particular context? In this case, if we point a phone at the **local** context, it could only make local and internal calls. On the other hand, if we were to point it at the **international** context, it could make international and long-distance and local and internal calls. Essentially, we've created different classes of service by chaining contexts together with include statements, and using the channel driver configuration files to point different phones at different contexts along the chain.

Please take the next few minutes and implement a series of chained contexts into your own dialplan, similar to what we've explained above. You can then change the configuration for Alice and Bob (in **sip.conf**, since they're SIP phones) to point to different contexts, and see what happens when you attempt to make various types of calls from each phone.
