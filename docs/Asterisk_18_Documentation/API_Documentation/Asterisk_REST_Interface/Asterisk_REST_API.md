---
search:
  boost: 0.5
---

# Asterisk

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}](#getobject) | [List\[ConfigTuple\]](../Asterisk_REST_Data_Models#configtuple) | Retrieve a dynamic configuration object. |
| PUT | [/asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}](#updateobject) | [List\[ConfigTuple\]](../Asterisk_REST_Data_Models#configtuple) | Create or update a dynamic configuration object. |
| DELETE | [/asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}](#deleteobject) | void | Delete a dynamic configuration object. |
| GET | [/asterisk/info](#getinfo) | [AsteriskInfo](../Asterisk_REST_Data_Models#asteriskinfo) | Gets Asterisk system information. |
| GET | [/asterisk/ping](#ping) | [AsteriskPing](../Asterisk_REST_Data_Models#asteriskping) | Response pong message. |
| GET | [/asterisk/modules](#listmodules) | [List\[Module\]](../Asterisk_REST_Data_Models#module) | List Asterisk modules. |
| GET | [/asterisk/modules/\{moduleName\}](#getmodule) | [Module](../Asterisk_REST_Data_Models#module) | Get Asterisk module information. |
| POST | [/asterisk/modules/\{moduleName\}](#loadmodule) | void | Load an Asterisk module. |
| DELETE | [/asterisk/modules/\{moduleName\}](#unloadmodule) | void | Unload an Asterisk module. |
| PUT | [/asterisk/modules/\{moduleName\}](#reloadmodule) | void | Reload an Asterisk module. |
| GET | [/asterisk/logging](#listlogchannels) | [List\[LogChannel\]](../Asterisk_REST_Data_Models#logchannel) | Gets Asterisk log channel information. |
| POST | [/asterisk/logging/\{logChannelName\}](#addlog) | void | Adds a log channel. |
| DELETE | [/asterisk/logging/\{logChannelName\}](#deletelog) | void | Deletes a log channel. |
| PUT | [/asterisk/logging/\{logChannelName\}/rotate](#rotatelog) | void | Rotates a log channel. |
| GET | [/asterisk/variable](#getglobalvar) | [Variable](../Asterisk_REST_Data_Models#variable) | Get the value of a global variable. |
| POST | [/asterisk/variable](#setglobalvar) | void | Set the value of a global variable. |

---
[//]: # (anchor:getobject)
## getObject
### GET /asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}
Retrieve a dynamic configuration object.

### Path parameters
Parameters are case-sensitive.
* configClass: _string_ - The configuration class containing dynamic configuration objects.
* objectType: _string_ - The type of configuration object to retrieve.
* id: _string_ - The unique identifier of the object to retrieve.

### Error Responses
* 404 - \{configClass|objectType|id\} not found

---
[//]: # (anchor:updateobject)
## updateObject
### PUT /asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}
Create or update a dynamic configuration object.

### Path parameters
Parameters are case-sensitive.
* configClass: _string_ - The configuration class containing dynamic configuration objects.
* objectType: _string_ - The type of configuration object to create or update.
* id: _string_ - The unique identifier of the object to create or update.


### Body parameter
* fields: containers - The body object should have a value that is a list of ConfigTuples, which provide the fields to update. Ex. \[ \{ "attribute": "directmedia", "value": "false" \} \]

### Error Responses
* 400 - Bad request body
* 403 - Could not create or update object
* 404 - \{configClass|objectType\} not found

---
[//]: # (anchor:deleteobject)
## deleteObject
### DELETE /asterisk/config/dynamic/\{configClass\}/\{objectType\}/\{id\}
Delete a dynamic configuration object.

### Path parameters
Parameters are case-sensitive.
* configClass: _string_ - The configuration class containing dynamic configuration objects.
* objectType: _string_ - The type of configuration object to delete.
* id: _string_ - The unique identifier of the object to delete.

### Error Responses
* 403 - Could not delete object
* 404 - \{configClass|objectType|id\} not found

---
[//]: # (anchor:getinfo)
## getInfo
### GET /asterisk/info
Gets Asterisk system information.

### Query parameters
* only: _string_ - Filter information returned
    * Allowed values: build, system, config, status
    * Allows comma separated values.

---
[//]: # (anchor:ping)
## ping
### GET /asterisk/ping
Response pong message.

---
[//]: # (anchor:listmodules)
## listModules
### GET /asterisk/modules
List Asterisk modules.

---
[//]: # (anchor:getmodule)
## getModule
### GET /asterisk/modules/\{moduleName\}
Get Asterisk module information.

### Path parameters
Parameters are case-sensitive.
* moduleName: _string_ - Module's name

### Error Responses
* 404 - Module could not be found in running modules.
* 409 - Module information could not be retrieved.

---
[//]: # (anchor:loadmodule)
## loadModule
### POST /asterisk/modules/\{moduleName\}
Load an Asterisk module.

### Path parameters
Parameters are case-sensitive.
* moduleName: _string_ - Module's name

### Error Responses
* 409 - Module could not be loaded.

---
[//]: # (anchor:unloadmodule)
## unloadModule
### DELETE /asterisk/modules/\{moduleName\}
Unload an Asterisk module.

### Path parameters
Parameters are case-sensitive.
* moduleName: _string_ - Module's name

### Error Responses
* 404 - Module not found in running modules.
* 409 - Module could not be unloaded.

---
[//]: # (anchor:reloadmodule)
## reloadModule
### PUT /asterisk/modules/\{moduleName\}
Reload an Asterisk module.

### Path parameters
Parameters are case-sensitive.
* moduleName: _string_ - Module's name

### Error Responses
* 404 - Module not found in running modules.
* 409 - Module could not be reloaded.

---
[//]: # (anchor:listlogchannels)
## listLogChannels
### GET /asterisk/logging
Gets Asterisk log channel information.

---
[//]: # (anchor:addlog)
## addLog
### POST /asterisk/logging/\{logChannelName\}
Adds a log channel.

### Path parameters
Parameters are case-sensitive.
* logChannelName: _string_ - The log channel to add

### Query parameters
* configuration: _string_ - *(required)* levels of the log channel

### Error Responses
* 400 - Bad request body
* 409 - Log channel could not be created.

---
[//]: # (anchor:deletelog)
## deleteLog
### DELETE /asterisk/logging/\{logChannelName\}
Deletes a log channel.

### Path parameters
Parameters are case-sensitive.
* logChannelName: _string_ - Log channels name

### Error Responses
* 404 - Log channel does not exist.

---
[//]: # (anchor:rotatelog)
## rotateLog
### PUT /asterisk/logging/\{logChannelName\}/rotate
Rotates a log channel.

### Path parameters
Parameters are case-sensitive.
* logChannelName: _string_ - Log channel's name

### Error Responses
* 404 - Log channel does not exist.

---
[//]: # (anchor:getglobalvar)
## getGlobalVar
### GET /asterisk/variable
Get the value of a global variable.

### Query parameters
* variable: _string_ - *(required)* The variable to get

### Error Responses
* 400 - Missing variable parameter.

---
[//]: # (anchor:setglobalvar)
## setGlobalVar
### POST /asterisk/variable
Set the value of a global variable.

### Query parameters
* variable: _string_ - *(required)* The variable to set
* value: _string_ - The value to set the variable to

### Error Responses
* 400 - Missing variable parameter.
