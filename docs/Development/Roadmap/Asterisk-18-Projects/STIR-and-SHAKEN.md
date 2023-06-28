---
title: STIR and SHAKEN
pageid: 44370563
---




!!! warning 
    STIR/Shaken from a technical perspective has improved quite a lot, so much so that some companies have been able to do interop and it does work. The problematic area is really the foundational aspects and policy side of things. It's one thing to say "oh you use private key to sign some stuff" but who issues such things? Who actually does the work of signing and verifying? Are the certificates short lived ephemeral ones? Do you have to use a proprietary API to some upstream to manage things? There's still lots to flesh out there by the industry and governments.

      
[//]: # (end-warning)



Welcome to the party!
---------------------

Welcome to a page about making callerid non-fictional in an effort to stop robocallers! Will it actually work out in the end? Who knows, but hey have a design for implementing such a thing in Asterisk! This design was done in such a way as to allow drop-in to all currently supported versions of Asterisk that use PJSIP. It is also flexible in that we could add different ways to manage certificates since that may be an unknown at this point.

The design is broken down into two modules:

1. res_stir_shaken
2. res_pjsip_stir_shaken

Background
----------

Before we dive into things how about a bit of a TLDR on STIR/SHAKEN? From a purely technical perspective STIR/SHAKEN is actually fairly simple. It is based around a phone number (or a block of numbers) having a certificate that conveys that you have permission to use it. This certificate is comprised of a private and public key. As the name says the private one only you have while the public one is handed out and made available. When you go to use a phone number for callerid you construct a payload that conveys what you're doing (I am X calling Y on this date at this time) and sign it using your private key. The receiver can then look at this payload and signature and use your public key (after retrieving it from the URL provided with the payload) to verify that it is you who made the payload - thus giving trust that you have permission. Once this is done the receiver can then examine the call to see if the data matches (your call said you are X, your payload said you are X). It's then up to local policy as to what to do with the information. To be effective, though, everyone has to buy into this system and use it. Receiving a call without the information has to become abnormal or non-existent so that you don't have to let calls through regardless.

Implementation
==============




!!! note 
    If you're actually planning to work on this here's some handy links!

    <https://tools.ietf.org/html/rfc8224>

    <https://tools.ietf.org/html/rfc8225>

    <https://tools.ietf.org/html/rfc8226>

    <https://datatracker.ietf.org/doc/draft-ietf-stir-cert-delegation/>

    <http://nanc-chair.org/docs/mtg_docs/May_18_Call_Authentication_Trust_Anchor_NANC_Final_Report.pdf>

    <https://transnexus.com/whitepapers/understanding-stir-shaken/>

    <https://www.telecompaper.com/news/atis-picks-iconectiv-as-policy-administrator-of-shakenstir-framework--1295009>

      
[//]: # (end-note)



 

res_stir_shaken
-----------------

The res_stir_shaken module is responsible for certificate management, signing, verification, and information exposure. It's generic in the sense that protocol specific users need to be written to actually use the information. It is architected as such:

### Configuration

Configuration is done using a stir_shaken.conf configuration file. Due to the amount of state required it is implemented using ACO. If we truly feel we need realtime in some way we could use sorcery but it doesn't seem reasonable to allow what most people would consider realtime (looking up at use time). This module will support reload so if things change on disk or in configuration, it can be reloaded by using a reload command.

 

As STIR/SHAKEN requires retrieving and using a public key it is advantageous to keep a cache of public keys to minimize call handling time. This is configured in the "general" section. The certificate authority information is also configured here.




---

  
  


```

[general]
ca_file=/etc/stir/theca.crt
ca_path=/etc/stir/ca
cache_max_size=1000

```


 

Individual certificates can be configured using the "certificate" type.




---

  
  


```

[jcolp]
type=certificate
path=/etc/stir/jcolp.crt
public_key_url=http://joshua-colp.com/jcolp.crt

```


 

A group of certificates can be configured using the "store" type.




---

  
  


```

[certificates]
type=store
path=/etc/stir
public_key_url=http://joshua-colp.com/${CERTIFICATE}.crt

```


If the "store" type is used then all certificates in the directory will be examined and loaded. The public key URL is generated based on the filename and variable substitution.

 

In both cases the certificate is examined to determine what phone numbers or SIP URIs it is applicable to and this is then stored away in state information. Note that a certificate may not have any phone numbers or SIP URIs associated with it, but can still be used for signing. This merely conveys where the call came from - not that there is permission to use the phone number for callerid.

The use of "type" is deliberate so that this could be extended to allow other methods of retrieving certificates or even potentially signing, such as relying on a REST API to generate short lived certificates.

### Structures

The APIs provided by the module will expose a structure to provide payload information.




---

  
  


```

struct ast_stir_shaken_payload {
 /\* This is actually a JWT (JSON Web Token) so this may need to change, but for this page it'll do \*/

 /\*! The JWT header \*/
 struct ast_json \*header;
 /\*! The JWT payload \*/
 struct ast_json \*payload;
 /\*! Signature for the payload \*/
 char \*signature;
 /\*! The algorithm used \*/
 char \*algorithm;
 /\*! The URL to the public key for the certificate \*/
 char \*public_key_url;
};

/\*!
 \* \brief Free a STIR/SHAKEN payload
 \*/
void ast_stir_shaken_payload_free(struct ast_stir_shaken_payload \*payload);

```


The structure could be made opaque with accessors if we desired.

### Signing

The module will expose a single API call that can be used to sign a payload.




---

  
  


```

/\*!
 \* \brief Sign a JSON STIR/SHAKEN payload
 \*
 \* \note This function will automatically add the "attest", "iat", and "origid" fields.
 \*/
struct ast_stir_shaken_payload \*ast_stir_shaken_sign(struct ast_json \*json);

```


The API call will:

1. Ensure JSON has been passed in and passes minimal requirements
2. Examine the JSON to find the appropriate certificate
3. Iterate through state to find an appropriate certificate
4. If no certificate is available then the function will return NULL
5. Sign the payload using the available certificate
6. The function will construct an ast_stir_shaken_payload and return it

### Verifying

The module will expose a single API call that can be used to verify a payload.




---

  
  


```

/\*!
 \* \brief Verify a JSON STIR/SHAKEN payload
 \*/
struct ast_stir_shaken_payload \*ast_stir_shaken_verify(const char \*header, const char \*payload, const char \*signature, const char \*algorithm, const char \*public_key_url);

```


The API call will:

1. Ensure all the required fields are non-empty
2. Retrieve the given public key from the local cache if available or from the given URL
3. If the public key is not available then the function will return early with NULL
4. Verify the payload using the signature and public key, ensuring chain of trust
5. If verification or chain of trust fails then the function will return early with NULL
6. The function will construct an ast_stir_shaken_payload and return it

### Dialplan Function

A dialplan function will be made available to examine STIR/SHAKEN verification and attestation results.




---

  
  


```

/\*!
 \* \brief STIR/SHAKEN verification results
 \*/
enum ast_stir_shaken_verification_result {
 AST_STIR_SHAKEN_VERIFY_NOT_PRESENT, /\*! No STIR/SHAKEN information was available \*/
 AST_STIR_SHAKEN_VERIFY_SIGNATURE_FAILED, /\*! Signature verification failed \*/
 AST_STIR_SHAKEN_VERIFY_MISMATCH, /\*!< Contents of the signaling and the STIR/SHAKEN payload did not match \*/
 AST_STIR_SHAKEN_VERIFY_PASSED, /\*! Signature verified and contents match signaling \*/
};

/\*!
 \* \brief Add a STIR/SHAKEN verification result to a channel
 \*/
int ast_stir_shaken_add_verification(struct ast_channel \*chan, const char \*identity, const char \*attestation, enum ast_stir_shaken_verification_result result);

```


The API call will use a datastore to place STIR/SHAKEN verify results on the channel for usage in the dialplan.




---

  
  


```

exten => s,1,NoOp(Number of STIR/SHAKEN identities: ${STIR_SHAKEN(count)})
exten => s,n,NoOp(First STIR/SHAKEN identity: ${STIR_SHAKEN(0,identity)})
exten => s,n,NoOp(First STIR/SHAKEN attestation: ${STIR_SHAKEN(0,attestation)})
exten => s,n,NoOp(First STIR/SHAKEN verify result: ${STIR_SHAKEN(0,verify_result)})

```


In the dialplan the STIR/SHAKEN identities can then be iterated or examine and based on that the user can choose what to do.

res_pjsip_stir_shaken
------------------------

The res_pjsip_stir_shaken module acts as the boundary between SIP and the core of STIR/SHAKEN. It implements the SIP side of things and does not care about certificate storage or signing and is effectively stateless. It acts on messages as they enter and leave the system. It will do this by adding a session supplement that is only invoked on INVITE requests.

### Inbound INVITE

1. Examine message for Identity header - if not present then call ast_stir_shaken_add_verification to add an AST_STIR_SHAKEN_VERIFY_NOT_PRESENT result based on the callerid as the identity
2. Parse the Identity header to get the header, payload, signature, algorithm, and public key URL
3. Invoke ast_stir_shaken_verify with parsed values
4. If ast_stir_shaken_verify returns NULL then call ast_stir_shaken_add_verification to add an AST_STIR_SHAKEN_VERIFY_SIGNATURE_FAILED result based on the callerid as the identity
5. Examine the STIR/SHAKEN payload and compare it against the attributes of the SIP signaling to ensure it matches
6. If the payload doesn't match then call ast_stir_shaken_add_verification to add an AST_STIR_SHAKEN_VERIFY_MISMATCH result based on the callerid as the identity
7. Call ast_stir_shaken_add_verification to add an AST_STIR_SHAKEN_VERIFY_PASSED result based on the callerid as the identity

### Outbound INVITE

1. Retrieve the callerid from the INVITE
2. Construct a JSON payload using the callerid and other attributes of the SIP INVITE (such as dialed number)
3. Call ast_stir_shaken_sign with JSON payload
4. If ast_stir_shaken_sign returns NULL then do not add an Identity header and return early
5. Base64 encode the STIR/SHAKEN payload according to spec and add Identity header to SIP INVITE

### Configuration

The only configuration that will exist will be an extended sorcery attribute on the PJSIP endpoint, in the form of "@stir". If set to "no" (the default) then none of this is done. If set to "yes" then inbound and outbound would be done.

Testing
=======

res_stir_shaken
-----------------

Unfortunately this module requires configuration as well as HTTP access which makes it difficult to test from a self contained perspective. It may be possible to test this from a unit test perspective if the unit test is written inside the module and also if the Asterisk HTTP server is running. A specific configuration can be used for certificates and the public key URL could point to localhost. The API could then be used by having it sign using the certificate, and then verify against itself.

res_pjsip_stir_shaken
------------------------

The testsuite is the best choice of action for testing this module. Using 2 Asterisk instances, certificates for each, and the Asterisk HTTP server we could place calls between them under various conditions and examine the result in dialplan - raising different user events to indicate success or failure.

