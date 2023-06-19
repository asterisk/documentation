---
title: Overview
pageid: 31752496
---

 

Overview
========

The Asterisk DNS API is designed as a facade over resolver implementations. It provides a consistent view and also additional features. These additional features include a construct for doing queries in parallel and gathering the results, parsing some DNS types, and applying sorting/weight logic to some DNS types.

Threading
=========

The API provides a guarantee that it is safe to initiate and cancel queries from any thread. It does NOT, however, provide a guarantee that the ordering of queries shall be preserved. In other words, if you execute multiple queries individually you will not necessarily receive callbacks in the order the queries were originally executed. This API only guarantees that an individual DNS result and records are safe to retrieve within the scope of the respective asynchronous callback.

dns.h
=====

The dns.h file is the public API into the DNS core. It provides mechanisms to perform individual DNS queries and access the results. All data structures are opaque and can not be accessed directly.

Query
-----

A query contains information about an in-process DNS query. It also contains information about the result of the query.

Result
------

A result contains information about a completed DNS query. It also contains the resulting DNS records (if there are any).

Record
------

A record is a DNS record.

Code
----




---

  
  


```

/\*! \brief Opaque structure for a DNS query \*/
struct ast\_dns\_query;
/\*!
 \* \brief Get the name queried in a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the name queried
 \*/
const char \*ast\_dns\_query\_get\_name(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get the record resource type of a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the record resource type
 \*/
int ast\_dns\_query\_get\_rr\_type(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get the record resource class of a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the record resource class
 \*/
int ast\_dns\_query\_get\_rr\_class(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get the error rcode of a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the DNS rcode
 \*/
int ast\_dns\_query\_get\_rcode(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get the user specific data of a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the user specific data
 \*/
void \*ast\_dns\_query\_get\_data(const struct ast\_dns\_query \*query);
/\*! \brief Opaque structure for a DNS query result \*/
struct ast\_dns\_result;
/\*!
 \* \brief Get the result information for a DNS query
 \*
 \* \param query The DNS query
 \*
 \* \return the DNS result information
 \*/
struct ast\_dns\_result \*ast\_dns\_query\_get\_result(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get whether the domain exists or not
 \*
 \* \param query The DNS result
 \*
 \* \return whether the domain exists or not
 \*/
unsigned int ast\_dns\_result\_get\_nxdomain(const struct ast\_dns\_result \*result);
/\*!
 \* \brief Get whether the result is secure or not
 \*
 \* \param result The DNS result
 \*
 \* \return whether the result is secure or not
 \*/
unsigned int ast\_dns\_result\_get\_secure(const struct ast\_dns\_result \*result);
/\*!
 \* \brief Get whether the result is bogus or not
 \*
 \* \param result The DNS result
 \*
 \* \return whether the result is bogus or not
 \*/
unsigned int ast\_dns\_result\_get\_bogus(const struct ast\_dns\_result \*result);
/\*!
 \* \brief Get the canonical name of the result
 \*
 \* \param result The DNS result
 \*
 \* \return the canonical name
 \*/
const char \*ast\_dns\_result\_get\_canonical(const struct ast\_dns\_result \*result);
/\*!
 \* \brief Get the first record of a DNS Result
 \*
 \* \param result The DNS result
 \*
 \* \return first DNS record
 \*/
const struct ast\_dns\_record \*ast\_dns\_result\_get\_records(const struct ast\_dns\_result \*result);
/\*!
 \* \brief Free the DNS result information
 \*
 \* \param result The DNS result
 \*/
void ast\_dns\_result\_free(struct ast\_dns\_result \*result);
/\*! \brief Opaque structure for a DNS record \*/
struct ast\_dns\_record;
/\*!
 \* \brief Callback invoked when a query completes
 \*
 \* \param query The DNS query that was invoked
 \*/
typedef void (\*ast\_dns\_resolve\_callback)(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Get the resource record type of a DNS record
 \*
 \* \param record The DNS record
 \*
 \* \return the resource record type
 \*/
int ast\_dns\_record\_get\_rr\_type(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the resource record class of a DNS record
 \*
 \* \param record The DNS record
 \*
 \* \return the resource record class
 \*/
int ast\_dns\_record\_get\_rr\_class(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the TTL of a DNS record
 \*
 \* \param record The DNS record
 \*
 \* \return the TTL
 \*/
int ast\_dns\_record\_get\_ttl(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Retrieve the raw DNS record
 \*
 \* \param record The DNS record
 \*
 \* \return the raw DNS record
 \*/
const char \*ast\_dns\_record\_get\_data(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the next DNS record
 \*
 \* \param record The current DNS record
 \*
 \* \return the next DNS record
 \*/
struct ast\_dns\_record \*ast\_dns\_record\_get\_next(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Asynchronously resolve a DNS query
 \*
 \* \param name The name of what to resolve
 \* \param rr\_type Resource record type
 \* \param rr\_class Resource record class
 \* \param callback The callback to invoke upon completion
 \* \param data User data to make available on the query
 \*
 \* \retval non-NULL success - query has been sent for resolution
 \* \retval NULL failure
 \*
 \* \note The result passed to the callback does not need to be freed
 \*/
struct ast\_dns\_query \*ast\_dns\_resolve\_async(const char \*name, int rr\_type, int rr\_class, ast\_dns\_resolve\_callback callback, void \*data);
/\*!
 \* \brief Asynchronously resolve a DNS query, and continue resolving it according to the lowest TTL available
 \*
 \* \param name The name of what to resolve
 \* \param rr\_type Resource record type
 \* \param rr\_class Resource record class
 \* \param callback The callback to invoke upon completion
 \* \param data User data to make available on the query
 \*
 \* \retval non-NULL success - query has been sent for resolution
 \* \retval NULL failure
 \*
 \* \note The user data passed in to this function must be ao2 allocated
 \*
 \* \note This query will continue to happen according to the lowest TTL unless cancelled using ast\_dns\_resolve\_cancel
 \*
 \* \note It is NOT possible for the callback to be invoked concurrently for the query multiple times
 \*/
struct ast\_dns\_query \*ast\_dns\_resolve\_async\_recurring(const char \*name, int rr\_type, int rr\_class, ast\_dns\_resolve\_callback callback, void \*data);
/\*!
 \* \brief Cancel an asynchronous DNS resolution
 \*
 \* \param query The DNS query returned from ast\_dns\_resolve\_async
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*
 \* \note If successfully cancelled the callback will not be invoked
 \*/
int ast\_dns\_resolve\_cancel(struct ast\_dns\_query \*query);
/\*!
 \* \brief Synchronously resolve a DNS query
 \*
 \* \param name The name of what to resolve
 \* \param rr\_type Resource record type
 \* \param rr\_class Resource record class
 \* \param result A pointer to hold the DNS result
 \*
 \* \retval 0 success - query was completed and result is available
 \* \retval -1 failure
 \*/
int ast\_dns\_resolve(const char \*name, int rr\_type, int rr\_class, struct ast\_dns\_result \*\*result);

```



