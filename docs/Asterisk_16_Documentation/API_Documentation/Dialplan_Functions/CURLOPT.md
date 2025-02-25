---
search:
  boost: 0.5
title: CURLOPT
---

# CURLOPT()

### Synopsis

Sets various options for future invocations of CURL.

### Description

Options may be set globally or per channel. Per-channel settings will override global settings. Only HTTP headers are added instead of overriding<br>


### Syntax


```

CURLOPT(key)
```
##### Arguments


* `key`

    * `cookie` - A cookie to send with the request. Multiple cookies are supported.<br>

    * `conntimeout` - Number of seconds to wait for a connection to succeed<br>

    * `dnstimeout` - Number of seconds to wait for DNS to be resolved<br>

    * `followlocation` - Whether or not to follow HTTP 3xx redirects (boolean)<br>

    * `ftptext` - For FTP URIs, force a text transfer (boolean)<br>

    * `ftptimeout` - For FTP URIs, number of seconds to wait for a server response<br>

    * `header` - Include header information in the result (boolean)<br>

    * `httpheader` - Add HTTP header. Multiple calls add multiple headers. Setting of any header will remove the default "Content-Type application/x-www-form-urlencoded"<br>

    * `httptimeout` - For HTTP(S) URIs, number of seconds to wait for a server response<br>

    * `maxredirs` - Maximum number of redirects to follow. The default is -1, which allows for unlimited redirects. This only makes sense when followlocation is also set.<br>

    * `proxy` - Hostname or IP address to use as a proxy server<br>

    * `proxytype` - Type of 'proxy'<br>

        * `http`

        * `socks4`

        * `socks5`

    * `proxyport` - Port number of the 'proxy'<br>

    * `proxyuserpwd` - A _username_':'_password_ combination to use for authenticating requests through a 'proxy'<br>

    * `referer` - Referer URL to use for the request<br>

    * `useragent` - UserAgent string to use for the request<br>

    * `userpwd` - A _username_':'_password_ to use for authentication when the server response to an initial request indicates a 401 status code.<br>

    * `ssl_verifypeer` - Whether to verify the server certificate against a list of known root certificate authorities (boolean).<br>

    * `hashcompat` - Assuming the responses will be in 'key1=value1&key2=value2' format, reformat the response such that it can be used by the 'HASH' function.<br>

        * `yes`

        * `no`

        * `legacy` - Also translate '+' to the space character, in violation of current RFC standards.<br>

    * `failurecodes` - A comma separated list of HTTP response codes to be treated as errors<br>

### See Also

* [Dialplan Functions CURL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CURL)
* [Dialplan Functions HASH](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/HASH)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 