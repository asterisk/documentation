---
title: Overview
pageid: 22085835
---




---

**WARNING!:**   

This page is a work in progress. Please refrain from making comments until this warning has been removed

  



---


Overview
========


res\_sip is the decadent dark chocolate core of the new SIP work in Asterisk 12. It is the cockpit of the SIP jet. As such, its contents are those upon which all other SIP modules (and potentially non-SIP modules) will rely. The following describes its design and its public APIs.


Makeup
======


res\_sip can be divided into four overall sections:


* service registrar
* SIP threadpool operator
* provider of common SIP methods
* servicer of PJSIP endpoint (i.e. reads incoming SIP messages)


Startup process
===============


On startup, res\_sip will create a threadpool for SIP to use. The threadpool's specifics will be discussed on a separate page. The threadpool will be used for as much of SIP's operation as possible. After starting the threadpool, res\_sip will create a PJSIP endpoint and then begin handling incoming requests from the endpoint.


Public methods
==============


Structures
----------




---

  
  


```

c
/\*!
 \* \brief Opaque structure representing related SIP tasks
 \*/
struct ast\_sip\_work;

/\*!
 \* \brief Data used for creating authentication challenges.
 \* 
 \* This data gets populated by an authenticator's get\_authentication\_credentials() callback.
 \*/
struct ast\_sip\_digest\_challenge\_data {
 /\*!
 \* The realm to which the user is authenticating. An authenticator MUST fill this in.
 \*/
 const char \*realm;
 /\*!
 \* Indicates whether the username and password are in plaintext or encoded as MD5.
 \* If this is non-zero, then the data is an MD5 sum. Otherwise, the username and password are plaintext.
 \* Authenticators MUST set this.
 \*/
 int is\_md5;
 /\*!
 \* This is the actual username and secret. The is\_md5 field is used to determine which member
 \* of the union is to be used when creating the authentication challenge. In other words, if
 \* is\_md5 is non-zero, then we will use the md5 field of the auth union. Otherwise, we will
 \* use the plain struct in the auth union.
 \* Authenticators MUST fill in the appropriate field of the union.
 \*/
 union {
 /\*!
 \* Structure containing the username and password to encode in a digest authentication challenge.
 \*/
 struct {
 const char \*username;
 const char \*password;
 } plain;
 /\*!
 \* An MD5-encoded string that incorporates the username and password.
 \*/
 const char \*md5;
 } auth;
 /\*!
 \* Domain for which the authentication challenge is being sent. This corresponds to the "domain=" portion of
 \* a digest authentication.
 \*
 \* Authenticators do not have to fill in this field since it is an optional part of a digest.
 \*/
 const char \*domain;
 /\*!
 \* Opaque string for digest challenge. This corresponds to the "opaque=" portion of a digest authentication.
 \* Authenticators do not have to fill in this field. If an authenticator does not fill it in, Asterisk will provide one.
 \*/
 const char \*opaque;
 /\*!
 \* Nonce string for digest challenge. This corresponds to the "nonce=" portion of a digest authentication.
 \* Authenticators do not have to fill in this field. If an authenticator does not fill it in, Asterisk will provide one.
 \*/
 const char \*nonce;
};

/\*!
 \* \brief An interchangeable way of handling digest authentication for SIP.
 \* 
 \* An authenticator is responsible for filling in the callbacks provided below. Each is called from a publicly available
 \* function in res\_sip. The authenticator can use configuration or other local policy to determine whether authentication
 \* should take place and what credentials should be used when challenging and authenticating a request.
 \*/
struct ast\_sip\_authenticator {
 /\*! 
 \* \brief Check if a request requires authentication
 \* See ast\_sip\_requires\_authentication for more details
 \*/
 int (\*requires\_authentication)(struct ast\_sip\_endpoint \*endpoint, struct pjsip\_rx\_data \*rdata);
 /\*!
 \* \brief Attempt to authenticate the incoming request
 \* See ast\_sip\_authenticate\_request for more details
 \*/
 int (\*authenticate\_request)(struct ast\_sip\_endpoint \*endpoint, struct pjsip\_rx\_data \*rdata);
 /\*!
 \* \brief Get digest authentication details
 \* See ast\_sip\_get\_authentication\_credentials for more details
 \*/
 int (\*get\_authentication\_credentials)(struct ast\_sip\_endpoint \*endpoint, struct sip\_digest\_challenge\_data \*challenge);
};

/\*!
 \* \brief An entity responsible for identifying the source of a SIP message
 \*/
struct ast\_sip\_endpoint\_identifier {
 /\*!
 \* \brief Callback used to identify the source of a message.
 \* See ast\_sip\_identify\_endpoint for more details
 \*/
 struct ast\_sip\_endpoint \*(\*identify\_endpoint)(struct pjsip\_rx\_data \*data);
};


```



---


Service registration
--------------------




---

  
  


