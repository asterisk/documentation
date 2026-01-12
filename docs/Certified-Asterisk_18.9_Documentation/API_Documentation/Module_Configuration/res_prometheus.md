---
search:
  boost: 0.5
title: res_prometheus
---

# res_prometheus: Resource for integration with Prometheus

This configuration documentation is for functionality provided by res_prometheus.

## Configuration File: prometheus.conf

### [general]: General settings.

The *general* settings section contains information to configure Asterisk to serve up statistics for a Prometheus server.<br>


/// note
You must enable Asterisk's HTTP server in *http.conf* for this module to function properly!
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [auth_password](#auth_password)| String| | false| Password to use for Basic Auth.| |
| auth_realm| String| Asterisk Prometheus Metrics| false| Auth realm used in challenge responses| |
| [auth_username](#auth_username)| String| | false| Username to use for Basic Auth.| |
| [core_metrics_enabled](#core_metrics_enabled)| Boolean| yes| false| Enable or disable core metrics.| |
| [enabled](#enabled)| Boolean| no| false| Enable or disable Prometheus statistics.| |
| uri| String| | false| The HTTP URI to serve metrics up on.| |


#### Configuration Option Descriptions

##### auth_password

If set, this is used in conjunction with _auth\_username_ to require Basic Auth for all requests to the Prometheus metrics. Note that setting this without _auth\_username_ will not do anything.<br>


##### auth_username

If set, use Basic Auth to authenticate requests to the route specified by _uri_. Note that you will need to configure your Prometheus server with the appropriate auth credentials.<br>

If set, _auth\_password_ must also be set appropriately.<br>


/// warning
It is highly recommended to set up Basic Auth. Failure to do so may result in useful information about your Asterisk system being made easily scrapable by the wide world. Consider yourself duly warned.
///


##### core_metrics_enabled

Core metrics show various properties of the Asterisk system, including how the binary was built, the version, uptime, last reload time, etc. Generally, these options are harmless and should always be enabled. This option mostly exists to disable output of all options for testing purposes, as well as for those foolish souls who really don't care what version of Asterisk they're running.<br>


* `no`

* `yes`

##### enabled


* `no`

* `yes`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 