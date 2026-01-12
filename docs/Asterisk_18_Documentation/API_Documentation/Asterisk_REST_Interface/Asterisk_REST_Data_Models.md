---
title: Asterisk REST Data Models
---
# Asterisk REST Data Models
## AsteriskInfo


### Model
``` javascript title="AsteriskInfo" linenums="1"
{
  "id": "AsteriskInfo",
  "description": "Asterisk system information",
  "properties": {
    "build": {
      "required": false,
      "type": "BuildInfo",
      "description": "Info about how Asterisk was built"
    },
    "system": {
      "required": false,
      "type": "SystemInfo",
      "description": "Info about the system running Asterisk"
    },
    "config": {
      "required": false,
      "type": "ConfigInfo",
      "description": "Info about Asterisk configuration"
    },
    "status": {
      "required": false,
      "type": "StatusInfo",
      "description": "Info about Asterisk status"
    }
  }
}
```
### Properties
* build: [BuildInfo|#BuildInfo] _(optional)_ - Info about how Asterisk was built
* config: [ConfigInfo|#ConfigInfo] _(optional)_ - Info about Asterisk configuration
* status: [StatusInfo|#StatusInfo] _(optional)_ - Info about Asterisk status
* system: [SystemInfo|#SystemInfo] _(optional)_ - Info about the system running Asterisk

## AsteriskPing


### Model
``` javascript title="AsteriskPing" linenums="1"
{
  "id": "AsteriskPing",
  "description": "Asterisk ping information",
  "properties": {
    "asterisk_id": {
      "required": true,
      "type": "string",
      "description": "Asterisk id info"
    },
    "ping": {
      "required": true,
      "type": "string",
      "description": "Always string value is pong"
    },
    "timestamp": {
      "required": true,
      "type": "string",
      "description": "The timestamp string of request received time"
    }
  }
}
```
### Properties
* asterisk_id: string - Asterisk id info
* ping: string - Always string value is pong
* timestamp: string - The timestamp string of request received time

## BuildInfo


### Model
``` javascript title="BuildInfo" linenums="1"
{
  "id": "BuildInfo",
  "description": "Info about how Asterisk was built",
  "properties": {
    "os": {
      "required": true,
      "type": "string",
      "description": "OS Asterisk was built on."
    },
    "kernel": {
      "required": true,
      "type": "string",
      "description": "Kernel version Asterisk was built on."
    },
    "options": {
      "required": true,
      "type": "string",
      "description": "Compile time options, or empty string if default."
    },
    "machine": {
      "required": true,
      "type": "string",
      "description": "Machine architecture (x86_64, i686, ppc, etc.)"
    },
    "date": {
      "required": true,
      "type": "string",
      "description": "Date and time when Asterisk was built."
    },
    "user": {
      "required": true,
      "type": "string",
      "description": "Username that build Asterisk"
    }
  }
}
```
### Properties
* date: string - Date and time when Asterisk was built.
* kernel: string - Kernel version Asterisk was built on.
* machine: string - Machine architecture (x86_64, i686, ppc, etc.)
* options: string - Compile time options, or empty string if default.
* os: string - OS Asterisk was built on.
* user: string - Username that build Asterisk

## ConfigInfo


### Model
``` javascript title="ConfigInfo" linenums="1"
{
  "id": "ConfigInfo",
  "description": "Info about Asterisk configuration",
  "properties": {
    "name": {
      "required": true,
      "type": "string",
      "description": "Asterisk system name."
    },
    "default_language": {
      "required": true,
      "type": "string",
      "description": "Default language for media playback."
    },
    "max_channels": {
      "required": false,
      "type": "int",
      "description": "Maximum number of simultaneous channels."
    },
    "max_open_files": {
      "required": false,
      "type": "int",
      "description": "Maximum number of open file handles (files, sockets)."
    },
    "max_load": {
      "required": false,
      "type": "double",
      "description": "Maximum load avg on system."
    },
    "setid": {
      "required": true,
      "type": "SetId",
      "description": "Effective user/group id for running Asterisk."
    }
  }
}
```
### Properties
* default_language: string - Default language for media playback.
* max_channels: int _(optional)_ - Maximum number of simultaneous channels.
* max_load: double _(optional)_ - Maximum load avg on system.
* max_open_files: int _(optional)_ - Maximum number of open file handles (files, sockets).
* name: string - Asterisk system name.
* setid: [SetId|#SetId] - Effective user/group id for running Asterisk.

## ConfigTuple


### Model
``` javascript title="ConfigTuple" linenums="1"
{
  "id": "ConfigTuple",
  "description": "A key/value pair that makes up part of a configuration object.",
  "properties": {
    "attribute": {
      "required": true,
      "type": "string",
      "description": "A configuration object attribute."
    },
    "value": {
      "required": true,
      "type": "string",
      "description": "The value for the attribute."
    }
  }
}
```
### Properties
* attribute: string - A configuration object attribute.
* value: string - The value for the attribute.

## LogChannel


### Model
``` javascript title="LogChannel" linenums="1"
{
  "id": "LogChannel",
  "description": "Details of an Asterisk log channel",
  "properties": {
    "channel": {
      "type": "string",
      "description": "The log channel path",
      "required": true
    },
    "type": {
      "type": "string",
      "description": "Types of logs for the log channel",
      "required": true
    },
    "status": {
      "type": "string",
      "description": "Whether or not a log type is enabled",
      "required": true
    },
    "configuration": {
      "type": "string",
      "description": "The various log levels",
      "required": true
    }
  }
}
```
### Properties
* channel: string - The log channel path
* configuration: string - The various log levels
* status: string - Whether or not a log type is enabled
* type: string - Types of logs for the log channel

## Module


### Model
``` javascript title="Module" linenums="1"
{
  "id": "Module",
  "description": "Details of an Asterisk module",
  "properties": {
    "name": {
      "type": "string",
      "description": "The name of this module",
      "required": true
    },
    "description": {
      "type": "string",
      "description": "The description of this module",
      "required": true
    },
    "use_count": {
      "type": "int",
      "description": "The number of times this module is being used",
      "required": true
    },
    "status": {
      "type": "string",
      "description": "The running status of this module",
      "required": true
    },
    "support_level": {
      "type": "string",
      "description": "The support state of this module",
      "required": true
    }
  }
}
```
### Properties
* description: string - The description of this module
* name: string - The name of this module
* status: string - The running status of this module
* support_level: string - The support state of this module
* use_count: int - The number of times this module is being used

## SetId


### Model
``` javascript title="SetId" linenums="1"
{
  "id": "SetId",
  "description": "Effective user/group id",
  "properties": {
    "user": {
      "required": true,
      "type": "string",
      "description": "Effective user id."
    },
    "group": {
      "required": true,
      "type": "string",
      "description": "Effective group id."
    }
  }
}
```
### Properties
* group: string - Effective group id.
* user: string - Effective user id.

## StatusInfo


### Model
``` javascript title="StatusInfo" linenums="1"
{
  "id": "StatusInfo",
  "description": "Info about Asterisk status",
  "properties": {
    "startup_time": {
      "required": true,
      "type": "Date",
      "description": "Time when Asterisk was started."
    },
    "last_reload_time": {
      "required": true,
      "type": "Date",
      "description": "Time when Asterisk was last reloaded."
    }
  }
}
```
### Properties
* last_reload_time: Date - Time when Asterisk was last reloaded.
* startup_time: Date - Time when Asterisk was started.

## SystemInfo


### Model
``` javascript title="SystemInfo" linenums="1"
{
  "id": "SystemInfo",
  "description": "Info about Asterisk",
  "properties": {
    "version": {
      "required": true,
      "type": "string",
      "description": "Asterisk version."
    },
    "entity_id": {
      "required": true,
      "type": "string",
      "description": ""
    }
  }
}
```
### Properties
* entity_id: string
* version: string - Asterisk version.

## Variable


### Model
``` javascript title="Variable" linenums="1"
{
  "id": "Variable",
  "description": "The value of a channel variable",
  "properties": {
    "value": {
      "required": true,
      "type": "string",
      "description": "The value of the variable requested"
    }
  }
}
```
### Properties
* value: string - The value of the variable requested

## Endpoint


### Model
``` javascript title="Endpoint" linenums="1"
{
  "id": "Endpoint",
  "description": "An external device that may offer/accept calls to/from Asterisk.\n\nUnlike most resources, which have a single unique identifier, an endpoint is uniquely identified by the technology/resource pair.",
  "properties": {
    "technology": {
      "type": "string",
      "description": "Technology of the endpoint",
      "required": true
    },
    "resource": {
      "type": "string",
      "description": "Identifier of the endpoint, specific to the given technology.",
      "required": true
    },
    "state": {
      "type": "string",
      "description": "Endpoint's state",
      "required": false,
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "unknown",
          "offline",
          "online"
        ]
      }
    },
    "channel_ids": {
      "type": "List[string]",
      "description": "Id's of channels associated with this endpoint",
      "required": true
    }
  }
}
```
### Properties
* channel_ids: List\[string\] - Id's of channels associated with this endpoint
* resource: string - Identifier of the endpoint, specific to the given technology.
* state: string _(optional)_ - Endpoint's state
* technology: string - Technology of the endpoint

## TextMessage


### Model
``` javascript title="TextMessage" linenums="1"
{
  "id": "TextMessage",
  "description": "A text message.",
  "properties": {
    "from": {
      "type": "string",
      "description": "A technology specific URI specifying the source of the message. For sip and pjsip technologies, any SIP URI can be specified. For xmpp, the URI must correspond to the client connection being used to send the message.",
      "required": true
    },
    "to": {
      "type": "string",
      "description": "A technology specific URI specifying the destination of the message. Valid technologies include sip, pjsip, and xmp. The destination of a message should be an endpoint.",
      "required": true
    },
    "body": {
      "type": "string",
      "description": "The text of the message.",
      "required": true
    },
    "variables": {
      "type": "object",
      "description": "Technology specific key/value pairs (JSON object) associated with the message.",
      "required": false
    }
  }
}
```
### Properties
* body: string - The text of the message.
* from: string - A technology specific URI specifying the source of the message. For sip and pjsip technologies, any SIP URI can be specified. For xmpp, the URI must correspond to the client connection being used to send the message.
* to: string - A technology specific URI specifying the destination of the message. Valid technologies include sip, pjsip, and xmp. The destination of a message should be an endpoint.
* variables: [object|#object] _(optional)_ - Technology specific key/value pairs (JSON object) associated with the message.

## CallerID


### Model
``` javascript title="CallerID" linenums="1"
{
  "id": "CallerID",
  "description": "Caller identification",
  "properties": {
    "name": {
      "required": true,
      "type": "string"
    },
    "number": {
      "required": true,
      "type": "string"
    }
  }
}
```
### Properties
* name: string
* number: string

## Channel


### Model
``` javascript title="Channel" linenums="1"
{
  "id": "Channel",
  "description": "A specific communication connection between Asterisk and an Endpoint.",
  "properties": {
    "id": {
      "required": true,
      "type": "string",
      "description": "Unique identifier of the channel.\n\nThis is the same as the Uniqueid field in AMI."
    },
    "protocol_id": {
      "required": true,
      "type": "string",
      "description": "Protocol id from underlying channel driver (i.e. Call-ID for chan_sip/chan_pjsip; will be empty if not applicable or not implemented by driver)."
    },
    "name": {
      "required": true,
      "type": "string",
      "description": "Name of the channel (i.e. SIP/foo-0000a7e3)"
    },
    "state": {
      "required": true,
      "type": "string",
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "Down",
          "Rsrved",
          "OffHook",
          "Dialing",
          "Ring",
          "Ringing",
          "Up",
          "Busy",
          "Dialing Offhook",
          "Pre-ring",
          "Unknown"
        ]
      }
    },
    "caller": {
      "required": true,
      "type": "CallerID"
    },
    "connected": {
      "required": true,
      "type": "CallerID"
    },
    "accountcode": {
      "required": true,
      "type": "string"
    },
    "dialplan": {
      "required": true,
      "type": "DialplanCEP",
      "description": "Current location in the dialplan"
    },
    "creationtime": {
      "required": true,
      "type": "Date",
      "description": "Timestamp when channel was created"
    },
    "language": {
      "required": true,
      "type": "string",
      "description": "The default spoken language"
    },
    "channelvars": {
      "required": false,
      "type": "object",
      "description": "Channel variables"
    },
    "caller_rdnis": {
      "type": "string",
      "description": "The Caller ID RDNIS"
    },
    "tenantid": {
      "required": false,
      "type": "string",
      "description": "The Tenant ID for the channel"
    }
  }
}
```
### Properties
* accountcode: string
* caller: [CallerID|#CallerID]
* caller_rdnis: string _(optional)_ - The Caller ID RDNIS
* channelvars: [object|#object] _(optional)_ - Channel variables
* connected: [CallerID|#CallerID]
* creationtime: Date - Timestamp when channel was created
* dialplan: [DialplanCEP|#DialplanCEP] - Current location in the dialplan
* id: string - Unique identifier of the channel.

This is the same as the Uniqueid field in AMI.
* language: string - The default spoken language
* name: string - Name of the channel (i.e. SIP/foo-0000a7e3)
* protocol_id: string - Protocol id from underlying channel driver (i.e. Call-ID for chan_sip/chan_pjsip; will be empty if not applicable or not implemented by driver).
* state: string
* tenantid: string _(optional)_ - The Tenant ID for the channel

## Dialed


### Model
``` javascript title="Dialed" linenums="1"
{
  "id": "Dialed",
  "description": "Dialed channel information.",
  "properties": {}
}
```
### Properties

## DialplanCEP


### Model
``` javascript title="DialplanCEP" linenums="1"
{
  "id": "DialplanCEP",
  "description": "Dialplan location (context/extension/priority)",
  "properties": {
    "context": {
      "required": true,
      "type": "string",
      "description": "Context in the dialplan"
    },
    "exten": {
      "required": true,
      "type": "string",
      "description": "Extension in the dialplan"
    },
    "priority": {
      "required": true,
      "type": "long",
      "description": "Priority in the dialplan"
    },
    "app_name": {
      "required": true,
      "type": "string",
      "description": "Name of current dialplan application"
    },
    "app_data": {
      "required": true,
      "type": "string",
      "description": "Parameter of current dialplan application"
    }
  }
}
```
### Properties
* app_data: string - Parameter of current dialplan application
* app_name: string - Name of current dialplan application
* context: string - Context in the dialplan
* exten: string - Extension in the dialplan
* priority: long - Priority in the dialplan

## RTPstat


### Model
``` javascript title="RTPstat" linenums="1"
{
  "id": "RTPstat",
  "description": "A statistics of a RTP.",
  "properties": {
    "txcount": {
      "required": true,
      "type": "int",
      "description": "Number of packets transmitted."
    },
    "rxcount": {
      "required": true,
      "type": "int",
      "description": "Number of packets received."
    },
    "txjitter": {
      "required": false,
      "type": "double",
      "description": "Jitter on transmitted packets."
    },
    "rxjitter": {
      "required": false,
      "type": "double",
      "description": "Jitter on received packets."
    },
    "remote_maxjitter": {
      "required": false,
      "type": "double",
      "description": "Maximum jitter on remote side."
    },
    "remote_minjitter": {
      "required": false,
      "type": "double",
      "description": "Minimum jitter on remote side."
    },
    "remote_normdevjitter": {
      "required": false,
      "type": "double",
      "description": "Average jitter on remote side."
    },
    "remote_stdevjitter": {
      "required": false,
      "type": "double",
      "description": "Standard deviation jitter on remote side."
    },
    "local_maxjitter": {
      "required": false,
      "type": "double",
      "description": "Maximum jitter on local side."
    },
    "local_minjitter": {
      "required": false,
      "type": "double",
      "description": "Minimum jitter on local side."
    },
    "local_normdevjitter": {
      "required": false,
      "type": "double",
      "description": "Average jitter on local side."
    },
    "local_stdevjitter": {
      "required": false,
      "type": "double",
      "description": "Standard deviation jitter on local side."
    },
    "txploss": {
      "required": true,
      "type": "int",
      "description": "Number of transmitted packets lost."
    },
    "rxploss": {
      "required": true,
      "type": "int",
      "description": "Number of received packets lost."
    },
    "remote_maxrxploss": {
      "required": false,
      "type": "double",
      "description": "Maximum number of packets lost on remote side."
    },
    "remote_minrxploss": {
      "required": false,
      "type": "double",
      "description": "Minimum number of packets lost on remote side."
    },
    "remote_normdevrxploss": {
      "required": false,
      "type": "double",
      "description": "Average number of packets lost on remote side."
    },
    "remote_stdevrxploss": {
      "required": false,
      "type": "double",
      "description": "Standard deviation packets lost on remote side."
    },
    "local_maxrxploss": {
      "required": false,
      "type": "double",
      "description": "Maximum number of packets lost on local side."
    },
    "local_minrxploss": {
      "required": false,
      "type": "double",
      "description": "Minimum number of packets lost on local side."
    },
    "local_normdevrxploss": {
      "required": false,
      "type": "double",
      "description": "Average number of packets lost on local side."
    },
    "local_stdevrxploss": {
      "required": false,
      "type": "double",
      "description": "Standard deviation packets lost on local side."
    },
    "rtt": {
      "required": false,
      "type": "double",
      "description": "Total round trip time."
    },
    "maxrtt": {
      "required": false,
      "type": "double",
      "description": "Maximum round trip time."
    },
    "minrtt": {
      "required": false,
      "type": "double",
      "description": "Minimum round trip time."
    },
    "normdevrtt": {
      "required": false,
      "type": "double",
      "description": "Average round trip time."
    },
    "stdevrtt": {
      "required": false,
      "type": "double",
      "description": "Standard deviation round trip time."
    },
    "local_ssrc": {
      "required": true,
      "type": "int",
      "description": "Our SSRC."
    },
    "remote_ssrc": {
      "required": true,
      "type": "int",
      "description": "Their SSRC."
    },
    "txoctetcount": {
      "required": true,
      "type": "int",
      "description": "Number of octets transmitted."
    },
    "rxoctetcount": {
      "required": true,
      "type": "int",
      "description": "Number of octets received."
    },
    "channel_uniqueid": {
      "required": true,
      "type": "string",
      "description": "The Asterisk channel's unique ID that owns this instance."
    }
  }
}
```
### Properties
* channel_uniqueid: string - The Asterisk channel's unique ID that owns this instance.
* local_maxjitter: double _(optional)_ - Maximum jitter on local side.
* local_maxrxploss: double _(optional)_ - Maximum number of packets lost on local side.
* local_minjitter: double _(optional)_ - Minimum jitter on local side.
* local_minrxploss: double _(optional)_ - Minimum number of packets lost on local side.
* local_normdevjitter: double _(optional)_ - Average jitter on local side.
* local_normdevrxploss: double _(optional)_ - Average number of packets lost on local side.
* local_ssrc: int - Our SSRC.
* local_stdevjitter: double _(optional)_ - Standard deviation jitter on local side.
* local_stdevrxploss: double _(optional)_ - Standard deviation packets lost on local side.
* maxrtt: double _(optional)_ - Maximum round trip time.
* minrtt: double _(optional)_ - Minimum round trip time.
* normdevrtt: double _(optional)_ - Average round trip time.
* remote_maxjitter: double _(optional)_ - Maximum jitter on remote side.
* remote_maxrxploss: double _(optional)_ - Maximum number of packets lost on remote side.
* remote_minjitter: double _(optional)_ - Minimum jitter on remote side.
* remote_minrxploss: double _(optional)_ - Minimum number of packets lost on remote side.
* remote_normdevjitter: double _(optional)_ - Average jitter on remote side.
* remote_normdevrxploss: double _(optional)_ - Average number of packets lost on remote side.
* remote_ssrc: int - Their SSRC.
* remote_stdevjitter: double _(optional)_ - Standard deviation jitter on remote side.
* remote_stdevrxploss: double _(optional)_ - Standard deviation packets lost on remote side.
* rtt: double _(optional)_ - Total round trip time.
* rxcount: int - Number of packets received.
* rxjitter: double _(optional)_ - Jitter on received packets.
* rxoctetcount: int - Number of octets received.
* rxploss: int - Number of received packets lost.
* stdevrtt: double _(optional)_ - Standard deviation round trip time.
* txcount: int - Number of packets transmitted.
* txjitter: double _(optional)_ - Jitter on transmitted packets.
* txoctetcount: int - Number of octets transmitted.
* txploss: int - Number of transmitted packets lost.

## Bridge


### Model
``` javascript title="Bridge" linenums="1"
{
  "id": "Bridge",
  "description": "The merging of media from one or more channels.\n\nEveryone on the bridge receives the same audio.",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier for this bridge",
      "required": true
    },
    "technology": {
      "type": "string",
      "description": "Name of the current bridging technology",
      "required": true
    },
    "bridge_type": {
      "type": "string",
      "description": "Type of bridge technology",
      "required": true,
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "mixing",
          "holding"
        ]
      }
    },
    "bridge_class": {
      "type": "string",
      "description": "Bridging class",
      "required": true
    },
    "creator": {
      "type": "string",
      "description": "Entity that created the bridge",
      "required": true
    },
    "name": {
      "type": "string",
      "description": "Name the creator gave the bridge",
      "required": true
    },
    "channels": {
      "type": "List[string]",
      "description": "Ids of channels participating in this bridge",
      "required": true
    },
    "video_mode": {
      "type": "string",
      "description": "The video mode the bridge is using. One of 'none', 'talker', 'sfu', or 'single'.",
      "required": false
    },
    "video_source_id": {
      "type": "string",
      "description": "The ID of the channel that is the source of video in this bridge, if one exists.",
      "required": false
    },
    "creationtime": {
      "required": true,
      "type": "Date",
      "description": "Timestamp when bridge was created"
    }
  }
}
```
### Properties
* bridge_class: string - Bridging class
* bridge_type: string - Type of bridge technology
* channels: List\[string\] - Ids of channels participating in this bridge
* creationtime: Date - Timestamp when bridge was created
* creator: string - Entity that created the bridge
* id: string - Unique identifier for this bridge
* name: string - Name the creator gave the bridge
* technology: string - Name of the current bridging technology
* video_mode: string _(optional)_ - The video mode the bridge is using. One of 'none', 'talker', 'sfu', or 'single'.
* video_source_id: string _(optional)_ - The ID of the channel that is the source of video in this bridge, if one exists.

## LiveRecording


### Model
``` javascript title="LiveRecording" linenums="1"
{
  "id": "LiveRecording",
  "description": "A recording that is in progress",
  "properties": {
    "name": {
      "required": true,
      "type": "string",
      "description": "Base name for the recording"
    },
    "format": {
      "required": true,
      "type": "string",
      "description": "Recording format (wav, gsm, etc.)"
    },
    "target_uri": {
      "required": true,
      "type": "string",
      "description": "URI for the channel or bridge being recorded"
    },
    "state": {
      "required": true,
      "type": "string",
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "queued",
          "recording",
          "paused",
          "done",
          "failed",
          "canceled"
        ]
      }
    },
    "duration": {
      "required": false,
      "type": "int",
      "description": "Duration in seconds of the recording"
    },
    "talking_duration": {
      "required": false,
      "type": "int",
      "description": "Duration of talking, in seconds, detected in the recording. This is only available if the recording was initiated with a non-zero maxSilenceSeconds."
    },
    "silence_duration": {
      "required": false,
      "type": "int",
      "description": "Duration of silence, in seconds, detected in the recording. This is only available if the recording was initiated with a non-zero maxSilenceSeconds."
    },
    "cause": {
      "required": false,
      "type": "string",
      "description": "Cause for recording failure if failed"
    }
  }
}
```
### Properties
* cause: string _(optional)_ - Cause for recording failure if failed
* duration: int _(optional)_ - Duration in seconds of the recording
* format: string - Recording format (wav, gsm, etc.)
* name: string - Base name for the recording
* silence_duration: int _(optional)_ - Duration of silence, in seconds, detected in the recording. This is only available if the recording was initiated with a non-zero maxSilenceSeconds.
* state: string
* talking_duration: int _(optional)_ - Duration of talking, in seconds, detected in the recording. This is only available if the recording was initiated with a non-zero maxSilenceSeconds.
* target_uri: string - URI for the channel or bridge being recorded

## StoredRecording


### Model
``` javascript title="StoredRecording" linenums="1"
{
  "id": "StoredRecording",
  "description": "A past recording that may be played back.",
  "properties": {
    "name": {
      "required": true,
      "type": "string"
    },
    "format": {
      "required": true,
      "type": "string"
    }
  }
}
```
### Properties
* format: string
* name: string

## FormatLangPair


### Model
``` javascript title="FormatLangPair" linenums="1"
{
  "id": "FormatLangPair",
  "description": "Identifies the format and language of a sound file",
  "properties": {
    "language": {
      "required": true,
      "type": "string"
    },
    "format": {
      "required": true,
      "type": "string"
    }
  }
}
```
### Properties
* format: string
* language: string

## Sound


### Model
``` javascript title="Sound" linenums="1"
{
  "id": "Sound",
  "description": "A media file that may be played back.",
  "properties": {
    "id": {
      "required": true,
      "description": "Sound's identifier.",
      "type": "string"
    },
    "text": {
      "required": false,
      "description": "Text description of the sound, usually the words spoken.",
      "type": "string"
    },
    "formats": {
      "required": true,
      "description": "The formats and languages in which this sound is available.",
      "type": "List[FormatLangPair]"
    }
  }
}
```
### Properties
* formats: [List\[FormatLangPair\]|#FormatLangPair] - The formats and languages in which this sound is available.
* id: string - Sound's identifier.
* text: string _(optional)_ - Text description of the sound, usually the words spoken.

## Playback


### Model
``` javascript title="Playback" linenums="1"
{
  "id": "Playback",
  "description": "Object representing the playback of media to a channel",
  "properties": {
    "id": {
      "type": "string",
      "description": "ID for this playback operation",
      "required": true
    },
    "media_uri": {
      "type": "string",
      "description": "The URI for the media currently being played back.",
      "required": true
    },
    "next_media_uri": {
      "type": "string",
      "description": "If a list of URIs is being played, the next media URI to be played back.",
      "required": false
    },
    "target_uri": {
      "type": "string",
      "description": "URI for the channel or bridge to play the media on",
      "required": true
    },
    "language": {
      "type": "string",
      "description": "For media types that support multiple languages, the language requested for playback."
    },
    "state": {
      "type": "string",
      "description": "Current state of the playback operation.",
      "required": true,
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "queued",
          "playing",
          "continuing",
          "done",
          "failed"
        ]
      }
    }
  }
}
```
### Properties
* id: string - ID for this playback operation
* language: string _(optional)_ - For media types that support multiple languages, the language requested for playback.
* media_uri: string - The URI for the media currently being played back.
* next_media_uri: string _(optional)_ - If a list of URIs is being played, the next media URI to be played back.
* state: string - Current state of the playback operation.
* target_uri: string - URI for the channel or bridge to play the media on

## DeviceState


### Model
``` javascript title="DeviceState" linenums="1"
{
  "id": "DeviceState",
  "description": "Represents the state of a device.",
  "properties": {
    "name": {
      "type": "string",
      "description": "Name of the device.",
      "required": true
    },
    "state": {
      "type": "string",
      "description": "Device's state",
      "required": true,
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "UNKNOWN",
          "NOT_INUSE",
          "INUSE",
          "BUSY",
          "INVALID",
          "UNAVAILABLE",
          "RINGING",
          "RINGINUSE",
          "ONHOLD"
        ]
      }
    }
  }
}
```
### Properties
* name: string - Name of the device.
* state: string - Device's state

## Mailbox


### Model
``` javascript title="Mailbox" linenums="1"
{
  "id": "Mailbox",
  "description": "Represents the state of a mailbox.",
  "properties": {
    "name": {
      "type": "string",
      "description": "Name of the mailbox.",
      "required": true
    },
    "old_messages": {
      "type": "int",
      "description": "Count of old messages in the mailbox.",
      "required": true
    },
    "new_messages": {
      "type": "int",
      "description": "Count of new messages in the mailbox.",
      "required": true
    }
  }
}
```
### Properties
* name: string - Name of the mailbox.
* new_messages: int - Count of new messages in the mailbox.
* old_messages: int - Count of old messages in the mailbox.

## ApplicationMoveFailed
Base type: [Event](#event)

### Model
``` javascript title="ApplicationMoveFailed" linenums="1"
{
  "id": "ApplicationMoveFailed",
  "description": "Notification that trying to move a channel to another Stasis application failed.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel"
    },
    "destination": {
      "required": true,
      "type": "string"
    },
    "args": {
      "required": true,
      "type": "List[string]",
      "description": "Arguments to the application"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* args: List\[string\] - Arguments to the application
* channel: [Channel|#Channel]
* destination: string

## ApplicationReplaced
Base type: [Event](#event)

### Model
``` javascript title="ApplicationReplaced" linenums="1"
{
  "id": "ApplicationReplaced",
  "description": "Notification that another WebSocket has taken over for an application.\n\nAn application may only be subscribed to by a single WebSocket at a time. If multiple WebSockets attempt to subscribe to the same application, the newer WebSocket wins, and the older one receives this event.",
  "properties": {}
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.

## BridgeAttendedTransfer
Base type: [Event](#event)

### Model
``` javascript title="BridgeAttendedTransfer" linenums="1"
{
  "id": "BridgeAttendedTransfer",
  "description": "Notification that an attended transfer has occurred.",
  "properties": {
    "transferer_first_leg": {
      "description": "First leg of the transferer",
      "required": true,
      "type": "Channel"
    },
    "transferer_second_leg": {
      "description": "Second leg of the transferer",
      "required": true,
      "type": "Channel"
    },
    "replace_channel": {
      "description": "The channel that is replacing transferer_first_leg in the swap",
      "required": false,
      "type": "Channel"
    },
    "transferee": {
      "description": "The channel that is being transferred",
      "required": false,
      "type": "Channel"
    },
    "transfer_target": {
      "description": "The channel that is being transferred to",
      "required": false,
      "type": "Channel"
    },
    "result": {
      "description": "The result of the transfer attempt",
      "required": true,
      "type": "string"
    },
    "is_external": {
      "description": "Whether the transfer was externally initiated or not",
      "required": true,
      "type": "boolean"
    },
    "transferer_first_leg_bridge": {
      "description": "Bridge the transferer first leg is in",
      "type": "Bridge"
    },
    "transferer_second_leg_bridge": {
      "description": "Bridge the transferer second leg is in",
      "type": "Bridge"
    },
    "destination_type": {
      "description": "How the transfer was accomplished",
      "required": true,
      "type": "string"
    },
    "destination_bridge": {
      "description": "Bridge that survived the merge result",
      "type": "string"
    },
    "destination_application": {
      "description": "Application that has been transferred into",
      "type": "string"
    },
    "destination_link_first_leg": {
      "description": "First leg of a link transfer result",
      "type": "Channel"
    },
    "destination_link_second_leg": {
      "description": "Second leg of a link transfer result",
      "type": "Channel"
    },
    "destination_threeway_channel": {
      "description": "Transferer channel that survived the threeway result",
      "type": "Channel"
    },
    "destination_threeway_bridge": {
      "description": "Bridge that survived the threeway result",
      "type": "Bridge"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* destination_application: string _(optional)_ - Application that has been transferred into
* destination_bridge: string _(optional)_ - Bridge that survived the merge result
* destination_link_first_leg: [Channel|#Channel] _(optional)_ - First leg of a link transfer result
* destination_link_second_leg: [Channel|#Channel] _(optional)_ - Second leg of a link transfer result
* destination_threeway_bridge: [Bridge|#Bridge] _(optional)_ - Bridge that survived the threeway result
* destination_threeway_channel: [Channel|#Channel] _(optional)_ - Transferer channel that survived the threeway result
* destination_type: string - How the transfer was accomplished
* is_external: boolean - Whether the transfer was externally initiated or not
* replace_channel: [Channel|#Channel] _(optional)_ - The channel that is replacing transferer_first_leg in the swap
* result: string - The result of the transfer attempt
* transfer_target: [Channel|#Channel] _(optional)_ - The channel that is being transferred to
* transferee: [Channel|#Channel] _(optional)_ - The channel that is being transferred
* transferer_first_leg: [Channel|#Channel] - First leg of the transferer
* transferer_first_leg_bridge: [Bridge|#Bridge] _(optional)_ - Bridge the transferer first leg is in
* transferer_second_leg: [Channel|#Channel] - Second leg of the transferer
* transferer_second_leg_bridge: [Bridge|#Bridge] _(optional)_ - Bridge the transferer second leg is in

## BridgeBlindTransfer
Base type: [Event](#event)

### Model
``` javascript title="BridgeBlindTransfer" linenums="1"
{
  "id": "BridgeBlindTransfer",
  "description": "Notification that a blind transfer has occurred.",
  "properties": {
    "channel": {
      "description": "The channel performing the blind transfer",
      "required": true,
      "type": "Channel"
    },
    "replace_channel": {
      "description": "The channel that is replacing transferer when the transferee(s) can not be transferred directly",
      "required": false,
      "type": "Channel"
    },
    "transferee": {
      "description": "The channel that is being transferred",
      "required": false,
      "type": "Channel"
    },
    "exten": {
      "description": "The extension transferred to",
      "required": true,
      "type": "string"
    },
    "context": {
      "description": "The context transferred to",
      "required": true,
      "type": "string"
    },
    "result": {
      "description": "The result of the transfer attempt",
      "required": true,
      "type": "string"
    },
    "is_external": {
      "description": "Whether the transfer was externally initiated or not",
      "required": true,
      "type": "boolean"
    },
    "bridge": {
      "description": "The bridge being transferred",
      "type": "Bridge"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge] _(optional)_ - The bridge being transferred
* channel: [Channel|#Channel] - The channel performing the blind transfer
* context: string - The context transferred to
* exten: string - The extension transferred to
* is_external: boolean - Whether the transfer was externally initiated or not
* replace_channel: [Channel|#Channel] _(optional)_ - The channel that is replacing transferer when the transferee(s) can not be transferred directly
* result: string - The result of the transfer attempt
* transferee: [Channel|#Channel] _(optional)_ - The channel that is being transferred

## BridgeCreated
Base type: [Event](#event)

### Model
``` javascript title="BridgeCreated" linenums="1"
{
  "id": "BridgeCreated",
  "description": "Notification that a bridge has been created.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]

## BridgeDestroyed
Base type: [Event](#event)

### Model
``` javascript title="BridgeDestroyed" linenums="1"
{
  "id": "BridgeDestroyed",
  "description": "Notification that a bridge has been destroyed.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]

## BridgeMerged
Base type: [Event](#event)

### Model
``` javascript title="BridgeMerged" linenums="1"
{
  "id": "BridgeMerged",
  "description": "Notification that one bridge has merged into another.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    },
    "bridge_from": {
      "required": true,
      "type": "Bridge"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]
* bridge_from: [Bridge|#Bridge]

## BridgeVideoSourceChanged
Base type: [Event](#event)

### Model
``` javascript title="BridgeVideoSourceChanged" linenums="1"
{
  "id": "BridgeVideoSourceChanged",
  "description": "Notification that the source of video in a bridge has changed.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    },
    "old_video_source_id": {
      "required": false,
      "type": "string"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]
* old_video_source_id: string _(optional)_

## ChannelCallerId
Base type: [Event](#event)

### Model
``` javascript title="ChannelCallerId" linenums="1"
{
  "id": "ChannelCallerId",
  "description": "Channel changed Caller ID.",
  "properties": {
    "caller_presentation": {
      "required": true,
      "type": "int",
      "description": "The integer representation of the Caller Presentation value."
    },
    "caller_presentation_txt": {
      "required": true,
      "type": "string",
      "description": "The text representation of the Caller Presentation value."
    },
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel that changed Caller ID."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* caller_presentation: int - The integer representation of the Caller Presentation value.
* caller_presentation_txt: string - The text representation of the Caller Presentation value.
* channel: [Channel|#Channel] - The channel that changed Caller ID.

## ChannelConnectedLine
Base type: [Event](#event)

### Model
``` javascript title="ChannelConnectedLine" linenums="1"
{
  "id": "ChannelConnectedLine",
  "description": "Channel changed Connected Line.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel whose connected line has changed."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel whose connected line has changed.

## ChannelCreated
Base type: [Event](#event)

### Model
``` javascript title="ChannelCreated" linenums="1"
{
  "id": "ChannelCreated",
  "description": "Notification that a channel has been created.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel]

## ChannelDestroyed
Base type: [Event](#event)

### Model
``` javascript title="ChannelDestroyed" linenums="1"
{
  "id": "ChannelDestroyed",
  "description": "Notification that a channel has been destroyed.",
  "properties": {
    "cause": {
      "required": true,
      "description": "Integer representation of the cause of the hangup",
      "type": "int"
    },
    "cause_txt": {
      "required": true,
      "description": "Text representation of the cause of the hangup",
      "type": "string"
    },
    "channel": {
      "required": true,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* cause: int - Integer representation of the cause of the hangup
* cause_txt: string - Text representation of the cause of the hangup
* channel: [Channel|#Channel]

## ChannelDialplan
Base type: [Event](#event)

### Model
``` javascript title="ChannelDialplan" linenums="1"
{
  "id": "ChannelDialplan",
  "description": "Channel changed location in the dialplan.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel that changed dialplan location."
    },
    "dialplan_app": {
      "required": true,
      "type": "string",
      "description": "The application about to be executed."
    },
    "dialplan_app_data": {
      "required": true,
      "type": "string",
      "description": "The data to be passed to the application."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel that changed dialplan location.
* dialplan_app: string - The application about to be executed.
* dialplan_app_data: string - The data to be passed to the application.

## ChannelDtmfReceived
Base type: [Event](#event)

### Model
``` javascript title="ChannelDtmfReceived" linenums="1"
{
  "id": "ChannelDtmfReceived",
  "description": "DTMF received on a channel.\n\nThis event is sent when the DTMF ends. There is no notification about the start of DTMF",
  "properties": {
    "digit": {
      "required": true,
      "type": "string",
      "description": "DTMF digit received (0-9, A-E, # or *)"
    },
    "duration_ms": {
      "required": true,
      "type": "int",
      "description": "Number of milliseconds DTMF was received"
    },
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel on which DTMF was received"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel on which DTMF was received
* digit: string - DTMF digit received (0-9, A-E, # or *)
* duration_ms: int - Number of milliseconds DTMF was received

## ChannelEnteredBridge
Base type: [Event](#event)

### Model
``` javascript title="ChannelEnteredBridge" linenums="1"
{
  "id": "ChannelEnteredBridge",
  "description": "Notification that a channel has entered a bridge.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    },
    "channel": {
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]
* channel: [Channel|#Channel] _(optional)_

## ChannelHangupRequest
Base type: [Event](#event)

### Model
``` javascript title="ChannelHangupRequest" linenums="1"
{
  "id": "ChannelHangupRequest",
  "description": "A hangup was requested on the channel.",
  "properties": {
    "cause": {
      "type": "int",
      "description": "Integer representation of the cause of the hangup."
    },
    "soft": {
      "type": "boolean",
      "description": "Whether the hangup request was a soft hangup request."
    },
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel on which the hangup was requested."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* cause: int _(optional)_ - Integer representation of the cause of the hangup.
* channel: [Channel|#Channel] - The channel on which the hangup was requested.
* soft: boolean _(optional)_ - Whether the hangup request was a soft hangup request.

## ChannelHold
Base type: [Event](#event)

### Model
``` javascript title="ChannelHold" linenums="1"
{
  "id": "ChannelHold",
  "description": "A channel initiated a media hold.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel that initiated the hold event."
    },
    "musicclass": {
      "required": false,
      "type": "string",
      "description": "The music on hold class that the initiator requested."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel that initiated the hold event.
* musicclass: string _(optional)_ - The music on hold class that the initiator requested.

## ChannelLeftBridge
Base type: [Event](#event)

### Model
``` javascript title="ChannelLeftBridge" linenums="1"
{
  "id": "ChannelLeftBridge",
  "description": "Notification that a channel has left a bridge.",
  "properties": {
    "bridge": {
      "required": true,
      "type": "Bridge"
    },
    "channel": {
      "required": true,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge]
* channel: [Channel|#Channel]

## ChannelStateChange
Base type: [Event](#event)

### Model
``` javascript title="ChannelStateChange" linenums="1"
{
  "id": "ChannelStateChange",
  "description": "Notification of a channel's state change.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel]

## ChannelTalkingFinished
Base type: [Event](#event)

### Model
``` javascript title="ChannelTalkingFinished" linenums="1"
{
  "id": "ChannelTalkingFinished",
  "description": "Talking is no longer detected on the channel.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel on which talking completed."
    },
    "duration": {
      "required": true,
      "type": "int",
      "description": "The length of time, in milliseconds, that talking was detected on the channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel on which talking completed.
* duration: int - The length of time, in milliseconds, that talking was detected on the channel

## ChannelTalkingStarted
Base type: [Event](#event)

### Model
``` javascript title="ChannelTalkingStarted" linenums="1"
{
  "id": "ChannelTalkingStarted",
  "description": "Talking was detected on the channel.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel on which talking started."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel on which talking started.

## ChannelUnhold
Base type: [Event](#event)

### Model
``` javascript title="ChannelUnhold" linenums="1"
{
  "id": "ChannelUnhold",
  "description": "A channel initiated a media unhold.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel",
      "description": "The channel that initiated the unhold event."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] - The channel that initiated the unhold event.

## ChannelUserevent
Base type: [Event](#event)

### Model
``` javascript title="ChannelUserevent" linenums="1"
{
  "id": "ChannelUserevent",
  "description": "User-generated event with additional user-defined fields in the object.",
  "properties": {
    "eventname": {
      "required": true,
      "type": "string",
      "description": "The name of the user event."
    },
    "channel": {
      "required": false,
      "type": "Channel",
      "description": "A channel that is signaled with the user event."
    },
    "bridge": {
      "required": false,
      "type": "Bridge",
      "description": "A bridge that is signaled with the user event."
    },
    "endpoint": {
      "required": false,
      "type": "Endpoint",
      "description": "A endpoint that is signaled with the user event."
    },
    "userevent": {
      "required": true,
      "type": "object",
      "description": "Custom Userevent data"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* bridge: [Bridge|#Bridge] _(optional)_ - A bridge that is signaled with the user event.
* channel: [Channel|#Channel] _(optional)_ - A channel that is signaled with the user event.
* endpoint: [Endpoint|#Endpoint] _(optional)_ - A endpoint that is signaled with the user event.
* eventname: string - The name of the user event.
* userevent: [object|#object] - Custom Userevent data

## ChannelVarset
Base type: [Event](#event)

### Model
``` javascript title="ChannelVarset" linenums="1"
{
  "id": "ChannelVarset",
  "description": "Channel variable changed.",
  "properties": {
    "variable": {
      "required": true,
      "type": "string",
      "description": "The variable that changed."
    },
    "value": {
      "required": true,
      "type": "string",
      "description": "The new value of the variable."
    },
    "channel": {
      "required": false,
      "type": "Channel",
      "description": "The channel on which the variable was set.\n\nIf missing, the variable is a global variable."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel] _(optional)_ - The channel on which the variable was set.

If missing, the variable is a global variable.
* value: string - The new value of the variable.
* variable: string - The variable that changed.

## ContactInfo


### Model
``` javascript title="ContactInfo" linenums="1"
{
  "id": "ContactInfo",
  "description": "Detailed information about a contact on an endpoint.",
  "properties": {
    "uri": {
      "type": "string",
      "description": "The location of the contact.",
      "required": true
    },
    "contact_status": {
      "type": "string",
      "description": "The current status of the contact.",
      "required": true,
      "allowableValues": {
        "valueType": "LIST",
        "values": [
          "Unreachable",
          "Reachable",
          "Unknown",
          "NonQualified",
          "Removed"
        ]
      }
    },
    "aor": {
      "type": "string",
      "description": "The Address of Record this contact belongs to.",
      "required": true
    },
    "roundtrip_usec": {
      "type": "string",
      "description": "Current round trip time, in microseconds, for the contact.",
      "required": false
    }
  }
}
```
### Properties
* aor: string - The Address of Record this contact belongs to.
* contact_status: string - The current status of the contact.
* roundtrip_usec: string _(optional)_ - Current round trip time, in microseconds, for the contact.
* uri: string - The location of the contact.

## ContactStatusChange
Base type: [Event](#event)

### Model
``` javascript title="ContactStatusChange" linenums="1"
{
  "id": "ContactStatusChange",
  "description": "The state of a contact on an endpoint has changed.",
  "properties": {
    "endpoint": {
      "required": true,
      "type": "Endpoint"
    },
    "contact_info": {
      "required": true,
      "type": "ContactInfo"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* contact_info: [ContactInfo|#ContactInfo]
* endpoint: [Endpoint|#Endpoint]

## DeviceStateChanged
Base type: [Event](#event)

### Model
``` javascript title="DeviceStateChanged" linenums="1"
{
  "id": "DeviceStateChanged",
  "description": "Notification that a device state has changed.",
  "properties": {
    "device_state": {
      "type": "DeviceState",
      "description": "Device state object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* device_state: [DeviceState|#DeviceState] - Device state object

## Dial
Base type: [Event](#event)

### Model
``` javascript title="Dial" linenums="1"
{
  "id": "Dial",
  "description": "Dialing state has changed.",
  "properties": {
    "caller": {
      "required": false,
      "type": "Channel",
      "description": "The calling channel."
    },
    "peer": {
      "required": true,
      "type": "Channel",
      "description": "The dialed channel."
    },
    "forward": {
      "required": false,
      "type": "string",
      "description": "Forwarding target requested by the original dialed channel."
    },
    "forwarded": {
      "required": false,
      "type": "Channel",
      "description": "Channel that the caller has been forwarded to."
    },
    "dialstring": {
      "required": false,
      "type": "string",
      "description": "The dial string for calling the peer channel."
    },
    "dialstatus": {
      "required": true,
      "type": "string",
      "description": "Current status of the dialing attempt to the peer."
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* caller: [Channel|#Channel] _(optional)_ - The calling channel.
* dialstatus: string - Current status of the dialing attempt to the peer.
* dialstring: string _(optional)_ - The dial string for calling the peer channel.
* forward: string _(optional)_ - Forwarding target requested by the original dialed channel.
* forwarded: [Channel|#Channel] _(optional)_ - Channel that the caller has been forwarded to.
* peer: [Channel|#Channel] - The dialed channel.

## EndpointStateChange
Base type: [Event](#event)

### Model
``` javascript title="EndpointStateChange" linenums="1"
{
  "id": "EndpointStateChange",
  "description": "Endpoint state changed.",
  "properties": {
    "endpoint": {
      "required": true,
      "type": "Endpoint"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* endpoint: [Endpoint|#Endpoint]

## Event
Base type: [Message](#message)
Subtypes: [ApplicationMoveFailed](#applicationmovefailed) [ApplicationReplaced](#applicationreplaced) [BridgeAttendedTransfer](#bridgeattendedtransfer) [BridgeBlindTransfer](#bridgeblindtransfer) [BridgeCreated](#bridgecreated) [BridgeDestroyed](#bridgedestroyed) [BridgeMerged](#bridgemerged) [BridgeVideoSourceChanged](#bridgevideosourcechanged) [ChannelCallerId](#channelcallerid) [ChannelConnectedLine](#channelconnectedline) [ChannelCreated](#channelcreated) [ChannelDestroyed](#channeldestroyed) [ChannelDialplan](#channeldialplan) [ChannelDtmfReceived](#channeldtmfreceived) [ChannelEnteredBridge](#channelenteredbridge) [ChannelHangupRequest](#channelhanguprequest) [ChannelHold](#channelhold) [ChannelLeftBridge](#channelleftbridge) [ChannelStateChange](#channelstatechange) [ChannelTalkingFinished](#channeltalkingfinished) [ChannelTalkingStarted](#channeltalkingstarted) [ChannelUnhold](#channelunhold) [ChannelUserevent](#channeluserevent) [ChannelVarset](#channelvarset) [ContactStatusChange](#contactstatuschange) [DeviceStateChanged](#devicestatechanged) [Dial](#dial) [EndpointStateChange](#endpointstatechange) [PeerStatusChange](#peerstatuschange) [PlaybackContinuing](#playbackcontinuing) [PlaybackFinished](#playbackfinished) [PlaybackStarted](#playbackstarted) [RecordingFailed](#recordingfailed) [RecordingFinished](#recordingfinished) [RecordingStarted](#recordingstarted) [StasisEnd](#stasisend) [StasisStart](#stasisstart) [TextMessageReceived](#textmessagereceived)
### Model
``` javascript title="Event" linenums="1"
{
  "id": "Event",
  "description": "Base type for asynchronous events from Asterisk.",
  "properties": {
    "application": {
      "type": "string",
      "description": "Name of the application receiving the event.",
      "required": true
    },
    "timestamp": {
      "type": "Date",
      "description": "Time at which this event was created.",
      "required": true
    }
  },
  "subTypes": [
    "DeviceStateChanged",
    "PlaybackStarted",
    "PlaybackContinuing",
    "PlaybackFinished",
    "RecordingStarted",
    "RecordingFinished",
    "RecordingFailed",
    "ApplicationMoveFailed",
    "ApplicationReplaced",
    "BridgeCreated",
    "BridgeDestroyed",
    "BridgeMerged",
    "BridgeBlindTransfer",
    "BridgeAttendedTransfer",
    "BridgeVideoSourceChanged",
    "ChannelCreated",
    "ChannelDestroyed",
    "ChannelEnteredBridge",
    "ChannelLeftBridge",
    "ChannelStateChange",
    "ChannelDtmfReceived",
    "ChannelDialplan",
    "ChannelCallerId",
    "ChannelUserevent",
    "ChannelHangupRequest",
    "ChannelVarset",
    "ChannelTalkingStarted",
    "ChannelTalkingFinished",
    "ChannelHold",
    "ChannelUnhold",
    "ContactStatusChange",
    "EndpointStateChange",
    "Dial",
    "StasisEnd",
    "StasisStart",
    "TextMessageReceived",
    "ChannelConnectedLine",
    "PeerStatusChange"
  ]
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.

## Message

Subtypes: [ApplicationMoveFailed](#applicationmovefailed) [ApplicationReplaced](#applicationreplaced) [BridgeAttendedTransfer](#bridgeattendedtransfer) [BridgeBlindTransfer](#bridgeblindtransfer) [BridgeCreated](#bridgecreated) [BridgeDestroyed](#bridgedestroyed) [BridgeMerged](#bridgemerged) [BridgeVideoSourceChanged](#bridgevideosourcechanged) [ChannelCallerId](#channelcallerid) [ChannelConnectedLine](#channelconnectedline) [ChannelCreated](#channelcreated) [ChannelDestroyed](#channeldestroyed) [ChannelDialplan](#channeldialplan) [ChannelDtmfReceived](#channeldtmfreceived) [ChannelEnteredBridge](#channelenteredbridge) [ChannelHangupRequest](#channelhanguprequest) [ChannelHold](#channelhold) [ChannelLeftBridge](#channelleftbridge) [ChannelStateChange](#channelstatechange) [ChannelTalkingFinished](#channeltalkingfinished) [ChannelTalkingStarted](#channeltalkingstarted) [ChannelUnhold](#channelunhold) [ChannelUserevent](#channeluserevent) [ChannelVarset](#channelvarset) [ContactStatusChange](#contactstatuschange) [DeviceStateChanged](#devicestatechanged) [Dial](#dial) [EndpointStateChange](#endpointstatechange) [Event](#event) [MissingParams](#missingparams) [PeerStatusChange](#peerstatuschange) [PlaybackContinuing](#playbackcontinuing) [PlaybackFinished](#playbackfinished) [PlaybackStarted](#playbackstarted) [RecordingFailed](#recordingfailed) [RecordingFinished](#recordingfinished) [RecordingStarted](#recordingstarted) [StasisEnd](#stasisend) [StasisStart](#stasisstart) [TextMessageReceived](#textmessagereceived)
### Model
``` javascript title="Message" linenums="1"
{
  "id": "Message",
  "description": "Base type for errors and events",
  "discriminator": "type",
  "properties": {
    "type": {
      "type": "string",
      "required": true,
      "description": "Indicates the type of this message."
    },
    "asterisk_id": {
      "type": "string",
      "required": false,
      "description": "The unique ID for the Asterisk instance that raised this event."
    }
  },
  "subTypes": [
    "MissingParams",
    "Event"
  ]
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.

## MissingParams
Base type: [Message](#message)

### Model
``` javascript title="MissingParams" linenums="1"
{
  "id": "MissingParams",
  "description": "Error event sent when required params are missing.",
  "properties": {
    "params": {
      "required": true,
      "type": "List[string]",
      "description": "A list of the missing parameters"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* params: List\[string\] - A list of the missing parameters

## Peer


### Model
``` javascript title="Peer" linenums="1"
{
  "id": "Peer",
  "description": "Detailed information about a remote peer that communicates with Asterisk.",
  "properties": {
    "peer_status": {
      "type": "string",
      "description": "The current state of the peer. Note that the values of the status are dependent on the underlying peer technology.",
      "required": true
    },
    "cause": {
      "type": "string",
      "description": "An optional reason associated with the change in peer_status.",
      "required": false
    },
    "address": {
      "type": "string",
      "description": "The IP address of the peer.",
      "required": false
    },
    "port": {
      "type": "string",
      "description": "The port of the peer.",
      "required": false
    },
    "time": {
      "type": "string",
      "description": "The last known time the peer was contacted.",
      "required": false
    }
  }
}
```
### Properties
* address: string _(optional)_ - The IP address of the peer.
* cause: string _(optional)_ - An optional reason associated with the change in peer_status.
* peer_status: string - The current state of the peer. Note that the values of the status are dependent on the underlying peer technology.
* port: string _(optional)_ - The port of the peer.
* time: string _(optional)_ - The last known time the peer was contacted.

## PeerStatusChange
Base type: [Event](#event)

### Model
``` javascript title="PeerStatusChange" linenums="1"
{
  "id": "PeerStatusChange",
  "description": "The state of a peer associated with an endpoint has changed.",
  "properties": {
    "endpoint": {
      "required": true,
      "type": "Endpoint"
    },
    "peer": {
      "required": true,
      "type": "Peer"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* endpoint: [Endpoint|#Endpoint]
* peer: [Peer|#Peer]

## PlaybackContinuing
Base type: [Event](#event)

### Model
``` javascript title="PlaybackContinuing" linenums="1"
{
  "id": "PlaybackContinuing",
  "description": "Event showing the continuation of a media playback operation from one media URI to the next in the list.",
  "properties": {
    "playback": {
      "type": "Playback",
      "description": "Playback control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* playback: [Playback|#Playback] - Playback control object

## PlaybackFinished
Base type: [Event](#event)

### Model
``` javascript title="PlaybackFinished" linenums="1"
{
  "id": "PlaybackFinished",
  "description": "Event showing the completion of a media playback operation.",
  "properties": {
    "playback": {
      "type": "Playback",
      "description": "Playback control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* playback: [Playback|#Playback] - Playback control object

## PlaybackStarted
Base type: [Event](#event)

### Model
``` javascript title="PlaybackStarted" linenums="1"
{
  "id": "PlaybackStarted",
  "description": "Event showing the start of a media playback operation.",
  "properties": {
    "playback": {
      "type": "Playback",
      "description": "Playback control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* playback: [Playback|#Playback] - Playback control object

## RecordingFailed
Base type: [Event](#event)

### Model
``` javascript title="RecordingFailed" linenums="1"
{
  "id": "RecordingFailed",
  "description": "Event showing failure of a recording operation.",
  "properties": {
    "recording": {
      "type": "LiveRecording",
      "description": "Recording control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* recording: [LiveRecording|#LiveRecording] - Recording control object

## RecordingFinished
Base type: [Event](#event)

### Model
``` javascript title="RecordingFinished" linenums="1"
{
  "id": "RecordingFinished",
  "description": "Event showing the completion of a recording operation.",
  "properties": {
    "recording": {
      "type": "LiveRecording",
      "description": "Recording control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* recording: [LiveRecording|#LiveRecording] - Recording control object

## RecordingStarted
Base type: [Event](#event)

### Model
``` javascript title="RecordingStarted" linenums="1"
{
  "id": "RecordingStarted",
  "description": "Event showing the start of a recording operation.",
  "properties": {
    "recording": {
      "type": "LiveRecording",
      "description": "Recording control object",
      "required": true
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* recording: [LiveRecording|#LiveRecording] - Recording control object

## StasisEnd
Base type: [Event](#event)

### Model
``` javascript title="StasisEnd" linenums="1"
{
  "id": "StasisEnd",
  "description": "Notification that a channel has left a Stasis application.",
  "properties": {
    "channel": {
      "required": true,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* channel: [Channel|#Channel]

## StasisStart
Base type: [Event](#event)

### Model
``` javascript title="StasisStart" linenums="1"
{
  "id": "StasisStart",
  "description": "Notification that a channel has entered a Stasis application.",
  "properties": {
    "args": {
      "required": true,
      "type": "List[string]",
      "description": "Arguments to the application"
    },
    "channel": {
      "required": true,
      "type": "Channel"
    },
    "replace_channel": {
      "required": false,
      "type": "Channel"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* args: List\[string\] - Arguments to the application
* channel: [Channel|#Channel]
* replace_channel: [Channel|#Channel] _(optional)_

## TextMessageReceived
Base type: [Event](#event)

### Model
``` javascript title="TextMessageReceived" linenums="1"
{
  "id": "TextMessageReceived",
  "description": "A text message was received from an endpoint.",
  "properties": {
    "message": {
      "required": true,
      "type": "TextMessage"
    },
    "endpoint": {
      "required": false,
      "type": "Endpoint"
    }
  }
}
```
### Properties
* asterisk_id: string _(optional)_ - The unique ID for the Asterisk instance that raised this event.
* type: string - Indicates the type of this message.
* application: string - Name of the application receiving the event.
* timestamp: Date - Time at which this event was created.
* endpoint: [Endpoint|#Endpoint] _(optional)_
* message: [TextMessage|#TextMessage]

## Application


### Model
``` javascript title="Application" linenums="1"
{
  "id": "Application",
  "description": "Details of a Stasis application",
  "properties": {
    "name": {
      "type": "string",
      "description": "Name of this application",
      "required": true
    },
    "channel_ids": {
      "type": "List[string]",
      "description": "Id's for channels subscribed to.",
      "required": true
    },
    "bridge_ids": {
      "type": "List[string]",
      "description": "Id's for bridges subscribed to.",
      "required": true
    },
    "endpoint_ids": {
      "type": "List[string]",
      "description": "{tech}/{resource} for endpoints subscribed to.",
      "required": true
    },
    "device_names": {
      "type": "List[string]",
      "description": "Names of the devices subscribed to.",
      "required": true
    },
    "events_allowed": {
      "type": "List[object]",
      "description": "Event types sent to the application.",
      "required": true
    },
    "events_disallowed": {
      "type": "List[object]",
      "description": "Event types not sent to the application.",
      "required": true
    }
  }
}
```
### Properties
* bridge_ids: List\[string\] - Id's for bridges subscribed to.
* channel_ids: List\[string\] - Id's for channels subscribed to.
* device_names: List\[string\] - Names of the devices subscribed to.
* endpoint_ids: List\[string\] - \{tech\}/\{resource\} for endpoints subscribed to.
* events_allowed: [List\[object\]|#object] - Event types sent to the application.
* events_disallowed: [List\[object\]|#object] - Event types not sent to the application.
* name: string - Name of this application

