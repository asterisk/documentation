---
search:
  boost: 0.5
title: SendURL
---

# SendURL()

### Synopsis

Send a URL.

### Description

Requests client go to _URL_ (IAX2) or sends the URL to the client (other channels).<br>

Result is returned in the **SENDURLSTATUS** channel variable:<br>


* `SENDURLSTATUS`

    * `SUCCESS` - URL successfully sent to client.

    * `FAILURE` - Failed to send URL.

    * `NOLOAD` - Client failed to load URL (wait enabled).

    * `UNSUPPORTED` - Channel does not support URL transport.
SendURL continues normally if the URL was sent correctly or if the channel does not support HTML transport. Otherwise, the channel is hung up.<br>


### Syntax


```

SendURL(URL,[option])
```
##### Arguments


* `URL`

* `option`

    * `w` - Execution will wait for an acknowledgement that the URL has been loaded before continuing.<br>


### See Also

* [Dialplan Applications SendImage](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SendImage)
* [Dialplan Applications SendText](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SendText)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 