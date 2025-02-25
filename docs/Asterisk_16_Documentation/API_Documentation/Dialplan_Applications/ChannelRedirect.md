---
search:
  boost: 0.5
title: ChannelRedirect
---

# ChannelRedirect()

### Synopsis

Redirects given channel to a dialplan target

### Description

Sends the specified channel to the specified extension priority<br>

This application sets the following channel variables upon completion<br>


* `CHANNELREDIRECT_STATUS` - Are set to the result of the redirection<br>

    * `NOCHANNEL`

    * `SUCCESS`

### Syntax


```

ChannelRedirect(channel,[context,[extension,]]priority)
```
##### Arguments


* `channel`

* `context`

* `extension`

* `priority`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 