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

```
/*! \brief Opaque structure for a DNS quer */
struct ast_dns_query;
/*!
 * \brief Get the name queried in a DNS query
 *
 * \param query The DNS query
 *
 * \return the name queried
 */
const char \*ast_dns_query_get_name(const struct ast_dns_query \*query);
/*!
 * \brief Get the record resource type of a DNS query
 *
 * \param query The DNS query
 *
 * \return the record resource type
 */
int ast_dns_query_get_rr_type(const struct ast_dns_query \*query);
/*!
 * \brief Get the record resource class of a DNS query
 *
 * \param query The DNS query
 *
 * \return the record resource class
 */
int ast_dns_query_get_rr_class(const struct ast_dns_query \*query);
/*!
 * \brief Get the error rcode of a DNS query
 *
 * \param query The DNS query
 *
 * \return the DNS rcode
 */
int ast_dns_query_get_rcode(const struct ast_dns_query \*query);
/*!
 * \brief Get the user specific data of a DNS query
 *
 * \param query The DNS query
 *
 * \return the user specific data
 */
void \*ast_dns_query_get_data(const struct ast_dns_query \*query);
/*! \brief Opaque structure for a DNS query resul */
struct ast_dns_result;
/*!
 * \brief Get the result information for a DNS query
 *
 * \param query The DNS query
 *
 * \return the DNS result information
 */
struct ast_dns_result \*ast_dns_query_get_result(const struct ast_dns_query \*query);
/*!
 * \brief Get whether the domain exists or not
 *
 * \param query The DNS result
 *
 * \return whether the domain exists or not
 */
unsigned int ast_dns_result_get_nxdomain(const struct ast_dns_result \*result);
/*!
 * \brief Get whether the result is secure or not
 *
 * \param result The DNS result
 *
 * \return whether the result is secure or not
 */
unsigned int ast_dns_result_get_secure(const struct ast_dns_result \*result);
/*!
 * \brief Get whether the result is bogus or not
 *
 * \param result The DNS result
 *
 * \return whether the result is bogus or not
 */
unsigned int ast_dns_result_get_bogus(const struct ast_dns_result \*result);
/*!
 * \brief Get the canonical name of the result
 *
 * \param result The DNS result
 *
 * \return the canonical name
 */
const char \*ast_dns_result_get_canonical(const struct ast_dns_result \*result);
/*!
 * \brief Get the first record of a DNS Result
 *
 * \param result The DNS result
 *
 * \return first DNS record
 */
const struct ast_dns_record \*ast_dns_result_get_records(const struct ast_dns_result \*result);
/*!
 * \brief Free the DNS result information
 *
 * \param result The DNS result
 */
void ast_dns_result_free(struct ast_dns_result \*result);
/*! \brief Opaque structure for a DNS recor */
struct ast_dns_record;
/*!
 * \brief Callback invoked when a query completes
 *
 * \param query The DNS query that was invoked
 */
typedef void (\*ast_dns_resolve_callback)(const struct ast_dns_query \*query);
/*!
 * \brief Get the resource record type of a DNS record
 *
 * \param record The DNS record
 *
 * \return the resource record type
 */
int ast_dns_record_get_rr_type(const struct ast_dns_record \*record);
/*!
 * \brief Get the resource record class of a DNS record
 *
 * \param record The DNS record
 *
 * \return the resource record class
 */
int ast_dns_record_get_rr_class(const struct ast_dns_record \*record);
/*!
 * \brief Get the TTL of a DNS record
 *
 * \param record The DNS record
 *
 * \return the TTL
 */
int ast_dns_record_get_ttl(const struct ast_dns_record \*record);
/*!
 * \brief Retrieve the raw DNS record
 *
 * \param record The DNS record
 *
 * \return the raw DNS record
 */
const char \*ast_dns_record_get_data(const struct ast_dns_record \*record);
/*!
 * \brief Get the next DNS record
 *
 * \param record The current DNS record
 *
 * \return the next DNS record
 */
struct ast_dns_record \*ast_dns_record_get_next(const struct ast_dns_record \*record);
/*!
 * \brief Asynchronously resolve a DNS query
 *
 * \param name The name of what to resolve
 * \param rr_type Resource record type
 * \param rr_class Resource record class
 * \param callback The callback to invoke upon completion
 * \param data User data to make available on the query
 *
 * \retval non-NULL success - query has been sent for resolution
 * \retval NULL failure
 *
 * \note The result passed to the callback does not need to be freed
 */
struct ast_dns_query \*ast_dns_resolve_async(const char \*name, int rr_type, int rr_class, ast_dns_resolve_callback callback, void \*data);
/*!
 * \brief Asynchronously resolve a DNS query, and continue resolving it according to the lowest TTL available
 *
 * \param name The name of what to resolve
 * \param rr_type Resource record type
 * \param rr_class Resource record class
 * \param callback The callback to invoke upon completion
 * \param data User data to make available on the query
 *
 * \retval non-NULL success - query has been sent for resolution
 * \retval NULL failure
 *
 * \note The user data passed in to this function must be ao2 allocated
 *
 * \note This query will continue to happen according to the lowest TTL unless cancelled using ast_dns_resolve_cancel
 *
 * \note It is NOT possible for the callback to be invoked concurrently for the query multiple times
 */
struct ast_dns_query \*ast_dns_resolve_async_recurring(const char \*name, int rr_type, int rr_class, ast_dns_resolve_callback callback, void \*data);
/*!
 * \brief Cancel an asynchronous DNS resolution
 *
 * \param query The DNS query returned from ast_dns_resolve_async
 *
 * \retval 0 success
 * \retval -1 failure
 *
 * \note If successfully cancelled the callback will not be invoked
 */
int ast_dns_resolve_cancel(struct ast_dns_query \*query);
/*!
 * \brief Synchronously resolve a DNS query
 *
 * \param name The name of what to resolve
 * \param rr_type Resource record type
 * \param rr_class Resource record class
 * \param result A pointer to hold the DNS result
 *
 * \retval 0 success - query was completed and result is available
 * \retval -1 failure
 */
int ast_dns_resolve(const char \*name, int rr_type, int rr_class, struct ast_dns_result \*\*result);

```