---


On this Page


dns\_query\_set.h
=================

The dns\_query\_set.h file is the public API into doing parallel queries. It provides mechanisms to group DNS queries together and receive notification when all have been completed. It mirrors the single query API in functionality.

Code
----




---

  
  


```

/\*! \brief Opaque structure for a set of DNS queries \*/
struct ast\_dns\_query\_set;
/\*!
 \* \brief Callback invoked when a query set completes
 \*
 \* \param query\_set The DNS query set that was invoked
 \*/
typedef void (\*ast\_dns\_query\_set\_callback)(const struct ast\_dns\_query\_set \*query\_set);
/\*!
 \* \brief Create a query set to hold queries
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_dns\_query\_set \*ast\_dns\_query\_set\_create(void);
/\*!
 \* \brief Add a query to a query set
 \*
 \* \param query\_set A DNS query set
 \* \param name The name of what to resolve
 \* \param rr\_type Resource record type
 \* \param rr\_class Resource record class
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_dns\_query\_set\_add(struct ast\_dns\_query\_set \*query\_set, const char \*name, int rr\_type, int rr\_class);
/\*!
 \* \brief Retrieve the number of queries in a query set
 \*
 \* \param query\_set A DNS query set
 \*
 \* \return the number of queries
 \*/
size\_t ast\_dns\_query\_set\_num\_queries(const struct ast\_dns\_query\_set \*query\_set);
/\*!
 \* \brief Retrieve a query from a query set
 \*
 \* \param query\_set A DNS query set
 \* \param index The index of the query to retrieve
 \*
 \* \retval non-NULL success
 \* \retval NULL failure
 \*/
struct ast\_dns\_query \*ast\_dns\_query\_set\_get(const struct ast\_dns\_query\_set \*query\_set, unsigned int index);
/\*!
 \* \brief Retrieve user specific data from a query set
 \*
 \* \param query\_set A DNS query set
 \*
 \* \return user specific data
 \*/
void \*ast\_dns\_query\_set\_get\_data(const struct ast\_dns\_query\_set \*query\_set);
/\*!
 \* \brief Asynchronously resolve queries in a query set
 \*
 \* \param query\_set The query set
 \* \param callback The callback to invoke upon completion
 \* \param data User data to make available on the query set
 \*
 \* \note The callback will be invoked when all queries have completed
 \*
 \* \note The user data passed in to this function must be ao2 allocated
 \*/
void ast\_dns\_query\_set\_resolve\_async(struct ast\_dns\_query\_set \*query\_set, ast\_dns\_query\_set\_callback callback, void \*data);
/\*!
 \* \brief Synchronously resolve queries in a query set
 \*
 \* \param query\_set The query set
 \*
 \* \note This function will return when all queries have been completed
 \*/
void ast\_query\_set\_resolve(struct ast\_dns\_query\_set \*query\_set);
/\*!
 \* \brief Cancel an asynchronous DNS query set resolution
 \*
 \* \param query\_set The DNS query set
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*
 \* \note If successfully cancelled the callback will not be invoked
 \*/
int ast\_dns\_query\_set\_resolve\_cancel(struct ast\_dns\_query\_set \*query\_set);
/\*!
 \* \brief Free a query set
 \*
 \* \param query\_set A DNS query set
 \*/
void ast\_dns\_query\_set\_free(struct ast\_dns\_query\_set \*query\_set);

```



