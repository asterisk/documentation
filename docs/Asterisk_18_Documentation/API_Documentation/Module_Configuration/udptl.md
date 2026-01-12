---
search:
  boost: 0.5
title: udptl
---

# udptl

This configuration documentation is for functionality provided by udptl.

## Configuration File: udptl.conf

### [global]: Global options for configuring UDPTL

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| t38faxmaxdatagram| Custom| | false| Removed| |
| t38faxudpec| Custom| | false| Removed| |
| udptlchecksums| Boolean| yes| false| Whether to enable or disable UDP checksums on UDPTL traffic| |
| udptlend| Unsigned Integer| 4999| false| The end of the UDPTL port range| |
| udptlfecentries| Unsigned Integer| | false| The number of error correction entries in a UDPTL packet| |
| udptlfecspan| Unsigned Integer| | false| The span over which parity is calculated for FEC in a UDPTL packet| |
| udptlstart| Unsigned Integer| 4000| false| The start of the UDPTL port range| |
| use_even_ports| Boolean| no| false| Whether to only use even-numbered UDPTL ports| |



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 