On this Page


dns_query_set.h
=================

The dns_query_set.h file is the public API into doing parallel queries. It provides mechanisms to group DNS queries together and receive notification when all have been completed. It mirrors the single query API in functionality.

Code
----

```
/*! \brief Opaque structure for a set of DNS querie */
struct ast_dns_query_set;
/*!
 * \brief Callback invoked when a query set completes
 *
 * \param query_set The DNS query set that was invoked
 */
typedef void (\*ast_dns_query_set_callback)(const struct ast_dns_query_set \*query_set);
/*!
 * \brief Create a query set to hold queries
 *
 * \retval non-NULL success
 * \retval NULL failure
 */
struct ast_dns_query_set \*ast_dns_query_set_create(void);
/*!
 * \brief Add a query to a query set
 *
 * \param query_set A DNS query set
 * \param name The name of what to resolve
 * \param rr_type Resource record type
 * \param rr_class Resource record class
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_dns_query_set_add(struct ast_dns_query_set \*query_set, const char \*name, int rr_type, int rr_class);
/*!
 * \brief Retrieve the number of queries in a query set
 *
 * \param query_set A DNS query set
 *
 * \return the number of queries
 */
size_t ast_dns_query_set_num_queries(const struct ast_dns_query_set \*query_set);
/*!
 * \brief Retrieve a query from a query set
 *
 * \param query_set A DNS query set
 * \param index The index of the query to retrieve
 *
 * \retval non-NULL success
 * \retval NULL failure
 */
struct ast_dns_query \*ast_dns_query_set_get(const struct ast_dns_query_set \*query_set, unsigned int index);
/*!
 * \brief Retrieve user specific data from a query set
 *
 * \param query_set A DNS query set
 *
 * \return user specific data
 */
void \*ast_dns_query_set_get_data(const struct ast_dns_query_set \*query_set);
/*!
 * \brief Asynchronously resolve queries in a query set
 *
 * \param query_set The query set
 * \param callback The callback to invoke upon completion
 * \param data User data to make available on the query set
 *
 * \note The callback will be invoked when all queries have completed
 *
 * \note The user data passed in to this function must be ao2 allocated
 */
void ast_dns_query_set_resolve_async(struct ast_dns_query_set \*query_set, ast_dns_query_set_callback callback, void \*data);
/*!
 * \brief Synchronously resolve queries in a query set
 *
 * \param query_set The query set
 *
 * \note This function will return when all queries have been completed
 */
void ast_query_set_resolve(struct ast_dns_query_set \*query_set);
/*!
 * \brief Cancel an asynchronous DNS query set resolution
 *
 * \param query_set The DNS query set
 *
 * \retval 0 success
 * \retval -1 failure
 *
 * \note If successfully cancelled the callback will not be invoked
 */
int ast_dns_query_set_resolve_cancel(struct ast_dns_query_set \*query_set);
/*!
 * \brief Free a query set
 *
 * \param query_set A DNS query set
 */
void ast_dns_query_set_free(struct ast_dns_query_set \*query_set);

```



