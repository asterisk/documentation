---
search:
  boost: 0.5
---

# Recordings

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/recordings/stored](#liststored) | [List\[StoredRecording\]](../Asterisk_REST_Data_Models#storedrecording) | List recordings that are complete. |
| GET | [/recordings/stored/\{recordingName\}](#getstored) | [StoredRecording](../Asterisk_REST_Data_Models#storedrecording) | Get a stored recording's details. |
| DELETE | [/recordings/stored/\{recordingName\}](#deletestored) | void | Delete a stored recording. |
| GET | [/recordings/stored/\{recordingName\}/file](#getstoredfile) | [binary](../Asterisk_REST_Data_Models#binary) | Get the file associated with the stored recording. |
| POST | [/recordings/stored/\{recordingName\}/copy](#copystored) | [StoredRecording](../Asterisk_REST_Data_Models#storedrecording) | Copy a stored recording. |
| GET | [/recordings/live/\{recordingName\}](#getlive) | [LiveRecording](../Asterisk_REST_Data_Models#liverecording) | List live recordings. |
| DELETE | [/recordings/live/\{recordingName\}](#cancel) | void | Stop a live recording and discard it. |
| POST | [/recordings/live/\{recordingName\}/stop](#stop) | void | Stop a live recording and store it. |
| POST | [/recordings/live/\{recordingName\}/pause](#pause) | void | Pause a live recording. |
| DELETE | [/recordings/live/\{recordingName\}/pause](#unpause) | void | Unpause a live recording. |
| POST | [/recordings/live/\{recordingName\}/mute](#mute) | void | Mute a live recording. |
| DELETE | [/recordings/live/\{recordingName\}/mute](#unmute) | void | Unmute a live recording. |

---
[//]: # (anchor:liststored)
## listStored
### GET /recordings/stored
List recordings that are complete.

---
[//]: # (anchor:getstored)
## getStored
### GET /recordings/stored/\{recordingName\}
Get a stored recording's details.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found

---
[//]: # (anchor:deletestored)
## deleteStored
### DELETE /recordings/stored/\{recordingName\}
Delete a stored recording.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found

---
[//]: # (anchor:getstoredfile)
## getStoredFile
### GET /recordings/stored/\{recordingName\}/file
Get the file associated with the stored recording.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 403 - The recording file could not be opened
* 404 - Recording not found

---
[//]: # (anchor:copystored)
## copyStored
### POST /recordings/stored/\{recordingName\}/copy
Copy a stored recording.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording to copy

### Query parameters
* destinationRecordingName: _string_ - *(required)* The destination name of the recording

### Error Responses
* 404 - Recording not found
* 409 - A recording with the same name already exists on the system

---
[//]: # (anchor:getlive)
## getLive
### GET /recordings/live/\{recordingName\}
List live recordings.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found

---
[//]: # (anchor:cancel)
## cancel
### DELETE /recordings/live/\{recordingName\}
Stop a live recording and discard it.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found

---
[//]: # (anchor:stop)
## stop
### POST /recordings/live/\{recordingName\}/stop
Stop a live recording and store it.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found

---
[//]: # (anchor:pause)
## pause
### POST /recordings/live/\{recordingName\}/pause
Pause a live recording. Pausing a recording suspends silence detection, which will be restarted when the recording is unpaused. Paused time is not included in the accounting for maxDurationSeconds.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found
* 409 - Recording not in session

---
[//]: # (anchor:unpause)
## unpause
### DELETE /recordings/live/\{recordingName\}/pause
Unpause a live recording.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found
* 409 - Recording not in session

---
[//]: # (anchor:mute)
## mute
### POST /recordings/live/\{recordingName\}/mute
Mute a live recording. Muting a recording suspends silence detection, which will be restarted when the recording is unmuted.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found
* 409 - Recording not in session

---
[//]: # (anchor:unmute)
## unmute
### DELETE /recordings/live/\{recordingName\}/mute
Unmute a live recording.

### Path parameters
Parameters are case-sensitive.
* recordingName: _string_ - The name of the recording

### Error Responses
* 404 - Recording not found
* 409 - Recording not in session
