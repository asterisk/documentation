---
search:
  boost: 0.5
title: Login
---

# Login

### Synopsis

Login Manager.

### Description

Login Manager.<br>

``` title="Example: Create an MD5 Key in Python"

import hashlib
m = hashlib.md5()
m.update(response_from_challenge)
m.update(your_secret)
key = m.hexdigest()
## '031edd7d41651593c5fe5c006fa5752b'


```

### Syntax


```


    Action: Login
    ActionID: <value>
    Username: <value>
    AuthType: <value>
    Secret: <value>
    Key: <value>
    Events: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Username` - Username to login with as specified in manager.conf.<br>

* `AuthType` - Authorization type. Valid values are:<br>

    * `plain` - Plain text secret. (default)<br>

    * `MD5` - MD5 hashed secret.<br>

* `Secret` - Plain text secret to login with as specified in manager.conf.<br>

* `Key` - Key to use with MD5 authentication. To create the key, you must initialize a new MD5 hash, call the 'Challenge' AMI action, update the hash with the response, then update the hash with the secret as specified in manager.conf. The key value must be the final result of the hash as a 32 character lower-case hex string without any "0x" prepended. See the description for an example of creating a key in Python.<br>

* `Events`

    * `on` - If all events should be sent.<br>

    * `off` - If no events should be sent.<br>

    * `system,call,log,...` - To select which flags events should have to be sent.<br>

### See Also

* [AMI Actions Challenge](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Challenge)
* [AMI Actions Logoff](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Logoff)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 