---


 

dns\_naptr.h
============

The dns\_naptr.h file is the public API into accessing NAPTR records. The DNS core will automatically parse and make this information available. It will also sort the records.

Code
----




---

  
  


```

/\*!
 \* \brief Get the flags from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the flags
 \*/
const char \*ast\_dns\_naptr\_get\_flags(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the service from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the service
 \*/
const char \*ast\_dns\_naptr\_get\_service(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the regular expression from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the regular expression
 \*/
const char \*ast\_dns\_naptr\_get\_regexp(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the replacement value from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the replacement value
 \*/
const char \*ast\_dns\_naptr\_get\_replacement(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the order from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the order
 \*/
unsigned short ast\_dns\_naptr\_get\_order(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the preference from a NAPTR record
 \*
 \* \param record The DNS record
 \*
 \* \return the preference
 \*/
unsigned short ast\_dns\_naptr\_get\_preference(const struct ast\_dns\_record \*record);



```



---


 

dns\_srv.h
==========

The dns\_srv.h file is the public API into accessing SRV records. The DNS core will automatically parse and make this information available. It will also sort the records.

Code
----




---

  
  


```

/\*!
 \* \brief Get the hostname from an SRV record
 \*
 \* \param record The DNS record
 \*
 \* \return the hostname
 \*/
const char \*ast\_dns\_srv\_get\_host(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the priority from an SRV record
 \*
 \* \param record The DNS record
 \*
 \* \return the priority
 \*/
unsigned short ast\_dns\_srv\_get\_priority(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the weight from an SRV record
 \*
 \* \param record The DNS record
 \*
 \* \return the weight
 \*/
unsigned short ast\_dns\_srv\_get\_weight(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the port from an SRV record
 \*
 \* \param record The DNS record
 \*
 \* \return the port
 \*/
unsigned short ast\_dns\_srv\_get\_port(const struct ast\_dns\_record \*record);

```



---


 

dns\_tlsa.h
===========

The dns\_tlsa.h file is the public API into accessing TLSA records.




