---
search:
  boost: 0.5
---

# Devicestates

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/deviceStates](#list) | [List\[DeviceState\]](../Asterisk_REST_Data_Models#devicestate) | List all ARI controlled device states. |
| GET | [/deviceStates/\{deviceName\}](#get) | [DeviceState](../Asterisk_REST_Data_Models#devicestate) | Retrieve the current state of a device. |
| PUT | [/deviceStates/\{deviceName\}](#update) | void | Change the state of a device controlled by ARI. (Note - implicitly creates the device state). |
| DELETE | [/deviceStates/\{deviceName\}](#delete) | void | Destroy a device-state controlled by ARI. |

---
[//]: # (anchor:list)
## list
### GET /deviceStates
List all ARI controlled device states.

---
[//]: # (anchor:get)
## get
### GET /deviceStates/\{deviceName\}
Retrieve the current state of a device.

### Path parameters
Parameters are case-sensitive.
* deviceName: _string_ - Name of the device

---
[//]: # (anchor:update)
## update
### PUT /deviceStates/\{deviceName\}
Change the state of a device controlled by ARI. (Note - implicitly creates the device state).

### Path parameters
Parameters are case-sensitive.
* deviceName: _string_ - Name of the device

### Query parameters
* deviceState: _string_ - *(required)* Device state value
  * Allowed values: NOT_INUSE, INUSE, BUSY, INVALID, UNAVAILABLE, RINGING, RINGINUSE, ONHOLD

### Error Responses
* 404 - Device name is missing
* 409 - Uncontrolled device specified

---
[//]: # (anchor:delete)
## delete
### DELETE /deviceStates/\{deviceName\}
Destroy a device-state controlled by ARI.

### Path parameters
Parameters are case-sensitive.
* deviceName: _string_ - Name of the device

### Error Responses
* 404 - Device name is missing
* 409 - Uncontrolled device specified
