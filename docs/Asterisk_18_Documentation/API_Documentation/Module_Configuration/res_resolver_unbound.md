---
search:
  boost: 0.5
title: res_resolver_unbound
---

# res_resolver_unbound

This configuration documentation is for functionality provided by res_resolver_unbound.

## Configuration File: resolver_unbound.conf

### [general]: General options for res_resolver_unbound

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [debug](#debug)| Unsigned Integer| 0| false| Unbound debug level| |
| [hosts](#hosts)| String| system| false| Full path to an optional hosts file| |
| [nameserver](#nameserver)| Custom| | false| Nameserver to use for queries| |
| [resolv](#resolv)| String| system| false| Full path to an optional resolv.conf file| |
| [ta_file](#ta_file)| String| | false| Trust anchor file| |


#### Configuration Option Descriptions

##### debug

The debugging level for the unbound resolver. While there is no explicit range generally the higher the number the more debug is output.<br>


##### hosts

Hosts specified in a hosts file will be resolved within the resolver itself. If a value of system is provided the system-specific file will be used.<br>


##### nameserver

An explicit nameserver can be specified which is used for resolving queries. If multiple nameserver lines are specified the first will be the primary with failover occurring, in order, to the other nameservers as backups. If provided alongside a resolv.conf file the nameservers explicitly specified will be used before all others.<br>


##### resolv

The resolv.conf file specifies the nameservers to contact when resolving queries. If a value of system is provided the system-specific file will be used. If provided alongside explicit nameservers the nameservers contained within the resolv.conf file will be used after all others.<br>


##### ta_file

Full path to a file with DS and DNSKEY records in zone file format. This file is provided to unbound and is used as a source for trust anchors.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 