---

  
  


```

/\*!
 \* \brief Get the certificate usage field from a TLSA record
 \*
 \* \param record The DNS record
 \*
 \* \return the certificate usage field
 \*/
unsigned int ast\_dns\_tlsa\_get\_usage(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the selector field from a TLSA record
 \*
 \* \param record The DNS record
 \*
 \* \return the selector field
 \*/
unsigned int ast\_dns\_tlsa\_get\_selector(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the matching type field from a TLSA record
 \*
 \* \param record The DNS record
 \*
 \* \return the matching type field
 \*/
unsigned int ast\_dns\_tlsa\_get\_matching\_type(const struct ast\_dns\_record \*record);
/\*!
 \* \brief Get the certificate association data from a TLSA record
 \*
 \* \param record The DNS record
 \*
 \* \return the certificate association data
 \*/
const char \*ast\_dns\_tlsa\_get\_association\_data(const struct ast\_dns\_record \*record);



```



---


 

dns\_resolver.h
===============

The dns\_resolver.h file contains the interface as defined for resolver implementations.

Code
----




---

  
  


```

/\*! \brief DNS resolver implementation \*/
struct ast\_dns\_resolver {
 /\*! \brief The name of the resolver implementation \*/
 const char \*name;
 /\*! \brief Priority for this resolver if multiple exist \*/
 unsigned int priority;
 /\*! \brief Perform resolution of a DNS query \*/
 int (\*resolve)(struct ast\_dns\_query \*query);
 /\*! \brief Cancel resolution of a DNS query \*/
 int (\*cancel)(struct ast\_dns\_query \*query);
};
/\*!
 \* \brief Set resolver specific data on a query
 \*
 \* \param query The DNS query
 \* \param data The resolver specific data
 \*
 \* \note Unlike user specific data this does not have to be ao2 allocated
 \*/
void ast\_dns\_resolver\_set\_data(struct ast\_dns\_query \*query, void \*data);
/\*!
 \* \brief Retrieve resolver specific data
 \*
 \* \param query The DNS query
 \*
 \* \return the resolver specific data
 \*/
void \*ast\_dns\_resolver\_get\_data(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Set result information for a DNS query
 \*
 \* \param query The DNS query
 \* \param nxdomain Whether the domain was not found
 \* \param result Whether the result is secured or not
 \* \param bogus Whether the result is bogus or not
 \* \param canonical The canonical name
 \*/
void ast\_dns\_resolver\_set\_result(struct ast\_dns\_query \*query, unsigned int nxdomain, unsigned int secure, unsigned int bogus,
 const char \*canonical);
/\*!
 \* \brief Add a DNS record to the result of a DNS query
 \*
 \* \param query The DNS query
 \* \param rr\_type Resource record type
 \* \param rr\_class Resource record class
 \* \param ttl TTL of the record
 \* \param data The raw DNS record
 \* \param size The size of the raw DNS record
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_dns\_resolver\_add\_record(struct ast\_dns\_query \*query, int rr\_type, int rr\_class, int ttl, char \*data, size\_t size);
/\*!
 \* \brief Mark a DNS query as having been completed
 \*
 \* \param query The DNS query
 \*
 \* \note Once this is invoked the resolver data on the query will be removed
 \*/
void ast\_dns\_resolver\_completed(const struct ast\_dns\_query \*query);
/\*!
 \* \brief Register a DNS resolver
 \*
 \* \param resolver A DNS resolver implementation
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_dns\_resolver\_register(const struct ast\_core\_dns\_resolver \*resolver);
/\*!
 \* \brief Unregister a DNS resolver
 \*
 \* \param resolver A DNS resolver implementation
 \*
 \* \retval 0 success
 \* \retval -1 failure
 \*/
int ast\_dns\_resolver\_unregister(const struct ast\_core\_dns\_resolver \*resolver);

```



---


 

dns\_internal.h
===============

The dns\_internal.h file contains the internal data structures.

Code
----




---

  
  


