---
search:
  boost: 0.5
title: res_stir_shaken
---

# res_stir_shaken: STIR/SHAKEN module for Asterisk

This configuration documentation is for functionality provided by res_stir_shaken.

## Configuration File: stir_shaken.conf

### [general]: STIR/SHAKEN general options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| ca_file| Custom| | false| File path to the certificate authority certificate| |
| ca_path| Custom| | false| File path to a chain of trust| |
| cache_max_size| Unsigned Integer| 1000| false| Maximum size to use for caching public keys| |
| curl_timeout| Unsigned Integer| 2| false| Maximum time to wait to CURL certificates| |
| signature_timeout| Unsigned Integer| 15| false| Amount of time a signature is valid for| |
| type| None| | false| Must be of type 'general'.| |


### [store]: STIR/SHAKEN certificate store options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| path| Custom| | false| Path to a directory containing certificates| |
| [public_cert_url](#public_cert_url)| Custom| | false| URL to the public certificate(s)| |
| type| None| | false| Must be of type 'store'.| |


#### Configuration Option Descriptions

##### public_cert_url

Must be a valid http, or https, URL. The URL must also contain the $\{CERTIFICATE\} variable, which is used for public key name substitution. For example: http://mycompany.com/$\{CERTIFICATE\}.pub<br>


### [certificate]: STIR/SHAKEN certificate options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| attestation| Custom| | false| Attestation level| |
| caller_id_number| String| | false| The caller ID number to match on.| |
| path| Custom| | false| File path to a certificate| |
| [public_cert_url](#public_cert_url)| Custom| | false| URL to the public certificate| |
| type| None| | false| Must be of type 'certificate'.| |


#### Configuration Option Descriptions

##### public_cert_url

Must be a valid http, or https, URL.<br>


### [profile]: STIR/SHAKEN profile configuration options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| acllist| Custom| | false| An existing ACL from acl.conf to use| |
| deny| Custom| | false| An IP or subnet to deny| |
| permit| Custom| | false| An IP or subnet to permit| |
| [stir_shaken](#stir_shaken)| Custom| on| false| STIR/SHAKEN configuration settings| |
| type| None| | false| Must be of type 'profile'.| |


#### Configuration Option Descriptions

##### stir_shaken

Attest, verify, or do both STIR/SHAKEN operations. On incoming INVITEs, the Identity header will be checked for validity. On outgoing INVITEs, an Identity header will be added.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 