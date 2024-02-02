# STIR-SHAKEN

**DRAFT**

This document refers to the Stir/Shaken Refactor of 1Q2024.
The earlier version was only partially functional and not interoperable with other implementations.

## STIR-SHAKEN Services

There are 2 services associated with STIR-SHAKEN call processing implementations...

### Attest
On an outbound call, attestation is basically you swearing in court what level of responsibility you have over the accuracy of the caller id you're presenting in the outgoing INVITE message, where the level can be one of the following:

* **A**: Full Attestation
    * You are responsible for the origination of the call onto the IP-based service provider voice network.
    * You have a direct authenticated relationship with the customer and can identify the customer.
    * You have established a verified association with the telephone number used for the call.
* **B**: Partial Attestation
    * You are responsible for the origination of the call onto the IP-based service provider voice network.
    * You have a direct authenticated relationship with the customer and can identify the customer.
    * BUT you have NOT established a verified association with the telephone number used for the call.
* **C**: Gateway Attestation
    * You're clueless.  You're just passing the call along.

Attestation is accomplished by adding a SIP "Identity" header to the outgoing INVITE whose contents are signed with a specific private key/certificate which can be traced back to the actual caller id's owning service provider. For most Asterisk installation scenarios, you'd receive such a key/certificate from your upstream service provider when they issue you DID telephone numbers.  Parameters that must be placed in the header include...

* The caller-id, even though it's probably already in the P-Asserted-Identity or From SIP headers.
* The attestation level.
* The date.
* The destination telephone number.
* A URL to the certificate whose private key was used to sign this header.
* The signature that resulted from signing the header with the associated private key.

