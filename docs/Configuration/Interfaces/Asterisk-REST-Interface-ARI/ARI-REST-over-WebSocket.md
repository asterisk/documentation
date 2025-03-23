# ARI REST over Websocket - DRAFT

Historically, using ARI required two communications channels... HTTP for making REST requests and getting their reponses, and Websocket for receiving events.  Upcoming releases of Asterisk however, will allow you to make REST requests and receive their responses over the same Websocket you use to receive events.

## The Protocol

There are several published protocols for request/response type communication over Websockets including [WAMP](https://wamp-proto.org), [JSON-RPC](https://www.jsonrpc.org), [XMPP](https://xmpp.org), [Socket.IO](https://socket.io), etc. but these are all fairly heavyweight and would require significant effort to implement.  Instead we went with a simple JSON wrapper loosely based on [SwaggerSocket](https://github.com/swagger-api/swagger-socket).

### Request/Response

Assuming you've already established a websocket to Asterisk, you can start sending requests without any further setup.

Let's say you received a StasisStart event for channel `ast-1741988825.0`.  You can now issue a POST request to answer it...

Client sends:

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "1e409d15-a35e-4946-b270-c460cc45b2c4",
  "method": "POST",
  "uri": "channels/ast-1741988825.0/answer"
}
```

* `type` must be `RESTRequest`.
* The `transaction_id` is optional and can be any valid string. It will be returned in the response.  You could use this to correlate multiple requests together like creating a channel and adding it to a bridge.
* `request_id` is also optional and can be any valid string. It will also be returned in the response. You should use this to tie a single request and response together.
* `method` can be any HTTP method that's valid for the resource you're referencing.
* `uri` is the URI for the resource with optional query parameters but without the leading `/`.

Server responds with a standard ARI Event:

```json
{
  "type": "RESTResponse",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "1e409d15-a35e-4946-b270-c460cc45b2c4",
  "status_code": 204,
  "reason_phrase": "No Content",
  "uri": "channels/ast-1741988825.0/answer"
  "timestamp": "2025-03-17T08:32:35.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

The response is straightforward. The `transaction_id` and `request_id` will be whatever was specified in the request.  Those properties will be present but empty strings if not specified in the request.

Let's do a GET on the channel now...

Client sends:

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "469ee918-d315-435d-b40f-c8e84007d4d3",
  "method": "GET",
  "uri": "channels/ast-1741988825.0"
}
```

Server responds with:

```json
{
  "type": "RESTResponse",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "469ee918-d315-435d-b40f-c8e84007d4d3",
  "status_code": 200,
  "reason_phrase": "OK",
  "uri": "channels/ast-1741988825.0",
  "headers": [
    {
      "name": "Content-type",
      "value": "application/json"
    }
  ],
  "message_body": "{\"id\":\"ast-1741990187.0\",\"name\":\"PJSIP/1171-00000000\",
    \"state\":\"Up\",\"protocol_id\":\"tqOjze4LWAiFZVNlsj4FJpE7H0VX1Yhm\",\"caller\":
    {\"name\":  \"Alice Cooper\",\"number\":\"1171\"},\"connected\":{\"name\":\"\",
    \"number\":\"\"},  \"accountcode\":\"\",\"dialplan\":{\"context\":\"default\",\"exten\":
    \"1118\",\"priority\":  2,\"app_name\":\"Stasis\",\"app_data\":\"voicebot\"},
    \"creationtime\":  \"2025-03-17T08:32:34.709-0600\",\"language\":\"en_US\"}",
  "timestamp": "2025-03-17T08:32:38.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

You should be able to figure out the response for yourself.  The `message_body` is exactly the same JSON response you'd have gotten if you made this GET request via HTTP. It's wrapped for clarity and it's escaped since the response message itself is JSON. You can unmarshall that into its own object using whatever JSON utilities are available for your application programming language.

Now let's snoop on that channel...

This requires us to send parameters to the resource. There are 4 methods for doing this and they are processed in the order below...

* Adding a query string to the `uri`;

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "9a4d7b2b-d0f0-402f-bfbd-296d3e0e6e1e",
  "method": "POST",
  "uri": "channels/ast-12345678.0/snoop/snoop-channel1?spy=both&whisper=none&app=Record&appArgs=myfile.wav,5,60,q"
}
```

* Using the `query-strings` array parameter:

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "9a4d7b2b-d0f0-402f-bfbd-296d3e0e6e1e",
  "method": "POST",
  "uri": "channels/ast-12345678.0/snoop/snoop-channel1",
  "query_strings": [
      "spy": "both",
      "whisper": "none",
      "app": "Record",
      "appArgs": "myfile.wav,5,60,q"
  ]
}
```

* Using an `application/x-www-form-urlencoded` message body:

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "9a4d7b2b-d0f0-402f-bfbd-296d3e0e6e1e",
  "method": "POST",
  "uri": "channels/ast-12345678.0/snoop/snoop-channel1",
  "content_type": "application/x-www-form-urlencoded",
  "message_body": "spy=both&whisper=none&app=Record&appArgs=myfile.wav,5,60,q"
}
```

* Using an `application/json` message body:

```json
{
  "type": "RESTRequest",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "9a4d7b2b-d0f0-402f-bfbd-296d3e0e6e1e",
  "method": "POST",
  "uri": "channels/ast-12345678.0/snoop/snoop-channel1",
  "content_type": "application/json",
  "message_body": "{ \"spy\": \"both\", \"whisper\": \"none\", \"app\": \"Record\", \"appArgs\": \"myfile.wav,5,60,q\" }"
}
```

/// warning
PICK A METHOD! Using more than one method to pass parameters to the resource is highly discouraged because the rules for duplicates are a bit tricky.  Of the first 3 methods, the first occurence wins. However, if you also use the 4th method, it will overwrite any earlier values.
///

Server responds with:

```json
{
  "type": "RESTResponse",
  "transaction_id": "d1eb679c-166f-4278-8b28-0340088a3410",
  "request_id": "9a4d7b2b-d0f0-402f-bfbd-296d3e0e6e1e",
  "status_code": 204,
  "reason_phrase": "No Content",
  "path": "channels/ast-12345678.0/snoop/snoop-channel1"
  "timestamp": "2025-03-17T08:32:39.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

That's all there is to it.

## Caveats

There's really only one...  You can't get binary data like recordings via the websocket.  The frames written to the underlying websocket use the TEXT opcode and the messages are all JSON and while there are ways we could send binary data, they're just too complicated and could interfere with getting asynchronous events.  Attempting to retrieve binary data will result in a 406 "Not Acceptable. Use HTTP GET" response.