dns_naptr.h
============

The dns_naptr.h file is the public API into accessing NAPTR records. The DNS core will automatically parse and make this information available. It will also sort the records.

Code
----

```
/*!
 * \brief Get the flags from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the flags
 */
const char \*ast_dns_naptr_get_flags(const struct ast_dns_record \*record);
/*!
 * \brief Get the service from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the service
 */
const char \*ast_dns_naptr_get_service(const struct ast_dns_record \*record);
/*!
 * \brief Get the regular expression from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the regular expression
 */
const char \*ast_dns_naptr_get_regexp(const struct ast_dns_record \*record);
/*!
 * \brief Get the replacement value from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the replacement value
 */
const char \*ast_dns_naptr_get_replacement(const struct ast_dns_record \*record);
/*!
 * \brief Get the order from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the order
 */
unsigned short ast_dns_naptr_get_order(const struct ast_dns_record \*record);
/*!
 * \brief Get the preference from a NAPTR record
 *
 * \param record The DNS record
 *
 * \return the preference
 */
unsigned short ast_dns_naptr_get_preference(const struct ast_dns_record \*record);

```



dns_srv.h
==========

The dns_srv.h file is the public API into accessing SRV records. The DNS core will automatically parse and make this information available. It will also sort the records.

Code
----

```
/*!
 * \brief Get the hostname from an SRV record
 *
 * \param record The DNS record
 *
 * \return the hostname
 */
const char \*ast_dns_srv_get_host(const struct ast_dns_record \*record);
/*!
 * \brief Get the priority from an SRV record
 *
 * \param record The DNS record
 *
 * \return the priority
 */
unsigned short ast_dns_srv_get_priority(const struct ast_dns_record \*record);
/*!
 * \brief Get the weight from an SRV record
 *
 * \param record The DNS record
 *
 * \return the weight
 */
unsigned short ast_dns_srv_get_weight(const struct ast_dns_record \*record);
/*!
 * \brief Get the port from an SRV record
 *
 * \param record The DNS record
 *
 * \return the port
 */
unsigned short ast_dns_srv_get_port(const struct ast_dns_record \*record);

```



dns_tlsa.h
===========

The dns_tlsa.h file is the public API into accessing TLSA records.

```
/*!
 * \brief Get the certificate usage field from a TLSA record
 *
 * \param record The DNS record
 *
 * \return the certificate usage field
 */
unsigned int ast_dns_tlsa_get_usage(const struct ast_dns_record \*record);
/*!
 * \brief Get the selector field from a TLSA record
 *
 * \param record The DNS record
 *
 * \return the selector field
 */
unsigned int ast_dns_tlsa_get_selector(const struct ast_dns_record \*record);
/*!
 * \brief Get the matching type field from a TLSA record
 *
 * \param record The DNS record
 *
 * \return the matching type field
 */
unsigned int ast_dns_tlsa_get_matching_type(const struct ast_dns_record \*record);
/*!
 * \brief Get the certificate association data from a TLSA record
 *
 * \param record The DNS record
 *
 * \return the certificate association data
 */
const char \*ast_dns_tlsa_get_association_data(const struct ast_dns_record \*record);

```



dns_resolver.h
===============

The dns_resolver.h file contains the interface as defined for resolver implementations.

Code
----

