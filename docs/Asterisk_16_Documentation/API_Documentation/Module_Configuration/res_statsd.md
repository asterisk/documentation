---
search:
  boost: 0.5
title: res_statsd
---

# res_statsd: StatsD client

This configuration documentation is for functionality provided by res_statsd.

## Overview

The 'res\_statsd' module provides an API that allows Asterisk and its modules to send statistics to a StatsD server. It only provides a means to communicate with a StatsD server and does not send any metrics of its own.<br>

An example module, 'res\_chan\_stats', is provided which uses the API exposed by this module to send channel statistics to the configured StatsD server.<br>

More information about StatsD can be found at https://github.com/statsd/statsd<br>


## Configuration File: statsd.conf

### [global]: Global configuration settings

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| add_newline| Boolean| no| false| Append a newline to every event. This is useful if you want to fake out a server using netcat (nc -lu 8125)| |
| enabled| Boolean| no| false| Enable/disable the StatsD module| |
| meter_support| Boolean| yes| false| Enable/disable the non-standard StatsD Meter type, if disabled falls back to counter and will append a "_meter" suffix to the metric name| |
| prefix| String| | false| Prefix to prepend to every metric| |
| server| IP Address| 127.0.0.1| false| Address of the StatsD server| |



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 