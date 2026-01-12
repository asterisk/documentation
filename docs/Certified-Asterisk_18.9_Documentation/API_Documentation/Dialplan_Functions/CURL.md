---
search:
  boost: 0.5
title: CURL
---

# CURL()

### Synopsis

Retrieve content from a remote web or ftp server

### Description

When this function is read, a 'HTTP GET' (by default) will be used to retrieve the contents of the provided _url_. The contents are returned as the result of the function.<br>

``` title="Example: Displaying contents of a page"

exten => s,1,Verbose(0, ${CURL(http://localhost:8088/static/astman.css)})


```
When this function is written to, a 'HTTP GET' will be used to retrieve the contents of the provided _url_. The value written to the function specifies the destination file of the cURL'd resource.<br>

``` title="Example: Retrieving a file"

exten => s,1,Set(CURL(http://localhost:8088/static/astman.css)=/var/spool/asterisk/tmp/astman.css))


```

/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be written to from the dialplan, and not directly from external protocols. Read operations are unaffected.
///


### Syntax


```

CURL(url,post-data)
```
##### Arguments


* `url` - The full URL for the resource to retrieve.<br>

* `post-data` - Read Only<br>
If specified, an 'HTTP POST' will be performed with the content of _post-data_, instead of an 'HTTP GET' (default).<br>

### See Also

* [Dialplan Functions CURLOPT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CURLOPT)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 