```
/*! \brief DNS resolver implementatio */
struct ast_dns_resolver {
 /*! \brief The name of the resolver implementatio */
 const char \*name;
 /*! \brief Priority for this resolver if multiple exis */
 unsigned int priority;
 /*! \brief Perform resolution of a DNS quer */
 int (\*resolve)(struct ast_dns_query \*query);
 /*! \brief Cancel resolution of a DNS quer */
 int (\*cancel)(struct ast_dns_query \*query);
};
/*!
 * \brief Set resolver specific data on a query
 *
 * \param query The DNS query
 * \param data The resolver specific data
 *
 * \note Unlike user specific data this does not have to be ao2 allocated
 */
void ast_dns_resolver_set_data(struct ast_dns_query \*query, void \*data);
/*!
 * \brief Retrieve resolver specific data
 *
 * \param query The DNS query
 *
 * \return the resolver specific data
 */
void \*ast_dns_resolver_get_data(const struct ast_dns_query \*query);
/*!
 * \brief Set result information for a DNS query
 *
 * \param query The DNS query
 * \param nxdomain Whether the domain was not found
 * \param result Whether the result is secured or not
 * \param bogus Whether the result is bogus or not
 * \param canonical The canonical name
 */
void ast_dns_resolver_set_result(struct ast_dns_query \*query, unsigned int nxdomain, unsigned int secure, unsigned int bogus,
 const char \*canonical);
/*!
 * \brief Add a DNS record to the result of a DNS query
 *
 * \param query The DNS query
 * \param rr_type Resource record type
 * \param rr_class Resource record class
 * \param ttl TTL of the record
 * \param data The raw DNS record
 * \param size The size of the raw DNS record
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_dns_resolver_add_record(struct ast_dns_query \*query, int rr_type, int rr_class, int ttl, char \*data, size_t size);
/*!
 * \brief Mark a DNS query as having been completed
 *
 * \param query The DNS query
 *
 * \note Once this is invoked the resolver data on the query will be removed
 */
void ast_dns_resolver_completed(const struct ast_dns_query \*query);
/*!
 * \brief Register a DNS resolver
 *
 * \param resolver A DNS resolver implementation
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_dns_resolver_register(const struct ast_core_dns_resolver \*resolver);
/*!
 * \brief Unregister a DNS resolver
 *
 * \param resolver A DNS resolver implementation
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_dns_resolver_unregister(const struct ast_core_dns_resolver \*resolver);

```



dns_internal.h
===============

The dns_internal.h file contains the internal data structures.

Code
----

```
/*! \brief Generic DNS record informatio */
struct ast_dns_record {
 /*! \brief Resource record typ */
 int rr_type;
 /*! \brief Resource record clas */
 int rr_class;
 /*! \brief Time-to-live of the recor */
 int ttl;
 /*! \brief The raw DNS recor */
 char \*data;
 /*! \brief The size of the raw DNS recor */
 size_t data_len;
 /*! \brief Linked list informatio */
 AST_LIST_ENTRY(ast_dns_record) list;
};
/*! \brief An SRV recor */
struct ast_dns_srv_record {
 /*! \brief Generic DNS record informatio */
 struct ast_dns_record generic;
 /*! \brief The hostname in the SRV recor */
 const char \*host;
 /*! \brief The priority of the SRV recor */
 unsigned short priority;
 /*! \brief The weight of the SRV recor */
 unsigned short weight;
 /*! \brief The port in the SRV recor */
 unsigned short port;
};
/*! \brief A NAPTR recor */
struct ast_dns_naptr_record {
 /*! \brief Generic DNS record informatio */
 struct ast_dns_record generic;
 /*! \brief The flags from the NAPTR recor */
 const char \*flags;
 /*! \brief The service from the NAPTR recor */
 const char \*service;
 /*! \brief The regular expression from the NAPTR recor */
 const char \*regexp;
 /*! \brief The replacement from the NAPTR recor */
 const char \*replacement;
 /*! \brief The order for the NAPTR recor */
 unsigned short order;
 /*! \brief The preference of the NAPTR recor */
 unsigned short preference;
};
/*! \brief The result of a DNS quer */
struct ast_dns_result {
 /*! \brief Whether the domain was not foun */
 unsigned int nxdomain;
 /*! \brief Whether the result is secur */
 unsigned int secure;
 /*! \brief Whether the result is bogu */
 unsigned int bogus;
 /*! \brief The canonical nam */
 const char \*canonical;
 /*! \brief Records returne */
 AST_LIST_HEAD_NOLOCK(, ast_dns_record) records;
};
/*! \brief A DNS quer */
struct ast_dns_query {
 /*! \brief Callback to invoke upon completio */
 ast_dns_resolve_callback callback;
 /*! \brief User-specific dat */
 void \*user_data;
 /*! \brief Resolver-specific dat */
 void \*resolver_data;
 /*! \brief Result of the DNS quer */
 struct ast_dns_result \*result;
 /*! \brief Timer for recurring resolutio */
 int timer;
};
/*! \brief A set of DNS querie */
struct ast_dns_query_set {
 /*! \brief DNS querie */
 AST_VECTOR(, struct ast_dns_query \*) queries;
 /*! \brief The total number of completed querie */
 unsigned int queries_completed;
 /*! \brief Callback to invoke upon completio */
 ast_dns_query_set_callback callback;
 /*! \brief User-specific dat */
 void \*user_data;
 /*! \brief Timer for recurring resolutio */
 int timer;
};

```



