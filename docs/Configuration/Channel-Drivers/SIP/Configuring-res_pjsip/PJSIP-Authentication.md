# PJSIP Authentication

With the release of Asterisk 20.12.0, 21.7.0 and 22.2.0 and the associated release of PJProject 2.15.1, the chan_pjsip channel driver now supports the SHA-256 and SHA-512-256 authentication digest hash algorithms in addition to the base MD5 algorithm.

/// note | Supported Digest Hash Algorithms
While the MD5 algorithm is universally supported, support for SHA-256 and SHA-512-256 is dependent on both the PJProject and OpenSSL versions installed on both the build and runtime systems.  PJProject 2.15.1 (which is the version bundled with Asterisk 20.12.0, 21.7.0 and 22.2.0) is required to support both SHA algorithms.  OpenSSL version > 1.0.0 is required to support SHA-256 and OpenSSL version >= 1.1.1 is required to support SHA-512-256.

On a running Asterisk system, you can execute the CLI command `pjproject show buildopts` to see the currently supported algorithms.
///

## Authentication Process Refresher

We'll use 2 Asterisk systems as the UAS and UAC.

* When a PJSIP endpoint acting as a UAS receives a SIP request that requires authentication, Asterisk looks at the endpoint's `auth` parameter which should point to an auth object with the required credentials.  It then creates one or more `WWW-Authenticate` headers containing the realm from the auth object, a nonce, and a digest hash algorithm name and sends them to the UAC in a 401 response.  If more than one digest hash algorithm were supported, a header would be sent for each. Historically though, Asterisk only supported the MD5 algorithm so only one `WWW-Authenticate` header would be sent.

* The UAC receives the 401 response and looks for an auth object listed in the outgoing endpoint's `outbound_auth` parameter that has a realm that matches the realm in the response (or an object with no realm or a realm of `*`) and that can support the digest hash algorithm in the response. Again, only the MD5 algorithm was historically supported.  It then constructs an `Authorization` header with, among other things, a `digest` parameter which contains the result of passing a string containing `<username>:<realm>:<password>` through the requested digest hash algorithm (the calculation is actually a bit more complicated than that but we don't need to worry about that here). The request is then retried with the `Authorization` header added.

* When the UAS receives the new request with the `Authorization` header, it constructs its own `<username>:<realm>:<password>` string using the values from its own auth object and passes that through the digest hash algorithm.  If the resulting value matches the digest received in the `Authorzation` header, request processing continues.  If not, another 401 response is sent.

Most of the time, passwords are specified in the configuration as plain-text.  You can however also supply them "pre-hashed".  This involves you manually passing a string composed of `<username>:<realm>:<password>` through a digest hash algorithm.  For example:

```bash
$ echo -n "myuser:asterisk:somepassword" | openssl dgst -md5
MD5(stdin)= 1650345a24d9b5fdbc9c28e1f2321387
```

