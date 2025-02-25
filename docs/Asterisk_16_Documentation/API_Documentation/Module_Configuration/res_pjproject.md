---
search:
  boost: 0.5
title: res_pjproject
---

# res_pjproject: pjproject common configuration

This configuration documentation is for functionality provided by res_pjproject.

## Configuration File: pjproject.conf

### [startup]: Asterisk startup time options for PJPROJECT


/// note
The id of this object, as well as its type, must be 'startup' or it won't be found.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [log_level](#log_level)| | 2| | Initial maximum pjproject logging level to log.| |
| type| | | | Must be of type 'startup'.| |


#### Configuration Option Descriptions

##### log_level

Valid values are: 0-6, and default<br>


/// note
This option is needed very early in the startup process so it can only be read from config files because the modules for other methods have not been loaded yet.
///


### [log_mappings]: PJPROJECT to Asterisk Log Level Mapping

Warnings and errors in the pjproject libraries are generally handled by Asterisk. In many cases, Asterisk wouldn't even consider them to be warnings or errors so the messages emitted by pjproject directly are either superfluous or misleading. The 'log\_mappings' object allows mapping the pjproject levels to Asterisk levels, or nothing.<br>


/// note
The id of this object, as well as its type, must be 'log\_mappings' or it won't be found.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| asterisk_debug| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_DEBUG.| |
| asterisk_error| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_ERROR.| |
| asterisk_notice| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_NOTICE.| |
| asterisk_trace| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_TRACE.| |
| asterisk_verbose| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_VERBOSE.| |
| asterisk_warning| String| | false| A comma separated list of pjproject log levels to map to Asterisk LOG_WARNING.| |
| type| None| | false| Must be of type 'log_mappings'.| |



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 