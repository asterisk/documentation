---
search:
  boost: 0.5
title: Originate
---

# Originate()

### Synopsis

Originate a call.

### Description

This application originates an outbound call and connects it to a specified extension or application. This application will block until the outgoing call fails or gets answered, unless the async option is used. At that point, this application will exit with the status variable set and dialplan processing will continue.<br>

This application sets the following channel variable before exiting:<br>


* `ORIGINATE_STATUS` - This indicates the result of the call origination.<br>

    * `FAILED`

    * `SUCCESS`

    * `BUSY`

    * `CONGESTION`

    * `HANGUP`

    * `RINGING`

    * `UNKNOWN` - In practice, you should never see this value. Please report it to the issue tracker if you ever see it.

### Syntax


```

Originate(tech_data,type,arg1,[arg2,[arg3,[timeout,[options]]]])
```
##### Arguments


* `tech_data` - Channel technology and data for creating the outbound channel. For example, SIP/1234.<br>

* `type` - This should be 'app' or 'exten', depending on whether the outbound channel should be connected to an application or extension.<br>

* `arg1` - If the type is 'app', then this is the application name. If the type is 'exten', then this is the context that the channel will be sent to.<br>

* `arg2` - If the type is 'app', then this is the data passed as arguments to the application. If the type is 'exten', then this is the extension that the channel will be sent to.<br>

* `arg3` - If the type is 'exten', then this is the priority that the channel is sent to. If the type is 'app', then this parameter is ignored.<br>

* `timeout` - Timeout in seconds. Default is 30 seconds.<br>

* `options`

    * `a` - Originate asynchronously. In other words, continue in the dialplan without waiting for the originated channel to answer.<br>


    * `b(context^exten^priority)` - Before originating the outgoing call, Gosub to the specified location using the newly created channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `B(context^exten^priority)` - Before originating the outgoing call, Gosub to the specified location using the current channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `C` - Comma-separated list of codecs to use for this call. Default is 'slin'.<br>


    * `c` - The caller ID number to use for the called channel. Default is the current channel's Caller ID number.<br>


    * `n` - The caller ID name to use for the called channel. Default is the current channel's Caller ID name.<br>


    * `v(var1)` - A series of channel variables to set on the destination channel.<br>

        * `var1[^var1...]`

            * `name` **required**

            * `value` **required**



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 