The resulting value would then be used in the configuration.  This is somewhat more secure because the password isn't stored in plain-text but if you're acting as a UAC, it requires that you know in advance the realm the UAS will be sending. See description for the [realm](#realm) parameter below for more information.

## Configuration Changes Required to Support the New Algorithms

Supporting more than one digest algorithm required changes to the PJSIP auth object configuration parameters.  Some new ones were needed and some existing ones had to be changed (although they retain backwards compatibility).

### Changed Parameters

#### auth_type

* **Valid values** 
    * **digest** - Standard [RFC 7616 HTTP/SIP digest authentication](https://datatracker.ietf.org/doc/html/rfc7616) whether using plain-text or pre-hashed passwords.
     * **google_oauth** - Google OAuth authentication used by Google Voice.
* **Deprecated values**
    * **userpass** - This previously meant "plain-text password" but that is now determined automatically.  If this value is used, it'll automatically be converted to "digest".
    * **md5** - This previously meant "pre-hashed MD5 password" but that is now also determined automatically.  If this value is used, it'll automatically be converted to "digest".

#### md5_cred

Deprecated.  Will be converted to a `password_digest` parameter with an MD5 digest hash algorithm.  See [password_digest](#password_digest) below.

### Unchanged Parameters

#### realm

No change.  For incoming authentication (Asterisk is the UAS), this is the realm to be sent on `WWW-Authenticate` headers.  If not specified, the global object's `default_realm` will be used.  `asterisk` is the final default if neither is specified.

For outgoing authentication (Asterisk is the UAC), this should be left empty, set to `*` or not specified at all unless you know the exact realm the UAS will be sending in the `WWW-Authenticate` headers.

/// warning | Realms & Using the same auth object for both UAS and UAC situations
Although rare, some scenarios require that an endpoint configuration both send and respond to authentication challenges at the same time.  In this case, you may be tempted to specify the same auth object in the endpoint's `auth` (UAS, send challenges (`WWW-Authenticate` headers) in a 401 SIP response) parameter and its `outbound_auth` (UAC, send challenge responses (`Authorization` headers) in a SIP request) parameter.  This generally isn't good idea because when sending challenges as a UAS, you need to configure a specific realm in the auth object (or in the global `default_realm` parameter) to be placed in the `WWW-Authenticate` header.  If you use this same auth object as a UAC however, it can only send challenge responses to a UAS that specified the same realm.  Normally, when acting as a UAC, you'll want to leave the auth object's realm empty or set to `*` so it can be used to handle any realm sent by the remote UAS.

So, unless you know in advance the exact realm a UAS will send in challenges AND it's the same realm you want to use when you're sending challenges as a UAS, create two separate auth objects. for the endpoint.
///


#### username

No change.  Username to use for account.

#### password

No change. A plain-text password.

#### nonce_lifetime

No change.  Lifetime in seconds of a nonce associated with this authentication config (default: "32")  See [RFC 7616](https://datatracker.ietf.org/doc/html/rfc7616) for more information on nonces.

#### refresh_token

No change. OAuth 2.0 refresh token

#### oauth_clientid

No change.  OAuth 2.0 application's client id

#### oauth_secret

No change. OAuth 2.0 application's secret

### New Parameters

#### password_digest

This replaces the `md5_cred` parameter and provides the same capability of providing pre-hashed credentials for the SHA-256 and SHA-512-256 digest algorithms.  The format is as follows:

```
password_digest = <digest-spec>
  <digest_spec>: <digest-hash-algorithm>:<hashed-credential>
    <digest-hash-algorithm>: One of the 3 supported algorithms: MD5, SHA-256, SHA-512-256
    <hashed-credential>: The result of passing a string composed of <username>:<realm>:<password>
                         through the algorithm.
```

Examples:

```bash
$ echo -n "myuser:somedomain:somepassword" | openssl dgst -md5
MD5(stdin)= 1650345a24d9b5fdbc9c28e1f2321387
# You'd then specify password_digest = MD5:1650345a24d9b5fdbc9c28e1f2321387

$ echo -n "myuser:somedomain:somepassword" | openssl dgst -SHA-256
SHA2-256(stdin)= e8789f45d84aac27977eed41f3eec7572bb8ee81c6398715a04a51a7f9c68122
# You'd then specify password_digest = SHA-256:e8789f45d84aac27977eed41f3eec7572bb8ee81c6398715a04a51a7f9c68122

$ echo -n "myuser:somedomain:somepassword" | openssl dgst -SHA512-256
SHA2-512/256(stdin)= f8c3d34ce5ae6550740eaed0bff78a8aed354e87f2364813e4dbe9624bf06570
# You'd then specify password_digest = SHA-512-256:f8c3d34ce5ae6550740eaed0bff78a8aed354e87f2364813e4dbe9624bf06570
```

You can specify multiple `password_digest` parameters in an auth object but no more than one for each digest hash algorithm.

/// note | Line Endings
Note that the examples show using the `-n` parameter in the `echo` command.  This tells `echo` to not output any line endings after printing the string.  This is important because you don't want those line endings included in the hash calculation.
///

/// warning | Algorithm Names
Asterisk uses the **case-insensitive** digest hash algorithm names as registered in the IANA by [RFC7616](https://datatracker.ietf.org/doc/html/rfc7616): `MD5`, `SHA-256`, `SHA-512-256` or their lower-case equivalents.  OpenSSL digests aren't always referenced by the same names.  For example, the IANA uses `SHA-512-256` but OpenSSL only recognizes `SHA512-256` (without the first dash) and `sha512-256` (without the first dash and lower case).  Make sure you use the IANA names exactly as registered for all Asterisk configuration.
///

#### supported_algorithms_uas

A comma-separated list of digest hash algorithm names to use when creating challenges in a 401 response.  A separate `WWW-Authenticate` header will be added to the response for each algorithm, in the order specified.  Order is important as, according to [RFC7616](https://datatracker.ietf.org/doc/html/rfc7616), the UAS _MUST_ order the `WWW-Authenticate` headers in order of most-preferred to least-preferred and the UAC _SHOULD_ respond to the first challenge it supports.

If this parameter isn't specified, the value of the global object's `default_auth_algorithms_uas` parameter will be used.  `MD5` is the final default if neither is specified.  This preserves backwards compatibility.

Example:

```
supported_algorithms_uas = SHA-256, MD5
```

#### supported_algorithms_uac

A comma-separated list of digest hash algorithm names to allow when creating an `Authorization` header for a request that previously failed with a 401 response.  Only algorithms listed here will be considered for use so if the UAS responds with challenges for SHA-256 and SHA-512-256 and only MD5 is specified in this parameter, an `Authorization` header will not be created and the request will likely fail again.  Order isn't important here as the UAS sets the preferred order.

If this parameter isn't specified, the value of the global object's `default_auth_algorithms_uac` parameter will be used.  `MD5` is the final default if neither is specified.  This preserves backwards compatibility.

Example:

```
supported_algorithms_uac = SHA-256, MD5, SHA-512-256
```

/// warning | Using `password` and `password_digest`
Asterisk can only create challenges and challenge-responses if it has access to either the plain-text `password` parameter or a `password_digest` parameter that matches the digest hash algorithm desired.  For instance, if your auth object only has a `password_digest` parameter for the MD5 algorithm and no plain-text `password` parameter but you specify `SHA-256` in either `supported_algorithms_uas` or `supported_algorithms_uac`, the configuration will fail to load and error messages will be printed.  It's not possible for _any_ software to construct a valid hash for one algorithm using a hash created by another algorithm.  You either have to provide a `password_digest` parameter that matches each algorithm listed in your `supported_algorithms_uas` and `supported_algorithms_uac` parameters OR provide a plain-text `password` parameter from which Asterisk can create the hash value.  You _can_ provide both `password` and `password_digest` however.  A matching `password_digest` will be preferred but if not found, the `password` will be used as a fallback.
///

## Examples

### Typical Endpoint-to-Phone Scenario

```text
[somephone-auth]
type = auth
auth_type = digest
realm = myrealm
username = myuser
password = my-plain-text-password
supported_algorithms_uas = SHA-256, MD5

[somephone]
type = endpoint
auth = somephone-auth
```

In this example, the endpoint is configured as it would be to connect to a remote phone. When Asterisk needs to send a 401 response (to an incoming INVITE for example), it will create the response with two `WWW-Authenticate` headers, the first with SHA-256 as the digest algorithm and the second with MD5.  The phone would then retry the request with a single `Authorization` header using the first of the two digest algorithms it supported.

### Alternate Endpoint-to-Phone Scenario

```text
[somephone-auth]
type = auth
auth_type = digest
realm = myrealm
username = myuser
password_digest = MD5:c3cffc6ef6f7c002a51d7f3fe2695ab4
password_digest = SHA-256:c3cffc6ef6f7c002a51d7f3fe2695ab4
password_digest = SHA-512-256:9468f16f3e37ac9c6e572e34533015e26d8b7b0b23a9f5953bd4be63a258ca60
supported_algorithms_uas = SHA-256, SHA-512-256, MD5

[somephone]
type = endpoint
auth = somephone-auth
```

In this example, the endpoint is configured as it would be to connect to a remote phone. When Asterisk needs to send a 401 response (to an incoming INVITE for example), it will create the response with three `WWW-Authenticate` headers, with the SHA-256, SHA-512-256 and MD5 digest algorithms in that order.  The phone would then retry the request with a single `Authorization` header using the first of the three digest algorithms it supported. This keeps the plain-text password out of the configuration but it does require that the username and realm used when creating the pre-hashed credentials for the `password_digest` parameters be the exact same ones specified in the `username` and `realm` parameters in the auth object.  The `realm` parameter in the auth object is used to set the `realm` parameter in the `WWW-Authenticate` header and that's what the phone will use when creating is's own digest to send back.

### Legacy Endpoint-to-Phone Scenario

```text
[somephone-auth]
type = auth
auth_type = userpass
realm = myrealm
username = myuser
password = my-plain-text-password

[somephone]
type = endpoint
auth = somephone-auth
```

This scenario uses the legacy configuration parameters and is functionally equivalent to the [Typical Endpoint-to-Phone Scenario](#typical-endpoint-to-phone-scenario).

### Typical Endpoint-to-Provider Scenario

```text
[someprovider-auth]
type = auth
auth_type = digest
realm = * ; this is optional as the default for a UAC is '*' anyway.
username = myuser
password = my-plain-text-password
supported_algorithms_uac = MD5

[myendpoint]
type = endpoint
outbound_auth = myauth
```

In this example, the endpoint is configured as it would be to connect to a service provider that requires authentication.  If the service provider responds to a request with a 401 that contains two `WWW-Authenticate` headers, the first with SHA-256 as the digest algorithm and the second with MD5, Asterisk would retry the request with an `Authorization` header for MD5 because even though the service provider preferred SHA-256, the auth object only supports MD5.

### Alternate Endpoint-to-Provider Scenario

```text
[someprovider-auth]
type = auth
auth_type = digest
realm = * ; this is optional as the default for a UAC is '*' anyway.
username = myuser
password_digest = MD5:c3cffc6ef6f7c002a51d7f3fe2695ab4
password = my-plain-text-password
supported_algorithms_uac = MD5, SHA-256

[myendpoint]
type = endpoint
outbound_auth = myauth
```

In this example, the endpoint is configured as it would be to connect to a service provider that requires authentication.  If the service provider responds to a request with a 401 that contains two `WWW-Authenticate` headers, the first with SHA-256 as the digest algorithm and the second with MD5, Asterisk would retry the request with an `Authorization` header for SHA-256 because it's the algorithm the service provider preferred and there's a plain-text password available that can be used to create the necessary digest.  If the service provider had responded with MD5 first and SHA-256 second, Asterisk would have responded with MD5 using the pre-hashed credentials.  HOWEVER!!  For this to work, the Asterisk admin would have to know ahead of time the realm the service provider would specify in the `WWW-Authenticate` headers. You can't create a pre-hashed credential with an empty or wildcard `*` realm.

### Legacy Endpoint-to-Provider Scenario

```text
[someprovider-auth]
type = auth
auth_type = md5
realm = * ; this is optional as the default for a UAC is '*' anyway.
username = myuser
md5_cred = c3cffc6ef6f7c002a51d7f3fe2695ab4

[myendpoint]
type = endpoint
outbound_auth = myauth
```

This scenario is _almost_ functionally equivalent to the [Alternate Endpoint-to-Provider Scenario](#alternate-endpoint-to-provider-scenario).  While it supports MD5 pre-hased credentials, it can't support SHA-256 at all.
