---
search:
  boost: 0.5
title: res_stir_shaken
---

# res_stir_shaken: STIR/SHAKEN module for Asterisk

This configuration documentation is for functionality provided by res_stir_shaken.

## Configuration File: stir_shaken.conf

### [attestation]: STIR/SHAKEN attestation options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| attest_level| Custom| not_set| false| Attestation level| |
| check_tn_cert_public_url| Custom| no| false| On load, Retrieve all TN's certificates and validate their dates| |
| global_disable| Boolean| no| false| Globally disable verification| |
| private_key_file| String| | false| File path to a certificate| |
| [public_cert_url](#public_cert_url)| String| | false| URL to the public certificate| |
| send_mky| Custom| no| false| Send a media key (mky) grant in the attestation for DTLS calls. (not common)| |


#### Configuration Option Descriptions

##### public_cert_url

Must be a valid http, or https, URL.<br>


### [tn]: STIR/SHAKEN TN options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| attest_level| Custom| not_set| false| Attestation level| |
| check_tn_cert_public_url| Custom| not_set| false| On load, Retrieve all TN's certificates and validate their dates| |
| private_key_file| String| | false| File path to a certificate| |
| [public_cert_url](#public_cert_url)| String| | false| URL to the public certificate| |
| send_mky| Custom| not_set| false| Send a media key (mky) grant in the attestation for DTLS calls. (not common)| |
| type| None| | false| Must be of type 'tn'.| |


#### Configuration Option Descriptions

##### public_cert_url

Must be a valid http, or https, URL.<br>


### [verification]: STIR/SHAKEN verification options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [ca_file](#ca_file)| String| | false| Path to a file containing one or more CA certs in PEM format| |
| [ca_path](#ca_path)| String| | false| Path to a directory containing one or more hashed CA certs| |
| cert_cache_dir| String| /var/lib/asterisk/keys/stir_shaken/cache| false| Directory to cache retrieved verification certs| |
| [crl_file](#crl_file)| String| | false| Path to a file containing one or more CRLs in PEM format| |
| [crl_path](#crl_path)| String| | false| Path to a directory containing one or more hashed CRLs| |
| curl_timeout| Unsigned Integer| 2| false| Maximum time to wait to CURL certificates| |
| [failure_action](#failure_action)| Custom| continue| false| The default failure action when not set on a profile| |
| global_disable| Boolean| no| false| Globally disable verification| |
| load_system_certs| Custom| no| false| A boolean indicating whether trusted CA certificates should be loaded from the system| |
| max_cache_entry_age| Unsigned Integer| 3600| false| Number of seconds a cache entry may be behind current time| |
| max_cache_size| Unsigned Integer| 1000| false| Maximum size to use for caching public keys| |
| max_date_header_age| Unsigned Integer| 15| false| Number of seconds a SIP Date header may be behind current time| |
| max_iat_age| Unsigned Integer| 15| false| Number of seconds an iat grant may be behind current time| |
| relax_x5u_path_restrictions| Custom| no| false| Relaxes check for query parameters, user/password, etc. in incoming Identity header x5u URLs.| |
| relax_x5u_port_scheme_restrictions| Custom| no| false| Relaxes check for "https" and port 443 or 8443 in incoming Identity header x5u URLs.| |
| [untrusted_cert_file](#untrusted_cert_file)| String| | false| Path to a file containing one or more untrusted cert in PEM format used to verify CRLs| |
| [untrusted_cert_path](#untrusted_cert_path)| String| | false| Path to a directory containing one or more hashed untrusted certs used to verify CRLs| |
| use_rfc9410_responses| Custom| no| false| RFC9410 uses the STIR protocol on Reason headers instead of the SIP protocol| |
| x5u_acl| Custom| | false| An existing ACL from acl.conf to use when checking hostnames in incoming Identity header x5u URLs.| |
| x5u_deny| Custom| | false| An IP or subnet to deny checking hostnames in incoming Identity header x5u URLs.| |
| x5u_permit| Custom| | false| An IP or subnet to permit when checking hostnames in incoming Identity header x5u URLs.| |


#### Configuration Option Descriptions

##### ca_file

These certs are used to verify the chain of trust for the certificate retrieved from the X5U Identity header parameter. This file must have the root CA certificate, the certificate of the issuer of the X5U certificate, and any intermediate certificates between them.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### ca_path

These certs are used to verify the chain of trust for the certificate retrieved from the X5U Identity header parameter. This file must have the root CA certificate, the certificate of the issuer of the X5U certificate, and any intermediate certificates between them.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual certificates must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### crl_file

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### crl_path

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual CRLs must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### failure_action


* `continue` - If set to 'continue', continue and let the dialplan decide what action to take.<br>

* `reject_request` - If set to 'reject\_request', reject the incoming request with response codes defined in RFC8224.<br>

* `continue_return_reason` - If set to 'return\_reason', continue to the dialplan but add a 'Reason' header to the sender in the next provisional response.<br>

##### untrusted_cert_file

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer. Unfortunately, sometimes the CRLs are signed by a different CA than the certificate being verified. In this case, you may need to provide the untrusted certificate to verify the CRL.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### untrusted_cert_path

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer. Unfortunately, sometimes the CRLs are signed by a different CA than the certificate being verified. In this case, you may need to provide the untrusted certificate to verify the CRL.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual certificates must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


### [profile]: STIR/SHAKEN profile configuration options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| attest_level| Custom| not_set| false| Attestation level| |
| [ca_file](#ca_file)| String| | false| Path to a file containing one or more CA certs in PEM format| |
| [ca_path](#ca_path)| String| | false| Path to a directory containing one or more hashed CA certs| |
| cert_cache_dir| String| | false| Directory to cache retrieved verification certs| |
| check_tn_cert_public_url| Custom| not_set| false| On load, Retrieve all TN's certificates and validate their dates| |
| [crl_file](#crl_file)| String| | false| Path to a file containing one or more CRLs in PEM format| |
| [crl_path](#crl_path)| String| | false| Path to a directory containing one or more hashed CRLs| |
| curl_timeout| Unsigned Integer| 0| false| Maximum time to wait to CURL certificates| |
| [endpoint_behavior](#endpoint_behavior)| Custom| off| false| Actions performed when an endpoint references this profile| |
| [failure_action](#failure_action)| Custom| continue| false| The default failure action when not set on a profile| |
| load_system_certs| Custom| not_set| false| A boolean indicating whether trusted CA certificates should be loaded from the system| |
| max_cache_entry_age| Unsigned Integer| 0| false| Number of seconds a cache entry may be behind current time| |
| max_cache_size| Unsigned Integer| 0| false| Maximum size to use for caching public keys| |
| max_date_header_age| Unsigned Integer| 0| false| Number of seconds a SIP Date header may be behind current time| |
| max_iat_age| Unsigned Integer| 0| false| Number of seconds an iat grant may be behind current time| |
| private_key_file| String| | false| File path to a certificate| |
| [public_cert_url](#public_cert_url)| String| | false| URL to the public certificate| |
| relax_x5u_path_restrictions| Custom| not_set| false| Relaxes check for query parameters, user/password, etc. in incoming Identity header x5u URLs.| |
| relax_x5u_port_scheme_restrictions| Custom| not_set| false| Relaxes check for "https" and port 443 or 8443 in incoming Identity header x5u URLs.| |
| send_mky| Custom| not_set| false| Send a media key (mky) grant in the attestation for DTLS calls. (not common)| |
| type| None| | false| Must be of type 'profile'.| |
| [untrusted_cert_file](#untrusted_cert_file)| String| | false| Path to a file containing one or more untrusted cert in PEM format used to verify CRLs| |
| [untrusted_cert_path](#untrusted_cert_path)| String| | false| Path to a directory containing one or more hashed untrusted certs used to verify CRLs| |
| use_rfc9410_responses| Custom| not_set| false| RFC9410 uses the STIR protocol on Reason headers instead of the SIP protocol| |
| x5u_acl| Custom| | false| An existing ACL from acl.conf to use when checking hostnames in incoming Identity header x5u URLs.| |
| x5u_deny| Custom| | false| An IP or subnet to deny checking hostnames in incoming Identity header x5u URLs.| |
| x5u_permit| Custom| | false| An IP or subnet to permit when checking hostnames in incoming Identity header x5u URLs.| |


#### Configuration Option Descriptions

##### ca_file

These certs are used to verify the chain of trust for the certificate retrieved from the X5U Identity header parameter. This file must have the root CA certificate, the certificate of the issuer of the X5U certificate, and any intermediate certificates between them.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### ca_path

These certs are used to verify the chain of trust for the certificate retrieved from the X5U Identity header parameter. This file must have the root CA certificate, the certificate of the issuer of the X5U certificate, and any intermediate certificates between them.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual certificates must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### crl_file

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### crl_path

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual CRLs must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### endpoint_behavior


* `off` - Don't do any STIR/SHAKEN processing.<br>

* `attest` - Attest on outgoing calls.<br>

* `verify` - Verify incoming calls.<br>

* `on` - Attest outgoing calls and verify incoming calls.<br>

##### failure_action


* `continue` - If set to 'continue', continue and let the dialplan decide what action to take.<br>

* `reject_request` - If set to 'reject\_request', reject the incoming request with response codes defined in RFC8224.<br>

* `continue_return_reason` - If set to 'return\_reason', continue to the dialplan but add a 'Reason' header to the sender in the next provisional response.<br>

##### public_cert_url

Must be a valid http, or https, URL.<br>


##### untrusted_cert_file

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer. Unfortunately, sometimes the CRLs are signed by a different CA than the certificate being verified. In this case, you may need to provide the untrusted certificate to verify the CRL.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>


##### untrusted_cert_path

If you with to check if the certificate in the X5U Identity header parameter has been revoked, you'll need the certificate revocation list generated by the issuer. Unfortunately, sometimes the CRLs are signed by a different CA than the certificate being verified. In this case, you may need to provide the untrusted certificate to verify the CRL.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>

For this option, the individual certificates must be placed in the directory specified and hashed using the 'openssl rehash' command.<br>

See https://docs.asterisk.org/Deployment/STIR-SHAKEN/ for more information.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 