```

c
/\*!
 \* \brief Register a SIP service in Asterisk.
 \*
 \* This is more-or-less a wrapper around pjsip\_endpt\_register\_module().
 \* Registering a service makes it so that PJSIP will call into the
 \* service at appropriate times. For more information about PJSIP module
 \* callbacks, see the PJSIP documentation. Asterisk modules that call
 \* this function will likely do so at module load time.
 \*
 \* \param module The module that is to be registered with PJSIP
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_register\_service(pjsip\_module \*module);

/\*!
 \* This is the opposite of ast\_sip\_register\_service(). Unregistering a
 \* service means that PJSIP will no longer call into the module any more.
 \* This will likely occur when an Asterisk module is unloaded.
 \*
 \* \param module The PJSIP module to unregister
 \*/
void ast\_sip\_unregister\_service(pjsip\_module \*module);

/\*!
 \* \brief Register a SIP authenticator
 \*
 \* An authenticator has three main purposes:
 \* 1) Determining if authentication should be performed on an incoming request
 \* 2) Gathering credentials necessary for issuing an authentication challenge
 \* 3) Authenticating a request that has credentials
 \*
 \* Asterisk provides a default authenticator, but it may be replaced by a
 \* custom one if desired.
 \*
 \* \param auth The authenticator to register
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_register\_authenticator(struct ast\_sip\_authenticator \*auth);

/\*!
 \* \brief Unregister a SIP authenticator
 \*
 \* When there is no authenticator registered, requests cannot be challenged
 \* or authenticated.
 \*
 \* \param auth The authenticator to unregister
 \*/
void ast\_sip\_unregister\_authenticator(struct ast\_sip\_authenticator \*auth);

/\*!
 \* \brief Register a SIP endpoint identifier
 \*
 \* An endpoint identifier's purpose is to determine which endpoint a given SIP
 \* message has come from.
 \*
 \* Multiple endpoint identifiers may be registered so that if an endpoint
 \* cannot be identified by one identifier, it may be identified by another.
 \*
 \* Asterisk provides two endpoint identifiers. One identifies endpoints based
 \* on the user part of the From header URI. The other identifies endpoints based
 \* on the source IP address.
 \*
 \* If the order in which endpoint identifiers is run is important to you, then
 \* be sure to load individual endpoint identifier modules in the order you wish
 \* for them to be run in modules.conf
 \*
 \* \param identifier The SIP endpoint identifier to register
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_register\_endpoint\_identifier(struct ast\_sip\_endpoint\_identifier \*identifier);

/\*!
 \* \brief Unregister a SIP endpoint identifier
 \*
 \* This stops an endpoint identifier from being used.
 \*
 \* \param identifier The SIP endoint identifier to unregister
 \*/
void ast\_sip\_unregister\_endpoint\_identifier(struct ast\_sip\_endpoint\_identifier \*identifier);


```



---


Threadpool usage
----------------




---

  
  


```

c
/\*!
 \* \brief Create a new SIP work structure
 \*
 \* A SIP work is a means of grouping together SIP tasks. For instance, one
 \* might create a SIP work so that all tasks for a given SIP dialog will
 \* be grouped together. Grouping the work together ensures that the
 \* threadpool will distribute the tasks in such a way so that grouped work
 \* will execute sequentially. Executing grouped tasks sequentially means
 \* less contention for shared resources.
 \*
 \* \retval NULL Failure
 \* \retval non-NULL Newly-created SIP work
 \*/
struct ast\_sip\_work \*ast\_sip\_create\_work(void);

/\*!
 \* \brief Destroy a SIP work structure
 \*
 \* \param work The SIP work to destroy
 \*/
void ast\_sip\_destroy\_work(struct ast\_sip\_work \*work);

/\*!
 \* \brief Pushes a task into the SIP threadpool
 \*
 \* This uses the SIP work provided to determine how to push the task.
 \*
 \* \param work The SIP work to which the task belongs
 \* \param sip\_task The task to execute
 \* \param task\_data The parameter to pass to the task when it executes
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_push\_task(struct ast\_sip\_work \*work, int (\*sip\_task)(void \*), void \*task\_data);


```



---


Common SIP methods
------------------




---

  
  