Examples
========

Synchronous Resolution
----------------------

This example blocks the calling thread until resolution has completed. Once completed result information is returned.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
int test(void)
{
 RAII_VAR(struct ast_dns_result \*, result, NULL, ast_dns_result_unref);
 int res;
 struct ast_dns_record \*record;
 res = ast_dns_resolve("www.asterisk.org", ns_c_in, ns_t_a, &result);
 if (res) {
 ast_verbose(1, "Synchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 if (ast_dns_result_get_nxdomain(result)) {
 ast_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return -1;
 }
 if (ast_dns_result_get_secure(result)) {
 ast_verbose(1, "DNS result was secured\n");
 } else if (ast_dns_result_get_bogus(result)) {
 ast_verbose(1, "DNS result is bogus\n");
 return -1;
 }
 for (record = ast_dns_result_get_records(result); record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got address: %s\n", inet_ntoa(\*(struct in_addr\*)ast_dns_record_get_data(record)));
 }
 return 0;
}

```



Asynchronous Resolution
-----------------------

This example does not block the calling thread when resolving. A callback is invoked upon query completion instead. The result information can then be retrieved from the query.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
static void test_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record;
 if (ast_dns_result_get_nxdomain(result)) {
 ast_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }
 if (ast_dns_result_get_secure(result)) {
 ast_verbose(1, "DNS result was secured\n");
 } else if (ast_dns_result_get_bogus(result)) {
 ast_verbose(1, "DNS result is bogus\n");
 return;
 }
 for (record = ast_dns_result_get_records(result); record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got address: %s\n", inet_ntoa(\*(struct in_addr\*)ast_dns_record_get_data(record)));
 }
}
int test(void)
{
 int res;
 res = ast_dns_resolve_async("www.asterisk.org", ns_c_in, ns_t_a, test_callback, NULL);
 if (res) {
 ast_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



Parallel Queries
----------------

This example uses a query set to do two queries in an asynchronous manner. Each query is done on a different domain. Once both queries have completed the callback is invoked and each query result can be examined.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
#include <asterisk/dns_query_set.h>
static void test_callback(const struct ast_dns_query_query \*query_set)
{
 struct ast_dns_result \*asterisk_result = ast_dns_query_get_result(ast_dns_query_set_get(query_set, 0));
 struct ast_dns_result \*digium_result = ast_dns_query_get_result(ast_dns_query_set_get(query_set, 1));
 struct ast_dns_record \*record;
 if (!ast_dns_result_get_nxdomain(asterisk_result)) {
 ast_verbose(1, "'asterisk.org' resolution results:\n");
 for (record = ast_dns_result_get_records(asterisk_result); record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got address: %s\n", inet_ntoa(\*(struct in_addr\*)ast_dns_record_get_data(record)));
 }
 } else {
 ast_verbose(1, "'asterisk.org' domain does not exist\n");
 }
 if (!ast_dns_result_get_nxdomain(digium_result)) {
 ast_verbose(1, "'digium.com' resolution results:\n");
 for (record = ast_dns_result_get_records(digium_result); record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got address: %s\n", inet_ntoa(\*(struct in_addr\*)ast_dns_record_get_data(record)));
 }
 } else {
 ast_verbose(1, "'digium.com' domain does not exist\n");
 }
}
int test(void)
{
 struct ast_dns_query_set \*query_set;
 query_set = ast_dns_query_set_create():
 if (!query_set) {
 ast_verbose(1, "Could not create a query set for parallel resolution");
 return -1;
 }
 ast_dns_query_set_add(query_set, "www.asterisk.org", ns_c_in, ns_t_a);
 ast_dns_query_set_add(query_set, "www.digium.com", ns_c_in, ns_t_a);
 ast_dns_query_set_resolve_async(query_set, test_callback, NULL);
 ast_dns_query_set_unref(query_set);
 sleep(5);
 return 0;
}

```



Fallback
--------

This example does a fall back from an AAAA record lookup to an A record lookup if no results were available for the AAAA record lookup. This also uses the asynchronous function and the same callback is used for both queries.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
static void test_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record = ast_dns_result_get_records(result);
 if (ast_dns_result_get_nxdomain(result) || !record) {
 ast_verbose(1, "Specified domain name 'asterisk.org' does not exist or has no records\n");
 if (ast_dns_get_rr_type(query) == ns_t_aaaa) {
 /* Fall back to an A looku */
 ast_dns_resolve_async("www.asterisk.org", ns_c_in, ns_t_a, test_callback, NULL);
 }
 return;
 }
 if (ast_dns_result_get_secure(result)) {
 ast_verbose(1, "DNS result was secured\n");
 } else if (ast_dns_result_get_bogus(result)) {
 ast_verbose(1, "DNS result is bogus\n");
 return;
 }
 for (; record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got a record\n");
 }
}
int test(void)
{
 int res;
 /* Start out doing an AAAA looku */
 res = ast_dns_resolve_async("www.asterisk.org", ns_c_in, ns_t_aaaa, test_callback, NULL);
 if (res) {
 ast_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



NAPTR
-----

This example does a NAPTR lookup followed by SRV followed by AAAA and then A. The results of the NAPTR and SRV lookups are taken into account when deciding the next step to take.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
/* An alternative to this cascade approach would be using a query set to do NAPTR, SRV, AAAA, and A in parallel
 * with NAPTR and SRV adding additional queries afterwards
 */
static void a_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record = ast_dns_result_get_records(result);
 if (!record) {
 /* We have nowhere to g */
 return;
 }
 /* If we got here there is an A recor */
}
static void aaaa_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record = ast_dns_result_get_records(result);
 if (!record) {
 ast_dns_resolve_async(ast_dns_query_get_name(query), ns_c_in, ns_t_a, a_callback, NULL);
 return;
 }
 /* If we got here there is an AAAA recor */
}
static void srv_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record = ast_dns_result_get_records(result);
 if (record) {
 ast_dns_resolve_async(ast_dns_srv_get_host(record), ns_c_in, ns_t_aaaa, aaaa_callback, NULL);
 return;
 }
 ast_dns_resolve_async("asterisk.org", ns_c_in, ns_t_aaaa, aaaa_callback, NULL);
}
static void naptr_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record;
 if (ast_dns_result_get_nxdomain(result)) {
 ast_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }
 /* This is a very simplistic cascade example, it grabs the first resul */
 for (record = ast_dns_result_get_records(result); record; record = ast_dns_record_get_next(record)) {
 if (!strcmp(ast_dns_naptr_get_service(record), "SIP+D2U")) {
 ast_dns_resolve_async(ast_dns_naptr_get_replacement(record), ns_c_in, ns_t_srv, srv_callback, NULL);
 return;
 }
 }
 ast_dns_resolve_async("_sip._udp.asterisk.org", ns_c_in, ns_t_srv, srv_callback, NULL);
}
int test(void)
{
 int res;
 res = ast_dns_resolve_async("asterisk.org", ns_c_in, ns_t_naptr, naptr_callback, NULL);
 if (res) {
 ast_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```



Recurring
---------

The recurring example has the DNS core re-run the specified query according to the lowest TTL of the result records. It is up to the user to store the previous results and determine whether action should be taken or not.

```bash title=" " linenums="1"
#include <asterisk/dns.h>
static void test_callback(const struct ast_dns_query \*query)
{
 struct ast_dns_result \*result = ast_dns_query_get_result(query);
 struct ast_dns_record \*record;
 if (ast_dns_result_get_nxdomain(result)) {
 ast_verbose(1, "Specified domain name 'asterisk.org' does not exist\n");
 return;
 }

 /* Previous information should be stored and compared against new records, if different then take actio */
 for (record = ast_dns_result_get_records(result); record; record = ast_dns_record_get_next(record)) {
 ast_verbose(1, "Got address: %s\n", inet_ntoa(\*(struct in_addr\*)ast_dns_record_get_data(record)));
 }
}
int test(void)
{
 int res;
 res = ast_dns_resolve_async_recurring("www.asterisk.org", ns_c_in, ns_t_a, test_callback, NULL);
 if (res) {
 ast_verbose(1, "Asynchronous resolution of 'asterisk.org' failed\n");
 return -1;
 }
 sleep(5);
 return 0;
}

```

