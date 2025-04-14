---
title: Overview
pageid: 22085835
---

!!! warning 
    This page is a work in progress. Please refrain from making comments until this warning has been removed

[//]: # (end-warning)

Overview
========

res_sip is the decadent dark chocolate core of the new SIP work in Asterisk 12. It is the cockpit of the SIP jet. As such, its contents are those upon which all other SIP modules (and potentially non-SIP modules) will rely. The following describes its design and its public APIs.

Makeup
======

res_sip can be divided into four overall sections:

* service registrar
* SIP threadpool operator
* provider of common SIP methods
* servicer of PJSIP endpoint (i.e. reads incoming SIP messages)

Startup process
===============

On startup, res_sip will create a threadpool for SIP to use. The threadpool's specifics will be discussed on a separate page. The threadpool will be used for as much of SIP's operation as possible. After starting the threadpool, res_sip will create a PJSIP endpoint and then begin handling incoming requests from the endpoint.

Public methods
==============

Structures
----------

```
c
/*!
 * \brief Opaque structure representing related SIP tasks
 */
struct ast_sip_work;

/*!
 * \brief Data used for creating authentication challenges.
 * 
 * This data gets populated by an authenticator's get_authentication_credentials() callback.
 */
struct ast_sip_digest_challenge_data {
 /*!
 * The realm to which the user is authenticating. An authenticator MUST fill this in.
 */
 const char \*realm;
 /*!
 * Indicates whether the username and password are in plaintext or encoded as MD5.
 * If this is non-zero, then the data is an MD5 sum. Otherwise, the username and password are plaintext.
 * Authenticators MUST set this.
 */
 int is_md5;
 /*!
 * This is the actual username and secret. The is_md5 field is used to determine which member
 * of the union is to be used when creating the authentication challenge. In other words, if
 * is_md5 is non-zero, then we will use the md5 field of the auth union. Otherwise, we will
 * use the plain struct in the auth union.
 * Authenticators MUST fill in the appropriate field of the union.
 */
 union {
 /*!
 * Structure containing the username and password to encode in a digest authentication challenge.
 */
 struct {
 const char \*username;
 const char \*password;
 } plain;
 /*!
 * An MD5-encoded string that incorporates the username and password.
 */
 const char \*md5;
 } auth;
 /*!
 * Domain for which the authentication challenge is being sent. This corresponds to the "domain=" portion of
 * a digest authentication.
 *
 * Authenticators do not have to fill in this field since it is an optional part of a digest.
 */
 const char \*domain;
 /*!
 * Opaque string for digest challenge. This corresponds to the "opaque=" portion of a digest authentication.
 * Authenticators do not have to fill in this field. If an authenticator does not fill it in, Asterisk will provide one.
 */
 const char \*opaque;
 /*!
 * Nonce string for digest challenge. This corresponds to the "nonce=" portion of a digest authentication.
 * Authenticators do not have to fill in this field. If an authenticator does not fill it in, Asterisk will provide one.
 */
 const char \*nonce;
};

/*!
 * \brief An interchangeable way of handling digest authentication for SIP.
 * 
 * An authenticator is responsible for filling in the callbacks provided below. Each is called from a publicly available
 * function in res_sip. The authenticator can use configuration or other local policy to determine whether authentication
 * should take place and what credentials should be used when challenging and authenticating a request.
 */
struct ast_sip_authenticator {
 /*! 
 * \brief Check if a request requires authentication
 * See ast_sip_requires_authentication for more details
 */
 int (\*requires_authentication)(struct ast_sip_endpoint \*endpoint, struct pjsip_rx_data \*rdata);
 /*!
 * \brief Attempt to authenticate the incoming request
 * See ast_sip_authenticate_request for more details
 */
 int (\*authenticate_request)(struct ast_sip_endpoint \*endpoint, struct pjsip_rx_data \*rdata);
 /*!
 * \brief Get digest authentication details
 * See ast_sip_get_authentication_credentials for more details
 */
 int (\*get_authentication_credentials)(struct ast_sip_endpoint \*endpoint, struct sip_digest_challenge_data \*challenge);
};

/*!
 * \brief An entity responsible for identifying the source of a SIP message
 */
struct ast_sip_endpoint_identifier {
 /*!
 * \brief Callback used to identify the source of a message.
 * See ast_sip_identify_endpoint for more details
 */
 struct ast_sip_endpoint \*(\*identify_endpoint)(struct pjsip_rx_data \*data);
};

```

Service registration
--------------------

```
c
/*!
 * \brief Register a SIP service in Asterisk.
 *
 * This is more-or-less a wrapper around pjsip_endpt_register_module().
 * Registering a service makes it so that PJSIP will call into the
 * service at appropriate times. For more information about PJSIP module
 * callbacks, see the PJSIP documentation. Asterisk modules that call
 * this function will likely do so at module load time.
 *
 * \param module The module that is to be registered with PJSIP
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_register_service(pjsip_module \*module);

/*!
 * This is the opposite of ast_sip_register_service(). Unregistering a
 * service means that PJSIP will no longer call into the module any more.
 * This will likely occur when an Asterisk module is unloaded.
 *
 * \param module The PJSIP module to unregister
 */
void ast_sip_unregister_service(pjsip_module \*module);

/*!
 * \brief Register a SIP authenticator
 *
 * An authenticator has three main purposes:
 * 1) Determining if authentication should be performed on an incoming request
 * 2) Gathering credentials necessary for issuing an authentication challenge
 * 3) Authenticating a request that has credentials
 *
 * Asterisk provides a default authenticator, but it may be replaced by a
 * custom one if desired.
 *
 * \param auth The authenticator to register
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_register_authenticator(struct ast_sip_authenticator \*auth);

/*!
 * \brief Unregister a SIP authenticator
 *
 * When there is no authenticator registered, requests cannot be challenged
 * or authenticated.
 *
 * \param auth The authenticator to unregister
 */
void ast_sip_unregister_authenticator(struct ast_sip_authenticator \*auth);

/*!
 * \brief Register a SIP endpoint identifier
 *
 * An endpoint identifier's purpose is to determine which endpoint a given SIP
 * message has come from.
 *
 * Multiple endpoint identifiers may be registered so that if an endpoint
 * cannot be identified by one identifier, it may be identified by another.
 *
 * Asterisk provides two endpoint identifiers. One identifies endpoints based
 * on the user part of the From header URI. The other identifies endpoints based
 * on the source IP address.
 *
 * If the order in which endpoint identifiers is run is important to you, then
 * be sure to load individual endpoint identifier modules in the order you wish
 * for them to be run in modules.conf
 *
 * \param identifier The SIP endpoint identifier to register
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_register_endpoint_identifier(struct ast_sip_endpoint_identifier \*identifier);

/*!
 * \brief Unregister a SIP endpoint identifier
 *
 * This stops an endpoint identifier from being used.
 *
 * \param identifier The SIP endoint identifier to unregister
 */
void ast_sip_unregister_endpoint_identifier(struct ast_sip_endpoint_identifier \*identifier);

```

Threadpool usage
----------------

```
c
/*!
 * \brief Create a new SIP work structure
 *
 * A SIP work is a means of grouping together SIP tasks. For instance, one
 * might create a SIP work so that all tasks for a given SIP dialog will
 * be grouped together. Grouping the work together ensures that the
 * threadpool will distribute the tasks in such a way so that grouped work
 * will execute sequentially. Executing grouped tasks sequentially means
 * less contention for shared resources.
 *
 * \retval NULL Failure
 * \retval non-NULL Newly-created SIP work
 */
struct ast_sip_work \*ast_sip_create_work(void);

/*!
 * \brief Destroy a SIP work structure
 *
 * \param work The SIP work to destroy
 */
void ast_sip_destroy_work(struct ast_sip_work \*work);

/*!
 * \brief Pushes a task into the SIP threadpool
 *
 * This uses the SIP work provided to determine how to push the task.
 *
 * \param work The SIP work to which the task belongs
 * \param sip_task The task to execute
 * \param task_data The parameter to pass to the task when it executes
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_push_task(struct ast_sip_work \*work, int (\*sip_task)(void \*), void \*task_data);

```

Common SIP methods
------------------

```
c
/*!
 * \brief General purpose method for sending a SIP request
 *
 * Its typical use would be to send one-off messages such as an out of dialog
 * SIP MESSAGE.
 *
 * \param method The method of the SIP request to send
 * \param body The message body for the SIP request
 * \dlg Optional. If specified, the dialog on which to send the message. Otherwise, the message
 * will be sent out of dialog.
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_send_request(const char \*method, const char \*body, struct pjsip_dialog \*dlg);

/*!
 * \brief Determine if an incoming request requires authentication
 *
 * This calls into the registered authenticator's requires_authentication callback
 * in order to determine if the request requires authentication.
 *
 * If there is no registered authenticator, then authentication will be assumed
 * not to be required.
 *
 * \param endpoint The endpoint from which the request originates
 * \param rdata The incoming SIP request
 * \retval non-zero The request requires authentication
 * \retval 0 The request does not require authentication
 */
int ast_sip_requires_authentication(struct ast_sip_endpoint \*endpoint, struct pjsip_rx_data \*rdata);

/*!
 * \brief Authenticate an inbound SIP request
 *
 * This calls into the registered authenticator's authenticate_request callback
 * in order to determine if the request contains proper credentials as to be
 * authenticated.
 *
 * If there is no registered authenticator, then the request will assumed to be
 * authenticated properly.
 *
 * \param endpoint The endpoint from which the request originates
 * \param rdata The incoming SIP request
 * \retval 0 Successfully authenticated
 * \retval nonzero Failure to authenticate
 */
int ast_sip_authenticate_request(struct ast_sip_endpoint \*endpoint, struct pjsip_rx_data \*rdata);

/*!
 * \brief Get authentication credentials in order to challenge a request
 *
 * This calls into the registered authenticator's get_authentication_credentials
 * callback in order to get credentials required for challenging a request.
 *
 * \param endpoint The endpoint whose credentials are being gathered
 * \param[out] challenge The necessary data in order to be able to challenge a request
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_get_authentication_credentials(struct ast_sip_endpoint \*endpoint, struct ast_sip_digest_challenge_data \*challenge);

/*!
 * \brief Possible returns from ast_sip_check_authentication
 */
enum ast_sip_check_auth_result {
 /*! Authentication challenge sen */
 AST_SIP_AUTHENTICATION_CHALLENGE_SENT,
 /*! Authentication succeede */
 AST_SIP_AUTHENTICATION_SUCCESS,
 /*! Authentication faile */
 AST_SIP_AUTHENTICATION_FAILED,
 /*! Authentication not require */
 AST_SIP_AUTHENTICATION_NOT_REQUIRED,
};

/*!
 * \brief Shortcut routine to check for authentication of an incoming request
 *
 * This is a wrapper that will call into a registered authenticator to see if a request
 * should be authenticated. Then if it should be, will attempt to authenticate. If the
 * request cannot be authenticated, then a challenge will be sent. Calling this can be
 * a suitable substitute for calling ast_sip_requires_authentication(),
 * ast_sip_authenticate_request(), and ast_sip_get_authentication_credentials()
 *
 * \param endpoint The endpoint from the request was sent
 * \param rdata The request to potentially authenticate
 * \return The result of checking authentication.
 */
ast_sip_check_authentication(struct ast_sip_endpoint \*endpoint, struct pjsip_rxdata \*rdata);

/*!
 * \brief Challenge an inbound SIP request with a 401
 *
 *
 * This method will send an authentication challenge based on the details
 * given in its parameter
 *
 * \param challenge Details to help in constructing a WWW-Authenticate header
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_challenge_request(struct sip_digest_challenge_data \*challenge);

/*!
 * \brief Determine the endpoint that has sent a SIP message
 *
 * This will call into each of the registered endpoint identifiers'
 * identify_endpoint() callbacks until one returns a non-NULL endpoint.
 * This will return an ao2 object. Its reference count will need to be
 * decremented when completed using the endpoint.
 *
 * \param rdata The inbound SIP message to use when identifying the endpoint.
 * \retval NULL No matching endpoint
 * \retval non-NULL The matching endpoint
 */
struct ast_sip_endpoint \*ast_sip_identify_endpoint(struct pjsip_rx_data \*rdata);

/*!
 * \brief Add a header to an outbound SIP message
 *
 * \param tdata The message to add the header to
 * \param name The header name
 * \param value The header value
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_add_header(struct pjsip_tx_data \*tdata, const char \*name, const char \*value);

/*!
 * \brief Add a body to an outbound SIP message
 *
 * If this is called multiple times, the latest body will replace the current
 * body.
 *
 * \param tdata The message to add the body to
 * \param body The message body to add
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_add_body(struct pjsip_tx_data \*tdata, const char \*body);

/*!
 * \brief Add a multipart body to an outbound SIP message
 *
 * This will treat each part of the input array as part of a multipart body and
 * add each part to the SIP message.
 *
 * \param tdata The message to add the body to
 * \param bodies The parts of the body to add
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_add_body(struct pjsip_tx_data \*tdata, const char \*bodies[]);

/*!
 * \brief Append body data to a SIP message
 *
 * This acts mostly the same as ast_sip_add_body, except that rather than replacing
 * a body if it currently exists, it appends data to an existing body.
 *
 * \param tdata The message to append the body to
 * \param body The string to append to the end of the current body
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_append_body(struct pjsip_tx_data \*tdata, const char \*body);

```
