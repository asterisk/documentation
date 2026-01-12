---
search:
  boost: 0.5
title: STIR_SHAKEN
---

# STIR_SHAKEN()

### Synopsis

Gets the number of STIR/SHAKEN results or a specific STIR/SHAKEN value from a result on the channel.

### Description

This function will either return the number of STIR/SHAKEN identities, or return information on the specified identity. To get the number of identities, just pass 'count' as the only parameter to the function. If you want to get information on a specific STIR/SHAKEN identity, you can get the number of identities and then pass an index as the first parameter and one of the values you would like to retrieve as the second parameter.<br>

``` title="Example: Get count and retrieve value"

same => n,NoOp(Number of STIR/SHAKEN identities: ${STIR_SHAKEN(count)})
same => n,NoOp(Identity ${STIR_SHAKEN(0, identity)} has attestation level ${STIR_SHAKEN(0, attestation)})


```

### Syntax


```

STIR_SHAKEN(index[,value])
```
##### Arguments


* `index` - The index of the STIR/SHAKEN result to get. If only 'count' is passed in, gets the number of STIR/SHAKEN results instead.<br>

* `value` - The value to get from the STIR/SHAKEN result. Only used when an index is passed in (instead of 'count'). Allowable values:<br>

    * `identity`

    * `attestation`

    * `verify_result`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 