```

/\*! \brief Generic DNS record information \*/
struct ast\_dns\_record {
 /\*! \brief Resource record type \*/
 int rr\_type;
 /\*! \brief Resource record class \*/
 int rr\_class;
 /\*! \brief Time-to-live of the record \*/
 int ttl;
 /\*! \brief The raw DNS record \*/
 char \*data;
 /\*! \brief The size of the raw DNS record \*/
 size\_t data\_len;
 /\*! \brief Linked list information \*/
 AST\_LIST\_ENTRY(ast\_dns\_record) list;
};
/\*! \brief An SRV record \*/
struct ast\_dns\_srv\_record {
 /\*! \brief Generic DNS record information \*/
 struct ast\_dns\_record generic;
 /\*! \brief The hostname in the SRV record \*/
 const char \*host;
 /\*! \brief The priority of the SRV record \*/
 unsigned short priority;
 /\*! \brief The weight of the SRV record \*/
 unsigned short weight;
 /\*! \brief The port in the SRV record \*/
 unsigned short port;
};
/\*! \brief A NAPTR record \*/
struct ast\_dns\_naptr\_record {
 /\*! \brief Generic DNS record information \*/
 struct ast\_dns\_record generic;
 /\*! \brief The flags from the NAPTR record \*/
 const char \*flags;
 /\*! \brief The service from the NAPTR record \*/
 const char \*service;
 /\*! \brief The regular expression from the NAPTR record \*/
 const char \*regexp;
 /\*! \brief The replacement from the NAPTR record \*/
 const char \*replacement;
 /\*! \brief The order for the NAPTR record \*/
 unsigned short order;
 /\*! \brief The preference of the NAPTR record \*/
 unsigned short preference;
};
/\*! \brief The result of a DNS query \*/
struct ast\_dns\_result {
 /\*! \brief Whether the domain was not found \*/
 unsigned int nxdomain;
 /\*! \brief Whether the result is secure \*/
 unsigned int secure;
 /\*! \brief Whether the result is bogus \*/
 unsigned int bogus;
 /\*! \brief The canonical name \*/
 const char \*canonical;
 /\*! \brief Records returned \*/
 AST\_LIST\_HEAD\_NOLOCK(, ast\_dns\_record) records;
};
/\*! \brief A DNS query \*/
struct ast\_dns\_query {
 /\*! \brief Callback to invoke upon completion \*/
 ast\_dns\_resolve\_callback callback;
 /\*! \brief User-specific data \*/
 void \*user\_data;
 /\*! \brief Resolver-specific data \*/
 void \*resolver\_data;
 /\*! \brief Result of the DNS query \*/
 struct ast\_dns\_result \*result;
 /\*! \brief Timer for recurring resolution \*/
 int timer;
};
/\*! \brief A set of DNS queries \*/
struct ast\_dns\_query\_set {
 /\*! \brief DNS queries \*/
 AST\_VECTOR(, struct ast\_dns\_query \*) queries;
 /\*! \brief The total number of completed queries \*/
 unsigned int queries\_completed;
 /\*! \brief Callback to invoke upon completion \*/
 ast\_dns\_query\_set\_callback callback;
 /\*! \brief User-specific data \*/
 void \*user\_data;
 /\*! \brief Timer for recurring resolution \*/
 int timer;
};

```



---


 

Examples
========

Synchronous Resolution
----------------------

This example blocks the calling thread until resolution has completed. Once completed result information is returned.




---

  
  


```

#include <asterisk/dns.h>
int test(void)
{
 RAII\_VAR(struct ast\_dns\_result \*, result, NULL, ast\_dns\_result\_unref);
 int res;
 struct ast\_dns\_record \*record;
 res = ast\_dns\_resolve("www.asterisk.org", ns\_c\_in, ns\_t\_a, &result);
 if (res) {
 ast\_verbose(1, "Synchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 if (ast\_dns\_result\_get\_nxdomain(result)) {
 ast\_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return -1;
 }
 if (ast\_dns\_result\_get\_secure(result)) {
 ast\_verbose(1, "DNS result was secured\n");
 } else if (ast\_dns\_result\_get\_bogus(result)) {
 ast\_verbose(1, "DNS result is bogus\n");
 return -1;
 }
 for (record = ast\_dns\_result\_get\_records(result); record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got address: %s\n", inet\_ntoa(\*(struct in\_addr\*)ast\_dns\_record\_get\_data(record)));
 }
 return 0;
}

```



