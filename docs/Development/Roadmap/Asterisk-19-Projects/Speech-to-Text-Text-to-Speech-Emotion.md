---
title: Speech to Text / Text to Speech / Emotion
pageid: 45482453
---

Background
----------

Speech to text, text to speech, and other speech related things in Asterisk have traditionally been done in two ways: C modules, or external AGIs that use record and playback. This project aims to provide an easier bridge between the two worlds to provide a better user experience while allowing developers to more easily connect to modern speech APIs.

Overview
--------

Speech functionality is going to be passed to an outside entity to handle all of the heavy lifting, allowing us to leverage official SDKs provided by more friendly languages. This page will break down the process into sections of how Asterisk is going to accomplish this. There are already some existing dialplan and API functions for speech to text, but the core API (and dialplan applications) for text to speech will need to be created. A module will be created which registers to these APIs and provides the functionality described in The Process, Speech to Text, and Text to Speech. The module will allow multiple external applications to be configured and the user, in the dialplan, can select which one will be used.

The Process
-----------

There will be three entities involved: Asterisk, an external application, and the speech service.

Asterisk will be responsible for providing media to the external application and accepting media from the external application, as well as communicating desired functionality. From an Asterisk C developer perspective this will be done using the core APIs for speech to text and text to speech. From a user perspective this will be exposed via dialplan applications and functions which then call into the speech engine.

The connection to the external entity will be done using a Websocket from Asterisk to the external application. There will only ever be ONE Websocket connection per session. A benefit of using a single connection per session is that it provides an easy mechanism to scale out the external application if needed. A session represents a single speech to text or text to speech. The type will be either speech to text or text to speech; it can't be both, and it can't change from one to the other within the same session. A new connection will need to be started if you wish to change which type of speech service you're doing. Asterisk and the external application will communicate in JSON, since it's simple and easy for everyone to use.

Only one codec will be negotiated, which will be included in the response Asterisk gets back from the external application. This will include the codec attributes as well.

### Speech to Text

The external application will be responsible for taking the media Asterisk provides and sending it to the appropriate speech service. Asterisk will pass along all the necessary information in a JSON protocol via the Websocket, which will tell the application what to do with the media that follows. The media will also be sent over the Websocket in the form of Websocket binary frames. Responses will be sent back to Asterisk to let us know if our transaction succeeded or failed. The nice thing about having the application in between Asterisk and the speech service is that we don't have to worry about integrating directly with something like Google or Amazon, since C code would require much more effort than being able to use libraries built for other languages. The application will be able to use those libraries more effectively, allowing it to potentially utilize many different speech services.

The speech service itself will do the heavy lifting of interpreting the media and producing text. This could be any speech service that you choose since Asterisk doesn't care about anything other than sending the media over the Websocket. It will be up to the writer of the application to determine which speech services you will be able to connect to. The possibilities are infinite!

Once the media has been interpreted into text by the speech service, it will be sent back to the application, which will then forward the data back to Asterisk, ultimately ending up back in the dialplan for the user to do whatever they want with it.

### Text to Speech

The external application will be responsible for taking the text Asterisk provides and asking the appropriate TTS service to produce audio. Asterisk will pass along all the necessary information in JSON via the Websocket, which will tell the application what text to produce. The external application will provide the speech back over the Websocket in the form of Websocket binary frames. If a failure occurs a response will be sent from the external application back to Asterisk. Just like the speech to text, this allows us to leverage libraries and makes it easier to plug into services.

The speech service will do the heavy lifting of producing the audio. The audio will be played back to the user as received.

The Protocol
------------




!!! note 
    The protocol is purposely simple and generalized to allow further expansion or additional request types as needed. This includes the possibility of using it for external media purposes with ARI applications.

      
