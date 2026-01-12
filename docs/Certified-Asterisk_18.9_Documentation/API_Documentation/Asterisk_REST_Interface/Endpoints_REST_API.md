---
search:
  boost: 0.5
---

# Endpoints

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/endpoints](#list) | [List\[Endpoint\]](../Asterisk_REST_Data_Models#endpoint) | List all endpoints. |
| PUT | [/endpoints/sendMessage](#sendmessage) | void | Send a message to some technology URI or endpoint. |
| GET | [/endpoints/\{tech\}](#listbytech) | [List\[Endpoint\]](../Asterisk_REST_Data_Models#endpoint) | List available endoints for a given endpoint technology. |
| GET | [/endpoints/\{tech\}/\{resource\}](#get) | [Endpoint](../Asterisk_REST_Data_Models#endpoint) | Details for an endpoint. |
| PUT | [/endpoints/\{tech\}/\{resource\}/sendMessage](#sendmessagetoendpoint) | void | Send a message to some endpoint in a technology. |

---
[//]: # (anchor:list)
## list
### GET /endpoints
List all endpoints.

---
[//]: # (anchor:sendmessage)
## sendMessage
### PUT /endpoints/sendMessage
Send a message to some technology URI or endpoint.

### Query parameters
* to: _string_ - *(required)* The endpoint resource or technology specific URI to send the message to. Valid resources are sip, pjsip, and xmpp.
* from: _string_ - *(required)* The endpoint resource or technology specific identity to send this message from. Valid resources are sip, pjsip, and xmpp.
* body: _string_ - The body of the message


### Body parameter
* variables: containers - 

### Error Responses
* 400 - Invalid parameters for sending a message.
* 404 - Endpoint not found

---
[//]: # (anchor:listbytech)
## listByTech
### GET /endpoints/\{tech\}
List available endoints for a given endpoint technology.

### Path parameters
Parameters are case-sensitive.
* tech: _string_ - Technology of the endpoints (sip,iax2,...)

### Error Responses
* 404 - Endpoints not found

---
[//]: # (anchor:get)
## get
### GET /endpoints/\{tech\}/\{resource\}
Details for an endpoint.

### Path parameters
Parameters are case-sensitive.
* tech: _string_ - Technology of the endpoint
* resource: _string_ - ID of the endpoint

### Error Responses
* 400 - Invalid parameters for sending a message.
* 404 - Endpoints not found

---
[//]: # (anchor:sendmessagetoendpoint)
## sendMessageToEndpoint
### PUT /endpoints/\{tech\}/\{resource\}/sendMessage
Send a message to some endpoint in a technology.

### Path parameters
Parameters are case-sensitive.
* tech: _string_ - Technology of the endpoint
* resource: _string_ - ID of the endpoint

### Query parameters
* from: _string_ - *(required)* The endpoint resource or technology specific identity to send this message from. Valid resources are sip, pjsip, and xmpp.
* body: _string_ - The body of the message


### Body parameter
* variables: containers - 

### Error Responses
* 400 - Invalid parameters for sending a message.
* 404 - Endpoint not found