---


 

Asynchronous Resolution
-----------------------

This example does not block the calling thread when resolving. A callback is invoked upon query completion instead. The result information can then be retrieved from the query.




---

  
  


```

#include <asterisk/dns.h>
static void test\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record;
 if (ast\_dns\_result\_get\_nxdomain(result)) {
 ast\_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }
 if (ast\_dns\_result\_get\_secure(result)) {
 ast\_verbose(1, "DNS result was secured\n");
 } else if (ast\_dns\_result\_get\_bogus(result)) {
 ast\_verbose(1, "DNS result is bogus\n");
 return;
 }
 for (record = ast\_dns\_result\_get\_records(result); record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got address: %s\n", inet\_ntoa(\*(struct in\_addr\*)ast\_dns\_record\_get\_data(record)));
 }
}
int test(void)
{
 int res;
 res = ast\_dns\_resolve\_async("www.asterisk.org", ns\_c\_in, ns\_t\_a, test\_callback, NULL);
 if (res) {
 ast\_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



---


 

Parallel Queries
----------------

This example uses a query set to do two queries in an asynchronous manner. Each query is done on a different domain. Once both queries have completed the callback is invoked and each query result can be examined.




---

  
  


```

#include <asterisk/dns.h>
#include <asterisk/dns\_query\_set.h>
static void test\_callback(const struct ast\_dns\_query\_query \*query\_set)
{
 struct ast\_dns\_result \*asterisk\_result = ast\_dns\_query\_get\_result(ast\_dns\_query\_set\_get(query\_set, 0));
 struct ast\_dns\_result \*digium\_result = ast\_dns\_query\_get\_result(ast\_dns\_query\_set\_get(query\_set, 1));
 struct ast\_dns\_record \*record;
 if (!ast\_dns\_result\_get\_nxdomain(asterisk\_result)) {
 ast\_verbose(1, "'asterisk.org' resolution results:\n");
 for (record = ast\_dns\_result\_get\_records(asterisk\_result); record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got address: %s\n", inet\_ntoa(\*(struct in\_addr\*)ast\_dns\_record\_get\_data(record)));
 }
 } else {
 ast\_verbose(1, "'asterisk.org' domain does not exist\n");
 }
 if (!ast\_dns\_result\_get\_nxdomain(digium\_result)) {
 ast\_verbose(1, "'digium.com' resolution results:\n");
 for (record = ast\_dns\_result\_get\_records(digium\_result); record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got address: %s\n", inet\_ntoa(\*(struct in\_addr\*)ast\_dns\_record\_get\_data(record)));
 }
 } else {
 ast\_verbose(1, "'digium.com' domain does not exist\n");
 }
}
int test(void)
{
 struct ast\_dns\_query\_set \*query\_set;
 query\_set = ast\_dns\_query\_set\_create():
 if (!query\_set) {
 ast\_verbose(1, "Could not create a query set for parallel resolution");
 return -1;
 }
 ast\_dns\_query\_set\_add(query\_set, "www.asterisk.org", ns\_c\_in, ns\_t\_a);
 ast\_dns\_query\_set\_add(query\_set, "www.digium.com", ns\_c\_in, ns\_t\_a);
 ast\_dns\_query\_set\_resolve\_async(query\_set, test\_callback, NULL);
 ast\_dns\_query\_set\_unref(query\_set);
 sleep(5);
 return 0;
}

```



---


 

Fallback
--------

This example does a fall back from an AAAA record lookup to an A record lookup if no results were available for the AAAA record lookup. This also uses the asynchronous function and the same callback is used for both queries.




---

  
  


```