### Verify
This is the hard part...  When you receive an incoming INVITE containing an Identity header, you can't just automatically trust it.  There are a very specific set of tests that must be executed to determine if the information in that Identity header is valid.  Most of these tests are described in [ATIS-1000074v003](https://access.atis.org/higherlogic/ws/public/download/67436/ATIS-1000074.v003.pdf)
* The certificate URL included in the Identity header must use the https scheme, must not have any query parameters, user/password components, or path parameters. The hostname part of the URL must also NOT resolve to any of the Special-Purpose IP Addresses described in [RFC-6890](https://datatracker.ietf.org/doc/html/rfc6890) which includes the local interface 127.0.0.x and the private networks like 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16.  Don't worry, for testing purposes you can relax these restrictions. :)

* The verifier must retrieve the certificate using the URL referenced in the Identity header.
* The certificate's valid times must encompass the current time.
* The certificate must be traceable back to a certificate authority that is trusted to issue certificates for the telephone number in question.
* The certificate must have a special tnAuthList extension.
* The public key attached to the retrieved certificate must be able to decrypt the signature on the Identity header.  This ensures that that certificate's private key was the one that created the signature.
* The "iat" date parameter in the header must be within a few seconds of "now".
* The SIP Date header must be present and also within a few seconds of "now".
* The caller-id in the Identity header must match the caller-id in the P-Asserted-Identity or From SIP headers.

If any of the checks fail, the specifications say you MUST... *do absolutely nothing*.  You *may* however do one of the following:

* Accept the call and continue as if nothing happened.
* Accept the call but return some data back to the sender with some error information that may be useful to them.  What they do with it is their business.
* Reject the call with very specific 4XX response codes.

## Asterisk Implementation

### Configuration

All configuration is done via the stir_shaken.conf file.  The sample [stir_shaken.conf](stir_shaken.conf) is heavily commented.

There are 4 object types used by the STIR/SHAKEN process...

The "attestation" object sets the parameters for creating an Identity
header which attests to the ownership of the caller id on outgoing
INVITE requests.

One or more "tn" objects that are used to create the outgoing Identity
header.  Each object's "id" is a specific caller-id telephone number
and the object contains the URL to the certificate that was used to
attest to the ownership of the caller-id, the level (A,B,C) of the
attestation you're making, and the private key the asterisk
attestation service will use to sign the Identity header.  When
an outgoing INVITE request is placed, the attestation service will
look up the caller-id in the tn object list and if it's found, use
the information in the object to create the Identity header.

The "verification" object sets the parameters for verification
of the Identity header and caller id on incoming INVITE requests.

One or more "profile" objects that can be associated to channel
driver endpoints (currently only chan_pjsip).  Profiles can set
whether verification, attestation, both or neither should be
performed on requests coming in to this endpoint or requests
going out from this endpoint. Additionally they can override
most of the attestation and verification options to make them
specific to an endpoint.  When Asterisk loads the configs, it
creates "effective profiles" or "eprofiles" on the fly that are
the amalgamation of the attestation, verification and profile.
You can see them in the CLI with "stir_shaken show eprofiles".

NOTE: The "tn" object can be configured to source its data from a
realtime database by configuring sorcery.conf and extconfig.conf.
Both of those files have examples for "stir_tn".  There is also an
Alembic script in the "config" section of contrib/ast-db-manage that
will create the table.  Since there can be only one "verification"
or "attestation" object, and will probably be only a few "profile"
objects, those objects aren't realtime enabled.

#### Attestation

The "attestation" object sets the parameters for creating an Identity
header which attests to the ownership of the caller id on outgoing
INVITE requests.

All parameters except 'global_disable" may be overridden in a "profile"
or "tn" object.

Only one "attestation" object may exist.

Parameters:

##### global_disable
If set, globally disables the attestation service.  No Identity headers
will be added to any outgoing INVITE requests.

Default: no

##### private_key_file
The path to a file containing the private key you received from the
issuing authority.  The file must NOT be group or world readable or
writable so make sure the user the asterisk process is running as is
the owner.

Default: none

##### public_cert_url
The URL to the certificate you received from the issueing authority.
They may give you a URL to use or you may have to host the certificate
yourself and provide your own URL here.

Default: none

WARNING:  Make absolutely sure the file that's made public doesn't
accidentally include the privite key as well as the certificate.
If you set "check_tn_cert_public_url" in the "attestation" section
above, the tn will not be loaded and a "DANGER" message will be output
on the asterisk console if the file does contain a private key.

##### check_tn_cert_public_url
Identity headers in outgoing requests must contain a URL that points
to the certificate used to sign the header.  Setting this parameter
tells Asterisk to actually try to retrieve the certificates indicated
by "public_cert_url" parameters and fail loading that tn if the cert
can't be retrieved or if its 'Not Valid Before" -> 'Not Valid After"
date range doesn't include today.  This is a network intensive process
so use with caution.

Default: no

##### attest_level
The level of the attestation you're making.
One of "A", "B", "C"

Default: none

##### send_mky
If set and an outgoing call uses DTLS, an "mky" Media Key grant will
be added to the Identity header.  Although RFC8224/8225 require this,
not many implementations support it so a remote verification service
may fail to verify the signature.

Default: no

##### Example "attestation" object:

```
[attestation]
global_disable = no
private_key_path = /var/lib/asterisk/keys/stir_shaken/tns/multi-tns-key.pem
public_cert_url = https://example.com/tncerts/multi-tns-cert.pem
attest_level = C
```


#### TN

Each "tn" object contains the parameters needed to create the Identity
header used to attest to the ownership of the caller-id on outgoing
requests.  When an outgoing INVITE request is placed, the attestation
service will look up the caller-id in this list and if it's found, use
the information in the object to create the Identity header.
The private key and certificate needed to sign the Identity header are
usually provided to you by the telephone number issuing authority along
with their certificate authority certificate.  You should give the CA
certificate to any recipients who expect to receive calls from you
although this has probably already been done by the issuing authority.

The "id" of this object MUST be a canonicalized telephone nmumber which
starts with a country code.  The only valid characters are the numbers
0-9, '#' and '*'.

The default values for all of the "tn" parameters come from the "[attestation](#attestation)" and "[profile](#profile)" objects.

Parameters:

##### type (required)
Must be set to "tn"

Default: none

##### private_key_file

See the description under [attestation](#attestation)

##### public_cert_url

See the description and WARNING under [attestation](#attestation)

##### attest_level

See the description under [attestation](#attestation)

##### Example "tn" object:

```
[18005551515]
type = tn
private_key_path = /var/lib/asterisk/keys/stir_shaken/tns/18005551515-key.pem
public_cert_url = https://example.com/tncerts/18005551515-cert.pem
attest_level = C
```
Using all the attestation and profile defaults:

```
[18005551515]
type = tn
```

#### Verification

The "verification" object sets the parameters for verification
of the Identity header on incoming INVITE requests.

All parameters except 'global_disable" may be overridden in a "profile"
object.

Only one "verification" object may exist.

Parameters:

##### global_disable 
If set, globally disables the verification service.

Default: no

##### load_system_certs
If set, loads the system Certificate Authority certificates
(usually located in /etc/pki/CA) into the trust store used to
validate the certificates in incoming requests.  This is not
normally required as service providers will usually provide their
CA certififcate to you separately.

Default: no

##### ca_file 
Path to a single file containing a CA certificate or certificate chain
to be used to validate the certificates in incoming requests.

Default: none

##### ca_path 
Path to a directory containing one or more CA certificates to be used
to validate the certificates in incoming requests.  The files in that
directory must contain only one certificate each and the directory
must be hashed using the OpenSSL 'c_rehash' utility.

Default: none

NOTE:  Both ca_file and ca_path can be specified but at least one
MUST be.

##### crl_file 
Path to a single file containing a CA certificate revocation list
to be used to validate the certificates in incoming requests.

Default: none

##### crl_path 
Path to a directory containing one or more CA certificate revocation
lists to be used to validate the certificates in incoming requests.
The files in that directory must contain only one certificate each and
the directory must be hashed using the OpenSSL 'c_rehash' utility.

Default: none

NOTE:  Neither crl_file nor crl_path are required.

##### cert_cache_dir 
Incoming Identity headers will have a URL pointing to the certificate
used to sign the header.  To prevent us from having to retrieve the
certificate for every request, we maintain a cache of them in the
'cert_cache_dir' specified.  The directory will be checked for
existence and writability at startup.

Default: <astvarlibdir>/keys/stir_shaken/cache

##### curl_timeout 
The number of seconds we'll wait for a response when trying to retrieve
the certificate specified in the incoming Identity header's "x5u"
parameter.

Default: 2

##### max_cache_entry_age 
Maximum age in seconds a certificate in the cache can reach before
re-retrieving it.

Default: 86400 (24 hours per ATIS-1000074)

NOTE: If, when retrieving the URL specified by the "x5u" parameter,
we receive a recognized caching directive in the HTTP response AND that
directive indicates caching for MORE than the value set here, we'll use
that time for the max_cache_entry_age.

##### max_cache_size 
Maximum number of entries the cache can hold.
Not presently implemented.

##### max_iat_age 
The "iat" parameter in the Identity header indicates the time the
sender actually created their attestation. If that is older than the
current time by the number of seconds set here, the request will be
considered "failed".

Default: 15

##### max_date_header_age 
The sender MUST also send a SIP Date header in their request.  If we
receive one that is older than the current time by the number of seconds
set here, the request will be considered "failed".

Default: 15

##### failure_action 
Indicates what will happen to requests that have failed verification.
Must be one of:

- **continue**:
  Continue processing the request.  You can use the STIR_SHAKEN
  dialplan function to determine whether the request passed or failed
  verification and take the action you deem appropriate.

- **reject_request***:
  Reject the request immediately using the SIP response codes
  defined by RFC8224.

- **continue_return_reason**:
  Continue processing the request but, per RFC8224, send a SIP Reason
  header back to the originator in the next provisional response
  indicating the issue according to RFC8224.  You can use the
  STIR_SHAKEN dialplan function to determine whether the request
  passed or failed verification and take the action you deem
  appropriate.

Default: **continue**

NOTE: If you select "continue" or "continue_return_reason", and,
based on the results from the STIR_SHAKEN function, you determine you
want to terminate the call, you can use the PJSIPHangup() dialplan
application to reject the call using a STIR/SHAKEN-specific SIP
response code.

##### use_rfc9410_responses 
If set, when sending Reason headers back to originators, the protocol
header parameter will be set to "STIR" rather than "SIP".  This is a
new protocol defined in RFC9410 and may not be supported by all
participants.

Default: no

##### relax_x5u_port_scheme_restrictions 
If set, the port and scheme restrictions imposed by [ATIS-1000074](https://access.atis.org/higherlogic/ws/public/download/67436/ATIS-1000074.v003.pdf)
section 5.3.1 that require the scheme to be "https" and the port to
be 443 or 8443 are relaxed.  This will allow schemes like "http"
and ports other than the two mentioned to appear in x5u URLs received
in Identity headers.

Default: no

CAUTION: Setting this parameter could have serious security
implications and should only be use for testing.

##### relax_x5u_path_restrictions 
If set, the path restrictions imposed by [ATIS-1000074](https://access.atis.org/higherlogic/ws/public/download/67436/ATIS-1000074.v003.pdf) section 5.3.1
that require the x5u URL to be rejected if it contains a query string,
path parameters, fragment identifier or user/password are relaxed.

Default: no

CAUTION: Setting this parameter could have serious security
implications and should only be use for testing.

##### x5u_permit/x5u_deny 
When set, the IP address of the host in a received Identity header x5u
URL is checked against the acl created by this list of permit/deny
parameters.  If the check fails, the x5u URL will be considered invalid
and verification will fail.  This can prevent an attacker from sending
you a request pretending to be a known originator with a mailcious
certificate URL. (Server-side request forgery (SSRF)).
See acl.conf.sample to see examples of how to specify the permit/deny
parameters.

Default: Per [ATIS-1000074](https://access.atis.org/higherlogic/ws/public/download/67436/ATIS-1000074.v003.pdf) Deny all "Special-Purpose" IP addresses described in [RFC 6890](https://datatracker.ietf.org/doc/html/rfc6890). This includes the loopback addresses 127.0.0.0/8, private use networks such as 10.0.0/8, 172.16.0.0/12 and 192.168.0.0/16, and the link local network 169.254.0.0/16 among others.

CAUTION: Setting this parameter could have serious security implications and should only be use for testing.

##### x5u_acl 
Rather than providing individual permit/deny parameters, you can set
the acllist parameter to an acl list predefined in acl.conf.

Default: none

CAUTION: Setting this parameter could have serious security
implications and should only be use for testing.


##### Example "verification" object:

```
[verification]
global_disable = yes
load_system_certs = no
ca_path = /var/lib/asterisk/keys/stir_shaken/verification_ca
cert_cache_dir = /var/lib/asterisk/keys/stir_shaken/verification_cache
failure_action = reject_request
curl_timeout=5
max_iat_age=60
max_date_header_age=60
max_cache_entry_age = 300
; For internal testing
x5u_deny=0.0.0.0/0.0.0.0
x5u_permit=127.0.0.0/8
x5u_permit=192.168.100.0/24
relax_x5u_port_scheme_restrictions = yes
relax_x5u_path_restrictions = yes
```

#### Profile

A "profile" object can be associated to channel driver endpoint
(currently only chan_pjsip) and can set verification and attestation
parameters specific to endpoints using this profile.  If you have
multiple upstream providers, this is the place to set parameters
specific to them.

The "id" of this object is arbitrary and you'd specify it in the
"stir_shaken_profile" parameter of the endpoint.

Parameters:

##### type
Must be set to "profile"

Default: none

##### endpoint_behhavior
Actions to be performed for endpoints referencing this profile.
Must be one of:

- **off**:
  Don't do any STIR/SHAKEN processing.
- **attest**:
  Attest on outgoing calls.
- **verify**:
  Verify incoming calls.
- **on**:
  Attest outgoing calls and verify incoming calls.

Default: **off**

All of the "[verification](#verification)" parameters defined above can be set on a profile with the exception of 'global_disable'.

All of the "[attestation](#attestation)" parameters defined above can be set on a profile with the exception of 'global_disable'.

When Asterisk loads the configs, it creates "effective profiles" or
"eprofiles" on the fly that are the amalgamation of the attestation,
verification and profile. You can see them in the CLI with
`stir_shaken show eprofiles`.

##### Example "profile" object:

```
[myprofile]
type = profile
endpoint_behavior = verify
failure_action = continue_return_reason
x5u_acl = myacllist
```
In pjsip.conf...

```
[myendpoint]
type = endpoint
...
stir_shaken_profile = myprofile
```

In acl.conf...

```
[myacllist]
permit=0.0.0.0/0.0.0.0
deny=10.24.20.171
```

## Incoming Call Flow

We perform verification on incoming calls.

1. If there's no caller-id present, skip verification and continue the call.
1. If the endpoint receiving the call doesn't have `stir_shaken_profile` set, skip verification and continue the call.
1. If the profile name set in `stir_shaken_profile` doesn't exist, return an error and terminate the call.
1. If the [verification](#verification) `global_disable` flag is true, skip verification and continue the call.
1. If the [profile](#profile) `endpoint_behavior` parameter isn't `verify` or `on`, skip verification and continue the call.

From now on, the action taken on failure is controlled by the `failure_action` parameter in the [profile](#profile) or [verification](#verification) objects. 

1. If there's no Identity header in the SIP request, fail per `failure_action`
1. Parse the Identity header.
1. Check the URL in the "x5u" header parameter against the rules described in [Verify](#verify).
1. Check the "iat" header is within `max_iat_age` from the [profile](#profile) or [verification](#verification).
1. Check the SIP "Date" header is within the `max_date_header_age` from the [profile](#profile) or [verification](#verif
1. Check the local cache to see if we have the certificate already and it's cache expiration isn't in the past.  If we have a good one, skip to the next step.  Otherwise...
    * Retrieve the certificate from the URL.
    * Parse the certificate and public key.
    * Validate the certificate using the CA certificates and certificate revocation lists provided by the `ca_file`, `ca_path`, `crl_file` and `crl_path` parameters provided in the [profile](#profile) or [verification](#verification) objects and against the other rules mentioned in [Verify](#verify).
1. Decode the Identity header using the public key from the certificate.
ication).
1. Retrieve the rest of the parameters from the decoded Identity header.
1. Verify that the caller id presented in the SIP message matches the "tn" parameter in the Identity header.

If there was any failure and the `failure_action` parameter was set to `reject_request`, the request will be terminated with one of the 4XX response codes defined by [RFC-8224](https://www.rfc-editor.org/rfc/rfc8224).

If `failure_action` was set to `continue_return_reason`, the call will be sent to the dialplan as usual but the next progress response to the client will contain a "Reason" header containing the 4XX response code that would have been sent if we were going to fail the call.

If `failure_action` was set to `continue`, the call continues to the dialplan without any further action.

If the call does continue under the last two conditions, the dialplan author can use the STIR_SHAKEN function to determine the verification status.  They can then elect to continue or use the PJSIPHangup() dialplan app to terminate the call with a specific 4XX response code.

## Outgoing Call Flow

Compared to verification, attestation is simple.

1. If there's no caller-id present, skip attestation and continue the call.
1. If the endpoint sending the call doesn't have `stir_shaken_profile` set, skip attestation and continue the call.
1. If the profile name set in `stir_shaken_profile` doesn't exist, skip attestation and continue the call.
1. If the [attestation](#attestation) `global_disable` flag is true, skip attestation and continue the call.
1. If the [profile](#profile) `endpoint_behavior` parameter isn't `attest` or `on`, skip attestation and continue the call.
1. If there's no "tn" object matching the caller-id, skip attestation and continue the call.
1. Finally create and sign the Identity header using the `private_key_file`, `public_cert_url`, `attest_level` and `send_mky` parameters from [tn](#tn), [profile](#profile) or [attestation](#attestation).  If this fails, the call will be terminated.

## References

The best places to become familiar with STIR/SHAKEN itself are:

* [RFC7340 Secure Telephone Identity Problem Statement and Requirements](https://www.rfc-editor.org/rfc/rfc7340.html)
* [RFC7375 Secure Telephone Identity Threat Model](https://www.rfc-editor.org/rfc/rfc7375.html)
* [RFC8224 Authenticated Identity Management in the Session Initiation Protocol (SIP)](https://www.rfc-editor.org/rfc/rfc8224.html)
* [RFC 9060 Secure Telephone Identity Revisited (STIR) Certificate Delegation](https://www.rfc-editor.org/rfc/rfc9060.html)
* [ATIS-1000074v003: Signature-based Handling of Asserted information using toKENs (SHAKEN)](https://access.atis.org/higherlogic/ws/public/download/67436/ATIS-1000074.v003.pdf)

