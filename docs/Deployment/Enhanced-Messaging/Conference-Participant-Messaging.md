---
title: Conference Participant Messaging
pageid: 40818222
---

Overview
========

Since Asterisk 13.22.0 and 15.5.0, in-dialog SIP MESSAGE support in the chan\_pjsip channel driver is enhanced and conference bridges added support for relaying messages.  The chan\_pjsip channel driver now allows exchanging enhanced messages with Asterisk's core that have additional metadata indicating the sender and the mime-type of the message contents.  The conference bridges now allow relaying text and enhanced messages from one participant to all other participants.

How it works
============

It sounds simple enough but this required some restructuring of the bridging core to preserve the original sender's information and add support for text content types other than text/plain.

* The participant creates a SIP MESSAGE request with a specific content type, message body, and optionally a "From" display name.
* The participant then sends that message in-dialog to the conference bridge.
* Normally when a channel driver receives a text message, it passes only the text body to the bridging core, but this causes the sender and content type to be lost.  Now, when the chan\_pjsip res\_pjsip\_messaging module receives an in-dialog SIP MESSAGE, it captures the From header's display name, the content type, and the body to pass on to the bridging core.  Other than the From display name, no other sender information is exposed.
* When bridge\_softmix (the bridging module used by ConfBridge) sees the message, it relays it to all other bridge participants.
* Any other participants connected via chan\_pjsip will get the From display name, content-type, and body.  Those not connected via chan\_pjsip will get whatever the channel driver supports.
Using Enhanced Messaging
========================

While Enhanced Messaging is interesting for Asterisk 13, it is very interesting for Asterisk 15 and later.  Imagine a video conference using Asterisk 15's Selective Forwarding Unit (SFU) capability in ConfBridge.  Enhanced Messaging allows the conference participants to chat while participating in the conference.  [CyberMegaPhone](/Installing-and-Configuring-CyberMegaPhone) is an example for such a video conference application.

Configuring Asterisk
--------------------

There is no additional configuration needed.  Enhanced Messaging is built-in and always available.

In the browser...
-----------------

How you design the user interface portion is totally up to you but here is a sample of how [CyberMegaPhone](/Installing-and-Configuring-CyberMegaPhone) could be extended to send a message using [JsSIP](http://jssip.net).  In this example, this.\_ua is a JsSIP.UA instance and this.rtc is a JsSIP.RTCSession instance.  Refer to the [CyberMegaPhone](/Installing-and-Configuring-CyberMegaPhone) code to see where this might fit.




---

  
  


```

CyberMegaPhone.prototype.sendMessage = function (string\_msg, options = {} ) {
 /\*
 \* You could allow the user to set a nickname
 \* for themselves which JsSIP can send as the
 \* display name in the SIP From header. In the code
 \* that receives the message, you can then grab the
 \* display name from the packet.
 \*/
 if (options.from) {
 from = options.from;
 this.\_ua.set("display\_name", from);
 }
 /\*
 \* The message payload can be any UTF-8 string but you are not
 \* limited to plain text. The Content-Type must be set to one
 \* of the text/ or application/ types but as long as the sender
 \* and receiver agree on the payload format, it can contain
 \* whatever you want. In this example, we are going to send
 \* a JSON blob.
 \*
 \* If you do not want to alter the display name on the actual
 \* SIP MESSAGE From header, you could include the user's
 \* nickname in the payload.
 \*/
 let msg = {
 'From': from,
 'Body': string\_msg
 };
 let body = JSON.stringify(msg);
 let extraHeaders = [ 'Content-Type: application/x-myphone-confbridge-chat+json' ];
 this.rtc.sendRequest(JsSIP.C.MESSAGE, {
 extraHeaders,
 body: body,
 eventHandlers: options.handlers
 });
};
/\*
 \* Now here is how you would call sendMessage
 \*/
 phone.sendMessage("Hello!", {from: "My Name", handlers: {
 onSuccessResponse(response) {
 // You may want to show an indicator that the message was sent successfully.
 console.log("Message Sent: " + response);
 },
 onErrorResponse(response) {
 console.log("Message ERROR: " + response);
 },
 onTransportError() {
 console.log("Could not send message");
 },
 onRequestTimeout() {
 console.log("Timeout sending message");
 },
 onDialogError() {
 console.log("Dialog Error sending message");
 },
 }});

```



---


Congratulations, you have just sent a text message!  Assuming the user called a conference bridge in the first place, all the other participants should receive it.  The code to retrieve the message is even simpler than the code to send it.  Once again, in this CyberMegaPhone example, this.\_ua is the JsSIP.UA instance.




---

  
  


```

 this.\_ua.on('newMessage', function (data) {
 /\* We do not care about messages we send. \*/
 if (data.originator === 'local') {
 return;
 }
 /\* Grab the Content-Type header from the packet \*/
 let ct = data.request.headers['Content-Type'][0].raw;
 /\* Make sure the message is one we care about \*/
 if (ct === 'application/x-myphone-confbridge-chat+json') {
 /\* Parse the body back into an object \*/
 let msg = JSON.parse(data.request.body);
 /\* Tell the UI that we got a chat message \*/
 that.raise('messageReceived', msg);
 }
 });

```



---