[//]: # (end-note)



As mentioned above, JSON will be used for the protocol. There are requests:

```
text{
 "version": "1.0",
 "request": "text_to_speech" | "speech_to_text",
 "codecs": [
 {
 "type": "ulaw",
 "attributes": {
 "parameter_name": "parameter_value"
 }
 }
 ],
 "app_config": {
 "gender": "male" | "female",
 "language": "english" | "en",
 "ssml": "yes" | "no"
 },
 "data": "Inconceivable!"
}

```

And responses:

```
text{
 "version": "1.0",
 "response": "success",
 "codec": {
 "type": "ulaw",
 "attributes": {
 "parameter_name": "parameter_value"
 }
 },
 "talk_detect": "true" | "false"
}

```
```
text{
 "version": "1.0",
 "response": "complete",
 "data": "Inconceivable!"
}

```
```
text{
 "version": "1.0",
 "response": "talk_detect"
}

```
```
text{
 "version": "1.0",
 "response": "error",
 "error_msg": "Could not connect to Google (server down)."
}

```

The app_config section contains arbitrary configuration options and are not defined by this protocol. They will be able to be set by the user, and then consumed by the external application.

If we get a response of success with a value of true for talk_detect, then we know that the application can handle detecting speech once it has started. Otherwise, Asterisk will default to the same functionality as the TALK_DETECT dialplan function. The talk_detect response will only be sent once when speech is first detected.

### Speech to Text

Here are some examples of what speech to text would look like.

**Scenario 1 (success)**

```
text{
 "version": "1.0",
 "request": "speech_to_text",
 "codecs": [
 {
 "type": "ulaw"
 }
 ],
 "app_config": {
 "language": "en"
 }
}

```

The first response lets us know that everything is good to go for translation.

```
text{
 "version": "1.0",
 "response": "success",
 "codec": {
 "type": "ulaw"
 }
}

```

The second response lets us know that translation is complete, with our result in the JSON under *data.*

```
text{
 "version": "1.0",
 "response": "complete",
 "data": "Inconceivable!"
}

```

**Scenario 2 (failure)**

```
text{
 "version": "1.0",
 "request": "speech_to_text",
 "codecs": [
 {
 "type": "ulaw"
 }
 ],
 "app_config": {
 "language": "en"
 }
}

```
```
text{
 "version": "1.0",
 "response": "error",
 "error_msg": "Could not connect to Google (server down)."
}

```

****Scenario 3 (language not supported)****

```
text{
 "version": "1.0",
 "request": "speech_to_text",
 "codecs": [
 {
 "type": "ulaw"
 }
 ],
 "app_config": {
 "language": "en"
 }
}

```
```
text{
 "version": "1.0",
 "response": "error",
 "error_msg": "Google does not support the language 'en'."
}

```

  


### Text to Speech

Here are some examples of what text to speech would look like.

**Scenario 1 (success)**

```
text{
 "version": "1.0",
 "request": "text_to_speech",
 "codecs": [
 {
 "type": "ulaw"
 },
 {
 "type": "alaw",
 "attributes": {
 "annexb": "no"
 }
 }
 ],
 "app_config": {
 "gender": "male",
 "language": "en",
 "ssml": "no"
 },
 "data": "Inconceivable!"
}

```

Unlike speech to text, we only need to know if setup was successful. Then we know that media will flow over the websocket.

```
text{
 "version": "1.0",
 "response": "success",
 "codec": {
 "type": "alaw",
 "attributes": {
 "annexb": "no"
 }
 }
}

```



**Scenario 2 (failure)**

```
text{
 "version": "1.0",
 "request": "text_to_speech",
 "codecs": [
 {
 "type": "ulaw"
 }
 ],
 "app_config": {
 "gender": "male",
 "language": "en",
 "ssml": "no"
 },
 "data": "Inconceivable!"
}

```
```
text{
 "version": "1.0",
 "response": "error",
 "error_msg": "Could not connect to Google (server down)."
}

```

****Scenario 3 (codec not supported)****

```
text{
 "version": "1.0",
 "request": "text_to_speech",
 "codecs": [
 {
 "type": "ulaw"
 }
 ],
 "app_config": {
 "gender": "male",
 "language": "en",
 "ssml": "no"
 },
 "data": "Inconceivable!"
}

```
```
text{
 "version": "1.0",
 "response": "error",
 "error_msg": "Google does not support the following codec(s): ulaw."
}

```