#include <asterisk/dns.h>
static void test\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record = ast\_dns\_result\_get\_records(result);
 if (ast\_dns\_result\_get\_nxdomain(result) || !record) {
 ast\_verbose(1, "Specified domain name 'asterisk.org' does not exist or has no records\n");
 if (ast\_dns\_get\_rr\_type(query) == ns\_t\_aaaa) {
 /\* Fall back to an A lookup \*/
 ast\_dns\_resolve\_async("www.asterisk.org", ns\_c\_in, ns\_t\_a, test\_callback, NULL);
 }
 return;
 }
 if (ast\_dns\_result\_get\_secure(result)) {
 ast\_verbose(1, "DNS result was secured\n");
 } else if (ast\_dns\_result\_get\_bogus(result)) {
 ast\_verbose(1, "DNS result is bogus\n");
 return;
 }
 for (; record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got a record\n");
 }
}
int test(void)
{
 int res;
 /\* Start out doing an AAAA lookup \*/
 res = ast\_dns\_resolve\_async("www.asterisk.org", ns\_c\_in, ns\_t\_aaaa, test\_callback, NULL);
 if (res) {
 ast\_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



---


 

NAPTR
-----

This example does a NAPTR lookup followed by SRV followed by AAAA and then A. The results of the NAPTR and SRV lookups are taken into account when deciding the next step to take.




---

  
  


```

#include <asterisk/dns.h>
/\* An alternative to this cascade approach would be using a query set to do NAPTR, SRV, AAAA, and A in parallel
 \* with NAPTR and SRV adding additional queries afterwards
 \*/
static void a\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record = ast\_dns\_result\_get\_records(result);
 if (!record) {
 /\* We have nowhere to go \*/
 return;
 }
 /\* If we got here there is an A record \*/
}
static void aaaa\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record = ast\_dns\_result\_get\_records(result);
 if (!record) {
 ast\_dns\_resolve\_async(ast\_dns\_query\_get\_name(query), ns\_c\_in, ns\_t\_a, a\_callback, NULL);
 return;
 }
 /\* If we got here there is an AAAA record \*/
}
static void srv\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record = ast\_dns\_result\_get\_records(result);
 if (record) {
 ast\_dns\_resolve\_async(ast\_dns\_srv\_get\_host(record), ns\_c\_in, ns\_t\_aaaa, aaaa\_callback, NULL);
 return;
 }
 ast\_dns\_resolve\_async("asterisk.org", ns\_c\_in, ns\_t\_aaaa, aaaa\_callback, NULL);
}
static void naptr\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record;
 if (ast\_dns\_result\_get\_nxdomain(result)) {
 ast\_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }
 /\* This is a very simplistic cascade example, it grabs the first result \*/
 for (record = ast\_dns\_result\_get\_records(result); record; record = ast\_dns\_record\_get\_next(record)) {
 if (!strcmp(ast\_dns\_naptr\_get\_service(record), "SIP+D2U")) {
 ast\_dns\_resolve\_async(ast\_dns\_naptr\_get\_replacement(record), ns\_c\_in, ns\_t\_srv, srv\_callback, NULL);
 return;
 }
 }
 ast\_dns\_resolve\_async("\_sip.\_udp.asterisk.org", ns\_c\_in, ns\_t\_srv, srv\_callback, NULL);
}
int test(void)
{
 int res;
 res = ast\_dns\_resolve\_async("asterisk.org", ns\_c\_in, ns\_t\_naptr, naptr\_callback, NULL);
 if (res) {
 ast\_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}



```



---


 

Recurring
---------

The recurring example has the DNS core re-run the specified query according to the lowest TTL of the result records. It is up to the user to store the previous results and determine whether action should be taken or not.




---

  
  


```

#include <asterisk/dns.h>
static void test\_callback(const struct ast\_dns\_query \*query)
{
 struct ast\_dns\_result \*result = ast\_dns\_query\_get\_result(query);
 struct ast\_dns\_record \*record;
 if (ast\_dns\_result\_get\_nxdomain(result)) {
 ast\_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }

 /\* Previous information should be stored and compared against new records, if different then take action \*/
 for (record = ast\_dns\_result\_get\_records(result); record; record = ast\_dns\_record\_get\_next(record)) {
 ast\_verbose(1, "Got address: %s\n", inet\_ntoa(\*(struct in\_addr\*)ast\_dns\_record\_get\_data(record)));
 }
}
int test(void)
{
 int res;
 res = ast\_dns\_resolve\_async\_recurring("www.asterisk.org", ns\_c\_in, ns\_t\_a, test\_callback, NULL);
 if (res) {
 ast\_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



---


