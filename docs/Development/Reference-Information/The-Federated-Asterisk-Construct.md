---
title: The Federated Asterisk Construct
pageid: 30279846
---




!!! info "Disclaimer"
    This page contains many of the ideas that I've been discussing with unknown user. Bear in mind that currently, much is missing here, so don't expect any actions items to spring from this page in the near future.

      
[//]: # (end-info)



Overview
========

The following set of wiki pages are meant to serve as an idea discussion pad, to bring up various issues and possibilities relating to the idea of creating a federated Asterisk installation. While Asterisk SCF as a wonderful idea as to what federated Asterisk installation should accomplish, its overall installation and integration path eluded from most Asterisk users and platform developers. The general construct should take into consideration the following:

* Rely on existing Asterisk Standard/LTS distribution for the construct.
* Avoid paradigm changes as much as possible. Introduction of new ones is ok, as long as they don't clash with the old.
* Asterisk should be regarded as a building block, not the actual core federation tool.
* Federation should utilize existing componets (realtime, sqlite, ARI, Stasis, etc) as much as possible



What a Federated Asterisk really is?
====================================

Building a large Asterisk system had been known to be somewhat of a shifting target. The mix of required technologies had sprung up various innovations and "alternative" options, while none of the solution truly delved into the actual problem. A truly federated platform should be able to answer the following issues:

* Provide identical services to all users, across the board, regardless of their location and service class
* Provide a means to seamlessly migrate users across the platform, without any need for prior knowledge of the users location
* Provide a means to seamlessly federate multiple Asterisk versions - or in the future, other technologies as well
* Provide a highly robust provisioning mechanism, to allow users be provisioned without geographical or client restrictions
Different approaches to federating Asterisk
===========================================

Full Data and Service Distribution
----------------------------------

This approach dictates the following paradigm:

* Each of the Asterisk servers contain a server data store
* Each of the Asterisk servers contain a service logic
* The service logic is capable of communicating with the local data store and the local Asterisk server
* The data store provides a means of replicating information from one Asterisk server in the federation to the other, without requiring the service logic to interfere
* Routing decision are based upon local decisions, with full federation visibility



| Pros | Cons |
| --- | --- |
| * Fairly simple to implement using legacy Asterisk versions
* Does not require any changes to the Asterisk core
* Can be implemented using Asterisk + AGI/FastAGI + AMI
* Scales at reasonable ease
* Well known maintenance and operational paradigms
* Based on bullet proof, battle tested technologies
 | * Complex to maintain and support when the system scales beyond a certain
* Contains too many moving parts (Data Store, AGI Server, AMI Server, etc)
* Relies mostly on hacking the solution, rather than an architectural approachto doing things
* Requires in-depth understanding of the surrounding tools (Redis, Memcache,MySQL, Python, etc)
* **Cool factor: low and boring!**
 |



Partial Data Distribution with Full Service Distribution
--------------------------------------------------------

This approach dictates the following paradigm:

* Each of the Asterisk servers contain a server data store
* The federated network requires a centralized data store, served via a highly reliable container (eg. Google AppEngine or Oracle Application Server)
* Each of the Asterisk servers contain a service logic
* The service logic is capable of communicating with the local data store, the local Asterisk server and the centralized data store - via known well defined APIs
* Data is no longer replicated from one server to the other, information that is required at the federation level is stored in the centralized data store
* Routing decision are based upon local and centralized querying



| Pros | Cons |
| --- | --- |
| * Fairly simple to implement using legacy Asterisk versions
* Does not require any changes to the Asterisk core
* Can be implemented using Asterisk + AGI/FastAGI + AMI
* Scales at reasonable ease
* Well known maintenance and operational paradigms
* Based on bullet proof, battle tested technologies
 | * Provides simpler means for managing the system, however, when scaling beyondthe 20 server mark will require significant management skills
* Contains too many moving parts (Data Store, AGI Server, AMI Server, etc)
* We still rely on IT hacking, rather than an architecture. While the centralized datastore provides some architectural support, we're still miles away from it.
* Requires in-depth understanding of the surrounding tools (Redis, Memcache,MySQL, Python, etc)
* **Cool factor: medium and gets boring after a few days**
 |

Partial Data Distribution with Centralized Service Distribution
---------------------------------------------------------------

~~This approach dictates the following paradigm:~~

* ~~Each of the Asterisk servers contain a server data store~~
* ~~The federated network requires a centralized data store, served via a highly reliable container (eg. Google AppEngine or Oracle Application Server)~~
* ~~Each of the Asterisk servers contain a service logic~~
* ~~The service logic is capable of communicating with the local data store, the local Asterisk server and the centralized data store - via known well defined APIs~~
* ~~Data is no longer replicated from one server to the other, information that is required at the federation level is stored in the centralized data store~~
* ~~Routing decision are based upon local and centralized querying~~



| ~~Pros~~ | ~~Cons~~ |
| --- | --- |
| * ~~Fairly simple to implement using legacy Asterisk versions~~
* ~~Does not require any changes to the Asterisk core~~
* ~~Can be implemented using Asterisk + AGI/FastAGI + AMI~~
* ~~Scales at reasonable ease~~
* ~~Well known maintenance and operational paradigms~~
* ~~Based on bullet proof, battle tested technologies~~
 | * ~~Provides simpler means for managing the system, however, when scaling beyond~~~~the 20 server mark will require significant management skills~~
* ~~Contains too many moving parts (Data Store, AGI Server, AMI Server, etc)~~
* ~~We still rely on IT hacking, rather than an architecture. While the centralized datastore provides some architectural support, we're still miles away from it.~~
* ~~Requires in-depth understanding of the surrounding tools (Redis, Memcache,~~~~MySQL, Python, etc)~~
* ~~**Cool factor: medium and gets boring after a few days**~~
 |

Contributors
============



| Name | E-mail Address |
| --- | --- |
| unknown user | [mjordan@digium.com](mailto:mjordan@digium.com) |
| Nir Simionovich | [nirs@greenfieldtech.net](mailto:nirs@greenfieldtech.net) |

