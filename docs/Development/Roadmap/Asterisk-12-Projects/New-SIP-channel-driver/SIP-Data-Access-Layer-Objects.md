---
title: SIP Data Access Layer Objects
pageid: 21464622
---

General
-------


The new SIP channel driver for Asterisk will have a clear separation of persistent data from the various modules and implementations therein. This will allow the persistent data to be stored using different methods such as: flat file, astdb, and other databases with no changes required elsewhere. A common API will be designed and implemented to allow this to happen. Before this occurs though the objects exposed by this data access layer need to be defined with minimal content and relationships. The objects listed will evolve and change with additional objects being added as development progresses. This page aims to propose an initial idea for the minimum required and to solicit feedback.


#### Transport


The transport object contains information about configured SIP transports. These are what send and receive SIP traffic.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  name  |  string  |  Unique name for transport  |
|  type  |  enum  |  Type of transport (UDP, TCP, TLS, WS, WSS)  |
|  host  |  ast\_sockaddr  |  IP address for transport to bind to (may be optional)  |
|  port  |  integer  |  Port to bind to (may be optional)  |


##### TLS Specific




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  authority  |  string  |  Certificate authority filename or path  |
|  certificate  |  string  |  Path to certificate to use  |
|  key  |  string  |  Path to private key  |
|  password  |  string  |  Password for private key  |
|  verifyserver  |  bool  |  Whether to require verification of server certificate or not  |
|  verifyclient  |  bool  |  Whether to require verification of client certificate or not  |
|  requireclient  |  bool  |  Whether to require a client certificate or not  |


#### Endpoint


The endpoint object contains information about a SIP trunk or SIP device.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  name  |  string  |  Unique name for endpoint  |
|  codecs  |  ast\_format\_cap  |  Allowed formats  |
|  dtmf  |  enum  |  DTMF method to use (inband, INFO, RFC2833)  |
|  transport  |  string  |  Name of transport to force endpoint to use  |
|  cid\_num  |  string  |  Caller ID number  |
|  cid\_name  |  string  |  Caller ID name  |
|  cid\_tag  |  string  |  Caller ID tag  |
|  context  |  string  |  Context to place incoming calls into  |
|  registrations  |  list  |  Outgoing registrations associated with endpoint  |
|  domain  |  string  |  Domain that the endpoint belongs to  |
|  aor  |  string  |  Address of record to use for endpoint  |


#### Registration


The registration object contains information about an outgoing registration.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  host  |  string  |  IP address or host to register to  |
|  port  |  int  |  Port to contact server on  |
|  username  |  string  |  Username to authenticate as  |
|  password  |  string  |  Password to use for authentication  |


#### Domain


The domain object holds information about a specific SIP domain.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  name  |  string  |  Unique name for domain  |
|  context  |  string  |  Context to place incoming calls into, if unauthenticated  |


#### AOR


The address of record object contains information used by a registrar for registrations.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  name  |  string  |  Unique name for AOR  |
|  expiration  |  int  |  Default expiration if registration does not provide it  |
|  contacts  |  list  |  List of contacts associated with this AOR  |
|  domain  |  string  |  Domain that the AOR belongs to  |


#### Contact


The contact object contains information about an inbound registration.




|  Variable Name  |  Type  |  Contents  |
| --- | --- | --- |
|  uri  |  string  |  Full URI to contact  |
|  expiration  |  timeval  |  When this contact should expire  |


#### Notes


The above objects represent a minimum required to achieve basic functionality. They do not reflect all needed variables and objects and as previously stated will evolve and grow.

