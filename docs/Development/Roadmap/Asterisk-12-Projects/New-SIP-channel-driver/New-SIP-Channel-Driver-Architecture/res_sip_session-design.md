---
title: res_sip_session design
pageid: 22085841
---

!!! warning 
    This page is currently under construction. Please refrain from adding comments until this warning is removed

[//]: # (end-warning)

Overview
========

`res_sip_session` represents the "core" of SIP session operations. In the context of SIP, a "session" refers to a media session, such as a phone call. The SIP channel driver will be a consumer of the services provided by `res_sip_session`.

Startup procedure
=================

When `res_sip_session` starts up, it registers itself with `res_sip` as a service. This will cause `res_sip` to call into `res_sip_session` when new SIP messages come in. `res_sip_session` will handle those associated with sessions (i.e. INVITEs, and in-dialog REFERs, INFOs, UPDATEs, and PRACKs).

Public methods
==============

Structures
----------

```
c

/*!
 * \brief Pieces of data associated with a session
 *
 * Supplements to SIP sessions may wish to store session-specific
 * data on the session. They do this by adding cookies to the session
 * and retrieving them when needed. Session cookies are similar to
 * channel datastores.
 */
struct ast_sip_session_cookie {
 /*! Callback used to destroy the cookie's data. Called when the cookie is removed from the sessio */
 void (\*destroy)(void \*cookie);
 /*! Identifier for the cookie. Used when storing and retrieving a cooki */
 const char \*name;
 /*! Data associated with the cooki */
 void \*cookie_data;
};

/*!
 * \brief A structure describing a SIP session
 */
struct ast_sip_session {
 /* The endpoint with which Asterisk is communicatin */
 struct ast_sip_endpoint \*endpoint;
 /* The PJSIP details of the session, which includes the dialo */
 struct pjsip_inv_session \*inv_session;
 /* The Asterisk channel associated with the sessio */
 struct ast_channel \*channel;
 /* Cookies added to the session by supplements to the sessio */
 struct ao2_container \*cookies;
};

/*!
 * \brief A supplement to SIP message processing
 *
 * These can be registered by any module in order to add
 * processing to incoming and outgoing SIP requests and responses
 */
struct ast_sip_session_supplement {
 /*! Method on which to call the callbacks. If NULL, call on all method */
 const char \*method;
 /*! Notification that the session has begu */
 void (\*session_begin)(struct ast_sip_session \*session);
 /*! Notification that the session has ende */
 void (\*session_end)(struct ast_sip_session \*session);
 /*!
 * \brief Called on incoming SIP request
 * This method can indicate a failure in processing in its return. If there
 * is a failure, it is required that this method sends a response to the request.
 */
 int (\*incoming_request)(struct ast_sip_session \*session, struct pjsip_rx_data \*rdata);
 /*! Called on an incoming SIP respons */
 void (\*incoming_response)(struct ast_sip_session \*session, struct pjsip_rx_data \*rdata);
 /*! Called on an outgoing SIP reques */
 void (\*outgoing_request)(struct ast_sip_session \*session, struct pjsip_tx_data \*tdata);
 /*! Called on an outgoing SIP respons */
 void (\*outgoing_response)(struct ast_sip_session \*session, struct pjsip_tx_data \*tdata);
};

/*!
 * \brief A handler for SDPs in SIP sessions
 *
 * An SDP handler is registered by a module that is interested in being the
 * responsible party for specific types of SDP streams.
 */
struct ast_sip_session_sdp_handler {
 /*!
 * \brief Set session details based on a stream in an incoming SDP offer or answer
 * \param session The session for which the media is being negotiated
 * \param stream The stream on which to operate
 * \retval 0 The stream was not handled by this handler. If there are other registered handlers for this stream type, they will be called.
 * \retval <0 There was an error encountered. No further operation will take place and the current negotiation will be abandoned.
 * \retval >0 The stream was handled by this handler. No further handler of this stream type will be called.
 */
 int (\*handle_incoming_sdp_stream_offer)(struct ast_sip_session \*session, struct pjmedia_sdp_media \*stream);
 /*!
 * \brief Create an SDP media stream and add it to the outgoing SDP offer or answer
 * \param session The session for which media is being added
 * \param[out] stream The stream to be added to the SDP
 * \retval 0 This handler has no stream to add. If there are other registered handlers for this stream type, they will be called.
 * \retval <0 There was an error encountered. No further operation will take place and the current SDP negotiation will be abandoned.
 * \retval >0 The handler has a stream to be added to the SDP. No further handler of this stream type will be called.
 */
 int (\*create_outgoing_sdp_stream)(struct ast_sip_session \*session, struct pjmedia_sdp_session \*sdp);
};

```

Extensibility
-------------

```
c
/*!
 * \brief Register an SDP handler
 *
 * An SDP handler is responsible for parsing incoming SDPs and ensuring that
 * Asterisk can cope with the contents. Similarly, the SDP handler will be
 * responsible for constructing outgoing SDPs.
 *
 * Multiple handlers for the same stream type may be registered. They will be
 * visited in the order they were registered. Handlers will be visited for each
 * stream type until one claims to have handled the stream.
 *
 * \param handler The SDP handler to register
 * \param stream_type The type of media stream for which to call the handler
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_session_register_sdp_handler(const struct ast_sip_session_sdp_handler \*handler, const char \*stream_type);

/*!
 * \brief Unregister an SDP handler
 *
 * \param handler The SDP handler to unregister
 */
void ast_sip_session_unregister_sdp_handler(const struct ast_sip_session_sdp_handler \*handler);

/*!
 * \brief Register a supplement to SIP session processing
 *
 * This allows for someone to insert themselves in the processing of SIP
 * requests and responses. This, for example could allow for a module to
 * set channel data based on headers in an incoming message. Similarly,
 * a module could reject an incoming request if desired.
 *
 * \param supplement The supplement to register
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_session_register_supplement(struct ast_sip_session_supplement \*supplement);

/*!
 * \brief Unregister a an supplement to SIP session processing
 *
 * \param supplement The supplement to unregister
 */
void ast_sip_session_unregister_supplement(struct ast_sip_session_supplement \*supplement);

/*!
 * \brief Add a cookie to a SIP session
 * \param session The session to add the cookie to
 * \param cookie The cookie to be added to the session
 * \retval 0 Success
 * \retval -1 Failure
 */
int ast_sip_session_add_cookie(struct ast_sip_session \*session, struct ast_sip_session_cookie \*cookie);

/*!
 * \brief Retrieve a session cookie
 * \param session The session from which to retrieve the cookie
 * \param name The name of the cookie to retrieve
 * \retval NULL Failed to find the specified cookie
 * \retval non-NULL The specified cookie
 */
struct ast_sip_session_cookie \*ast_sip_session_get_cookie(struct ast_sip_session \*session, const char \*name);

/*!
 * \brief Remove a session cookie from the session
 *
 * This will cause the cookie's destroy() callback to be called
 *
 * \param session The session to remove the cookie from
 * \param name The name of the cookie to remove
 * \retval 0 Successfully removed the cookie
 * \retval -1 Failed to remove the cookie
 */
int ast_sip_session_remove_cookie(struct ast_sip_session \*session, const char \*name);

```

Common SIP methods
------------------

```
c
/*!
 * \brief Retrieve identifying information from an incoming request
 *
 * This will retrieve identifying information and place it in the
 * id parameter. The caller of the function can then apply this to
 * caller ID, connected line, or whatever else may be proper.
 *
 * \param rdata The incoming request or response
 * \param[out] id The collected identity information
 * \retval 0 Successfully found identifying information
 * \retval -1 Identifying information could not be found
 */
int ast_sip_session_get_identity(struct pjsip_rx_data \*rdata, struct ast_party_id \*id);

/*!
 * \brief Send a reinvite on a session
 *
 * This method will inspect the session in order to construct an appropriate
 * reinvite. As with any outgoing request in res_sip_session, this will
 * call into registered supplements in case they wish to add anything.
 * 
 * \param session The session on which the reinvite will be sent
 * \param response_cb Optional callback that can be called when the reinvite response is received. The callback is identical in nature to the incoming_response() callback for session supplements.
 * \retval 0 Successfully sent reinvite
 * \retval -1 Failure to send reinvite
 */
int ast_sip_session_send_reinvite(struct ast_sip_session \*session, int (\*response_cb)(struct ast_sip_session \*session, struct pjsip_rx_data \*rdata));

/*!
 * \brief Send a SIP response
 *
 * This will send a SIP response to the request specified in rdata. This will
 * call into any registered supplements' outgoing_response callback.
 *
 * \param session The session to which the current transaction belongs
 * \param response_code The response code to send for this response
 * \param rdata The response to which the response is being sent
 */
int ast_sip_session_send_response(struct ast_sip_session \*session, int response_code, struct pjsip_rx_data \*rdata);

```
