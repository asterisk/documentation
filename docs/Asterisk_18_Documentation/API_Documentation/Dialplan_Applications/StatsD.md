---
search:
  boost: 0.5
title: StatsD
---

# StatsD()

### Synopsis

Allow statistics to be passed to the StatsD server from the dialplan.

### Description

This dialplan application sends statistics to the StatsD server specified inside of 'statsd.conf'.<br>


### Syntax


```

StatsD(metric_type,statistic_name,value,[sample_rate])
```
##### Arguments


* `metric_type` - The metric type to be sent to StatsD. Valid metric types are 'g' for gauge, 'c' for counter, 'ms' for timer, and 's' for sets.<br>

* `statistic_name` - The name of the variable to be sent to StatsD. Statistic names cannot contain the pipe (|) character.<br>

* `value` - The value of the variable to be sent to StatsD. Values must be numeric. Values for gauge and counter metrics can be sent with a '+' or '-' to update a value after the value has been initialized. Only counters can be initialized as negative. Sets can send a string as the value parameter, but the string cannot contain the pipe character.<br>

* `sample_rate` - The value of the sample rate to be sent to StatsD. Sample rates less than or equal to 0 will never be sent and sample rates greater than or equal to 1 will always be sent. Any rate between 1 and 0 will be compared to a randomly generated value, and if it is greater than the random value, it will be sent.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 