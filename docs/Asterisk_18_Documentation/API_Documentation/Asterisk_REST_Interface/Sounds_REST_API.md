---
search:
  boost: 0.5
---

# Sounds

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/sounds](#list) | [List\[Sound\]](../Asterisk_REST_Data_Models#sound) | List all sounds. |
| GET | [/sounds/\{soundId\}](#get) | [Sound](../Asterisk_REST_Data_Models#sound) | Get a sound's details. |

---
[//]: # (anchor:list)
## list
### GET /sounds
List all sounds.

### Query parameters
* lang: _string_ - Lookup sound for a specific language.
* format: _string_ - Lookup sound in a specific format.

---
[//]: # (anchor:get)
## get
### GET /sounds/\{soundId\}
Get a sound's details.

### Path parameters
Parameters are case-sensitive.
* soundId: _string_ - Sound's id
