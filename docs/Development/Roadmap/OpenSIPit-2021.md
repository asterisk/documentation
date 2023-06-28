---
title: OpenSIPit 2021
pageid: 46432359
---

OpenSIPit 2021 Notes
====================

Stir/Shaken
-----------




!!! info ""
    REMINDER: The Asterisk STIR/SHAKEN work was all done last year before things were finalized and there hasn't been anyone to test with until now so it's nor surprising that we have interoperability issues.

      
[//]: # (end-info)



### George's Notes:

* We need to convert over to X509 certificates instead of EC certificates.
* We need to send the "dest->tn" object in our Identity header.
* We need to send a SIP "Date" header. Example from Liviu:
	+ Wed, 14 Apr 2021 13:17:35 GMT
* We're not filtering bad certificate URLs.  The SipVicious guys were able to send a "file:///dev/random" URL which put Asterisk into a spin loop reading random data and writing it to /var/lib/asterisk/keys/stir_shaken/random.
* We need to clarify and document the 3 types of certificate expiration...
	+ We compare the current time to the timestamp sent in the Identity header and reject if there's more than `signature_timeout` seconds difference.
	+ When we retrieve the certificate using the URL in the Identity header, we compare the HTTP "Cache-Control"  "max-age" parameter or the Expires header to the time we cached the certificate the last time we retrieved it.
	+ OpenSSL looks at the certificate valid date range.
* Right now we fail if there's no "Cache-Control" or "Expires" header in the HTTP response we reject.  That's not good.
* We're using Base64 to encode and decode stuff and we should be using [Base64URL](https://base64.guru/standards/base64url) instead.
* We should be using randomly generated UUID for every request's orgid
* We're saving certs in /var/lib/asterisk/keys/stir_shaken with the same name as in the URL.  For instance: <http://asterisk.opensipit.net/cert.pem> is saved as  /var/lib/asterisk/keys/stir_shaken/cert.pem.  If another request comes in like [http://opensips.opensipit.net/cert.pem,](http://opensips.opensipit.net/cert.pem,)(http://opensips.opensipit.net/cert.pem-) we overwrite Asterisk's cert.pem.  We need to save the cert using the cert's serial number rather than its file name.
* There are some error situations where the RFC says we MUST return a certain response code but we're leaving it to the dialplan author to check and reject and there's currently no way for the dialplan author to send specific SIP response codes.  I suggest we do 2 things...
	+ Create a pjsip dialplan function that can set a specific SIP response code for Hangup() to use.
	+ Split the `stir_shaken` endpoint option to 2 options...
		- `stir_shaken_attest = (yes | no)` to control whether we send an Identity header or not
		- `stir_shaken_verify = ( no | permissive | enforce )` where `permissive` would be the behavior we have today where we leave handling the verification result it up to the dialplan author and where `enforcing` makes res_pjsip_stir_shaken automatically send back the correct response code on failure.
* We need enhance the STIR_SHAKEN dialplan function to add a `verify_result_code` code to get a numeric verification result code instead of the text result message.
* We need to update the documentation for the STIR_SHAKEN function to include the possible result codes and messages.
* When Asterisk is compiled with TEST_FRAMEWORK res_pjsip_stir_shaken doesn't do the check for the timestamp in the Identity header.  It should.

Andreas Granig has a GitHub repo with a ton of Stir/Shaken sipp tests...  <https://github.com/agranig/stirshaken-scenarios>  It currently relies on a patched version of sipp (provided in the repo) but he's working to get the changes merged upstream.  If anything, it's a good reference for what we should test ourselves.

 

RFC8760
-------

### George's Notes:

* Eventually we (and pjproject) need to support the additional authentication digest algorithms defined in [RFC8760](https://www.rfc-editor.org/rfc/rfc8760.html) which include SHA-256 and SHA512-256.
* We are not currently tolerant of RFC8760 compliant UASs that send us multiple WWW-Authenticate headers.  If they send us one using SHA-256 and a second one using MD5, we fail when we see SHA-256 and don't continue to look for more WWW-Authenticate  headers.  I have a patch that at least makes us tolerant.

 

 

 