```

c
/\*!
 \* \brief General purpose method for sending a SIP request
 \*
 \* Its typical use would be to send one-off messages such as an out of dialog
 \* SIP MESSAGE.
 \*
 \* \param method The method of the SIP request to send
 \* \param body The message body for the SIP request
 \* \dlg Optional. If specified, the dialog on which to send the message. Otherwise, the message
 \* will be sent out of dialog.
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_send\_request(const char \*method, const char \*body, struct pjsip\_dialog \*dlg);

/\*!
 \* \brief Determine if an incoming request requires authentication
 \*
 \* This calls into the registered authenticator's requires\_authentication callback
 \* in order to determine if the request requires authentication.
 \*
 \* If there is no registered authenticator, then authentication will be assumed
 \* not to be required.
 \*
 \* \param endpoint The endpoint from which the request originates
 \* \param rdata The incoming SIP request
 \* \retval non-zero The request requires authentication
 \* \retval 0 The request does not require authentication
 \*/
int ast\_sip\_requires\_authentication(struct ast\_sip\_endpoint \*endpoint, struct pjsip\_rx\_data \*rdata);

/\*!
 \* \brief Authenticate an inbound SIP request
 \*
 \* This calls into the registered authenticator's authenticate\_request callback
 \* in order to determine if the request contains proper credentials as to be
 \* authenticated.
 \*
 \* If there is no registered authenticator, then the request will assumed to be
 \* authenticated properly.
 \*
 \* \param endpoint The endpoint from which the request originates
 \* \param rdata The incoming SIP request
 \* \retval 0 Successfully authenticated
 \* \retval nonzero Failure to authenticate
 \*/
int ast\_sip\_authenticate\_request(struct ast\_sip\_endpoint \*endpoint, struct pjsip\_rx\_data \*rdata);

/\*!
 \* \brief Get authentication credentials in order to challenge a request
 \*
 \* This calls into the registered authenticator's get\_authentication\_credentials
 \* callback in order to get credentials required for challenging a request.
 \*
 \* \param endpoint The endpoint whose credentials are being gathered
 \* \param[out] challenge The necessary data in order to be able to challenge a request
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_get\_authentication\_credentials(struct ast\_sip\_endpoint \*endpoint, struct ast\_sip\_digest\_challenge\_data \*challenge);

/\*!
 \* \brief Possible returns from ast\_sip\_check\_authentication
 \*/
enum ast\_sip\_check\_auth\_result {
 /\*! Authentication challenge sent \*/
 AST\_SIP\_AUTHENTICATION\_CHALLENGE\_SENT,
 /\*! Authentication succeeded \*/
 AST\_SIP\_AUTHENTICATION\_SUCCESS,
 /\*! Authentication failed \*/
 AST\_SIP\_AUTHENTICATION\_FAILED,
 /\*! Authentication not required \*/
 AST\_SIP\_AUTHENTICATION\_NOT\_REQUIRED,
};

/\*!
 \* \brief Shortcut routine to check for authentication of an incoming request
 \*
 \* This is a wrapper that will call into a registered authenticator to see if a request
 \* should be authenticated. Then if it should be, will attempt to authenticate. If the
 \* request cannot be authenticated, then a challenge will be sent. Calling this can be
 \* a suitable substitute for calling ast\_sip\_requires\_authentication(),
 \* ast\_sip\_authenticate\_request(), and ast\_sip\_get\_authentication\_credentials()
 \*
 \* \param endpoint The endpoint from the request was sent
 \* \param rdata The request to potentially authenticate
 \* \return The result of checking authentication.
 \*/
ast\_sip\_check\_authentication(struct ast\_sip\_endpoint \*endpoint, struct pjsip\_rxdata \*rdata);

/\*!
 \* \brief Challenge an inbound SIP request with a 401
 \*
 \*
 \* This method will send an authentication challenge based on the details
 \* given in its parameter
 \*
 \* \param challenge Details to help in constructing a WWW-Authenticate header
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_challenge\_request(struct sip\_digest\_challenge\_data \*challenge);

/\*!
 \* \brief Determine the endpoint that has sent a SIP message
 \*
 \* This will call into each of the registered endpoint identifiers'
 \* identify\_endpoint() callbacks until one returns a non-NULL endpoint.
 \* This will return an ao2 object. Its reference count will need to be
 \* decremented when completed using the endpoint.
 \*
 \* \param rdata The inbound SIP message to use when identifying the endpoint.
 \* \retval NULL No matching endpoint
 \* \retval non-NULL The matching endpoint
 \*/
struct ast\_sip\_endpoint \*ast\_sip\_identify\_endpoint(struct pjsip\_rx\_data \*rdata);

/\*!
 \* \brief Add a header to an outbound SIP message
 \*
 \* \param tdata The message to add the header to
 \* \param name The header name
 \* \param value The header value
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_add\_header(struct pjsip\_tx\_data \*tdata, const char \*name, const char \*value);

/\*!
 \* \brief Add a body to an outbound SIP message
 \*
 \* If this is called multiple times, the latest body will replace the current
 \* body.
 \*
 \* \param tdata The message to add the body to
 \* \param body The message body to add
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_add\_body(struct pjsip\_tx\_data \*tdata, const char \*body);

/\*!
 \* \brief Add a multipart body to an outbound SIP message
 \*
 \* This will treat each part of the input array as part of a multipart body and
 \* add each part to the SIP message.
 \*
 \* \param tdata The message to add the body to
 \* \param bodies The parts of the body to add
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_add\_body(struct pjsip\_tx\_data \*tdata, const char \*bodies[]);

/\*!
 \* \brief Append body data to a SIP message
 \*
 \* This acts mostly the same as ast\_sip\_add\_body, except that rather than replacing
 \* a body if it currently exists, it appends data to an existing body.
 \*
 \* \param tdata The message to append the body to
 \* \param body The string to append to the end of the current body
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_append\_body(struct pjsip\_tx\_data \*tdata, const char \*body);


```



---


