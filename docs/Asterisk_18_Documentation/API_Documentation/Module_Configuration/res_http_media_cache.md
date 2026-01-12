---
search:
  boost: 0.5
title: res_http_media_cache
---

# res_http_media_cache: HTTP media cache

This configuration documentation is for functionality provided by res_http_media_cache.

## Configuration File: http_media_cache.conf

### [general]: General configuration

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| dns_cache_timeout_secs| Integer| 60| false| The life-time for DNS cache entries. See https://curl.se/libcurl/c/CURLOPT_DNS_CACHE_TIMEOUT.html for details.| |
| follow_location| Boolean| yes| false| Follow HTTP 3xx redirects on requests. See https://curl.se/libcurl/c/CURLOPT_FOLLOWLOCATION.html for details.| |
| max_redirects| Integer| 8| false| The maximum number of redirects to follow. See https://curl.se/libcurl/c/CURLOPT_MAXREDIRS.html for details.| |
| protocols| String| | false| The comma separated list of allowed protocols for the request. Available with cURL 7.85.0 or later. See https://curl.se/libcurl/c/CURLOPT_PROTOCOLS_STR.html for details.| |
| proxy| String| | false| The proxy to use for requests. See https://curl.se/libcurl/c/CURLOPT_PROXY.html for details.| |
| redirect_protocols| String| | false| The comma separated list of allowed protocols for redirects. Available with cURL 7.85.0 or later. See https://curl.se/libcurl/c/CURLOPT_REDIR_PROTOCOLS_STR.html for details.| |
| timeout_secs| Integer| 180| false| The maximum time the transfer is allowed to complete in seconds. See https://curl.se/libcurl/c/CURLOPT_TIMEOUT.html for details.| |
| user_agent| String| asterisk-libcurl-agent/1.0| false| The HTTP User-Agent to use for requests. See https://curl.se/libcurl/c/CURLOPT_USERAGENT.html for details.| |



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 