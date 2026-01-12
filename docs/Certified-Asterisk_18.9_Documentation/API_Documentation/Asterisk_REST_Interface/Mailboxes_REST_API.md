---
search:
  boost: 0.5
---

# Mailboxes

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/mailboxes](#list) | [List\[Mailbox\]](../Asterisk_REST_Data_Models#mailbox) | List all mailboxes. |
| GET | [/mailboxes/\{mailboxName\}](#get) | [Mailbox](../Asterisk_REST_Data_Models#mailbox) | Retrieve the current state of a mailbox. |
| PUT | [/mailboxes/\{mailboxName\}](#update) | void | Change the state of a mailbox. (Note - implicitly creates the mailbox). |
| DELETE | [/mailboxes/\{mailboxName\}](#delete) | void | Destroy a mailbox. |

---
[//]: # (anchor:list)
## list
### GET /mailboxes
List all mailboxes.

---
[//]: # (anchor:get)
## get
### GET /mailboxes/\{mailboxName\}
Retrieve the current state of a mailbox.

### Path parameters
Parameters are case-sensitive.
* mailboxName: _string_ - Name of the mailbox

### Error Responses
* 404 - Mailbox not found

---
[//]: # (anchor:update)
## update
### PUT /mailboxes/\{mailboxName\}
Change the state of a mailbox. (Note - implicitly creates the mailbox).

### Path parameters
Parameters are case-sensitive.
* mailboxName: _string_ - Name of the mailbox

### Query parameters
* oldMessages: _int_ - *(required)* Count of old messages in the mailbox
* newMessages: _int_ - *(required)* Count of new messages in the mailbox

### Error Responses
* 404 - Mailbox not found

---
[//]: # (anchor:delete)
## delete
### DELETE /mailboxes/\{mailboxName\}
Destroy a mailbox.

### Path parameters
Parameters are case-sensitive.
* mailboxName: _string_ - Name of the mailbox

### Error Responses
* 404 - Mailbox not found
