# ARI REST over Websocket - DRAFT

Historically, using ARI required two communications channels... HTTP for making REST requests and getting their reponses, and Websocket for receiving events.  Upcoming releases of Asterisk however, will allow you to make REST requests and receive their responses over the same Websocket you use to receive events.

## The ASTSwaggerSocket Protocol

There are several published protocols for request/response type communication over Websockets including [WAMP](https://wamp-proto.org), [JSON-RPC](https://www.jsonrpc.org), [XMPP](https://xmpp.org), [Socket.IO](https://socket.io), etc. but these are all fairly heavyweight and would require significant effort to implement.  Instead we went with [SwaggerSocket](https://github.com/swagger-api/swagger-socket) which is a very lightweight JSON encapsulation of HTTP requests and responses and although that project itself is archived, the protocol itself is perfect for our use.  We did have to modify it slightly to fit the existing Asterisk ARI implementation (hence "ASTSwaggerSocket") but the changes are trivial.  See [Differences between SwaggerSocket and ASTSwaggerSocket](#differences-between-swaggersocket-and-astswaggersocket) below.

### Example Handshake

Assuming you've already established a Websocket connection to Asterisk, you'll need to start with a handshake before you can send requests.

Client sends:

```json
{
  "type": "RESTHandshakeRequest",
  "protocol_version": "1.0",
  "protocol_name": "ASTSwaggerSocket"
}
```

Server responds with a standard ARI Event:

```json
{
  "type": "RESTStatusResponse",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "status": {
    "status_code": 200,
    "reason_phrase": "OK"
  },
  "timestamp": "2025-03-14T15:37:21.208-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

The handshake only needs to be done once after you've established the websocket.  You'll need to use the `identity` when making future requests. Speaking of which, you can now make as many requests as you wish.

### Request/Response

Let's say you received a StasisStart event for channel `ast-1741988825.0`.  You can now issue a POST request to answer it...

Client sends:

```json
{
  "type": "RESTRequest",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "requests": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "method": "POST",
      "path": "channels/ast-1741988825.0/answer"
    }
  ]
}
```

* `type` must be `RESTRequest`.
* The `identity` property needs to be the same value that was returned in the `RESTStatusResponse` for the handshake.
* Although the SwaggerSocket protocol supports sending multiple requests in a single message, our version only looks at the first request in the `requests` array.
* `uuid` can actually be any string you like.  It's returned in the response so you can correlate it to the request that generated it.
* `method` can be any HTTP method that's valid for the resource you're referencing.
* `path` is the path to the resource.

Server responds with a standard ARI Event:

```json
{
  "type": "RESTResponseMsg",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "responses": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "status_code": 204,
      "reason_phrase": "No Content",
      "path": "channels/ast-1741988825.0/answer"
    }
  ],
  "timestamp": "2025-03-17T08:32:35.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

The response is straightforward. The `uuid` will be whatever was specified in the request.

Let's do a GET on the channel now...

Client sends:

```json
{
  "type": "RESTRequest",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "requests": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "method": "GET",
      "path": "channels/ast-1741988825.0"
    }
  ]
}
```

Server responds with:

```json
{
  "type": "RESTResponseMsg",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "responses": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "status_code": 200,
      "reason_phrase": "OK",
      "path": "channels/ast-1741988825.0",
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
      \"creationtime\":  \"2025-03-17T08:32:34.709-0600\",\"language\":\"en_US\"}"
    }
  ],
  "timestamp": "2025-03-17T08:32:38.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

You should be able to figure out the response for yourself.  The `message_body` is exactly the same JSON response you'd have gotten if you made this GET request via HTTP. It's escaped of course since the response message itself is JSON but you can unmarshall that into its own JSON object using whatever JSON utilities are available for your application programming language.

Now let's snoop on that channel...

This requires us to send parameters in a query string. The `path` parameter must not include a query string which is why it's named `path` and not `uri`.  Instead, query strings are specified with the `query_strings` array.

```json
{
  "type": "RESTRequest",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "requests": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "method": "POST",
      "path": "channels/ast-12345678.0/snoop/snoop-channel1"
      "query_strings": [
        {
          "spy": "both",
          "whisper": "none",
          "app": "Record",
          "appArgs": "myfile.wav,5,60,q"
        }
      ]
    }
  ]
}
```

We used `query_strings` to specify the snoop arguments but we could also place them in the body of the request as JSON.  This requires setting a `Content-Type` header...

```json
      "path": "channels/ast-12345678.0/snoop/snoop-channel1"
      "headers": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ],
      "message_body": "{ \"spy\": \"both\", \"whisper\": \"none\", \"app\": \"Record\", \"appArgs\": \"myfile.wav,5,60,q\" }"
```

We used JSON in the message body but an x-www-form-urlencoded string also works.  Since `Content-Type` is a common header, you can specify `content_type` directly instead of in a `headers` array. Don't forget to urlencode the string if it contains a character from the following set `[?&=% ]`.  This example is fine as is...

```json
      "path": "channels/ast-12345678.0/snoop/snoop-channel1"
      "content_type": "application/x-www-form-urlencoded",
      "message_body": "spy=both&whisper=none&app=Record&appArgs=myfile.wav,5,60,q"
```

Server responds with:

```json
{
  "type": "RESTResponseMsg",
  "identity": "d1eb679c-166f-4278-8b28-0340088a3410",
  "responses": [
    {
      "uuid": "1e409d15-a35e-4946-b270-c460cc45b2c4",
      "status_code": 204,
      "reason_phrase": "No Content",
      "path": "channels/ast-12345678.0/snoop/snoop-channel1"
    }
  ],
  "timestamp": "2025-03-17T08:32:39.709-0600",
  "asterisk_id": "e4:1d:2d:b8:3b:a0",
  "application": "mystasisapp"
}
```

That's all there is to it.

## Caveats

There's really only one...  You can't get binary data like recordings via the websocket.  The frames written to the underlying websocket use the TEXT opcode and the messages are all JSON and while there are ways we could send binary data, they're just too complicated and could interfere with getting asynchronous events.  Attempting to retrieve binary data will result in a 406 "Not Acceptable. Use HTTP GET" response.

## Differences between SwaggerSocket and ASTSwaggerSocket

To fit within the existing ARI archictecture several modifications had to be made to the SwaggerSocket API:

* Requests must include a `type` parameter to allow the request to be routed properly.
* SwaggerSocket uses "camelCase" for protocol parameter names but ARI requires parameter names to be "snake_case".
* Responses are encapsulated in ARI events which will include the `type`, `timestamp`, `asterisk_id` and `application` parameters.
* Although the SwaggerSocket protocol supports more than one request in a message, ASTSwaggerSocket will only process the first request in the array.
* SwaggerSocket's `statusCode` parameter is renamed to `status_code` to comply with the "snake_case" ARI requirement and it's also a JSON number rather than a string.  `reasonPhrase` is also renamed to `reason_phrase`.
