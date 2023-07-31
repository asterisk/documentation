---
title: Writing a SIP Session Supplement
pageid: 22773976
---

If you are unfamiliar with what a SIP session supplement is, please see [this](/Development/Roadmap/Asterisk-12-Projects/New-SIP-channel-driver/How-to-extend-SIP-functionality-in-Asterisk) for an explanation.

Problem overview
================

For our tutorial, we will be implementing (a simple version of) [RFC 5373](http://tools.ietf.org/html/rfc5373). This RFC defines a way to indicate to a user agent that it should automatically respond to the incoming INVITE with a 200 OK response. For this tutorial, we will be implementing the UAC version of this so that Asterisk can request that outgoing calls are automatically answered by the recipient.

Method of solution
==================

In order to solve this problem, we will write a simple session supplement that is capable of adding information to outgoing INVITE requests to add appropriate headers to request that the recipient of the INVITE automatically answers the call. The headers will be added if there exists a channel variable called `SIP_AUTO_ANSWER` on the outbound channel.




!!! warning 
    What follows is a very naive implementation of of the auto-answer feature in SIP. In actuality, there is more to this, such as determining the capability of a SIP UA to understand the "answermode" option. In addition, there are headers beyond what we add here in order to indicate a "privileged" answer mode, as well as headers that direct proxies what sort of UAs to send and not to send an INVITE to.

    For demonstration purposes of a SIP session supplement, however, this should get the appropriate point across.

      
[//]: # (end-warning)



Creating the supplement
=======================

Let's start by creating a new file called `res_pjsip_auto_answer.c` and place it in the `res` directory of the Asterisk source. Placing the file there will automatically result in a loadable module being built when a `make` command is run.

Base module code
----------------

Let's consider what we need to do for this feature to work. All we have to do is conditionally add headers to outbound INVITE requests. We don't need to do anything with inbound requests or responses and we don't need to do anything with outbound responses. Given that, let's go ahead and define the session supplement we're going to use:




```bash title="res_pjsip_auto_answer.c  " linenums="1"
#include "asterisk.h"

#include <pjsip.h>
#include <pjsip_ua.h>
#include <pjlib.h>

#include "asterisk/res_pjsip.h"
#include "asterisk/res_pjsip_session.h"
#include "asterisk/module.h"

/*\*\* MODULEINFO
 <depend>pjproject</depend>
 <depend>res_pjsip</depend>
 <depend>res_pjsip_session</depend>
 *\* */
static void auto_answer_outgoing_request(struct ast_sip_session \*session, pjsip_tx_data \*tdata)
{
 /* STU */
}

static struct ast_sip_session_supplement auto_answer_supplement = {
 .method = "INVITE",
 .outgoing_request = auto_answer_outgoing_request,
};

static int load_module(void)
{
 if (ast_sip_session_register_supplement(&auto_answer_supplement)) {
 return AST_MODULE_LOAD_DECLINE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

static int unload_module(void)
{
 ast_sip_session_unregister_supplement(&auto_answer_supplement);
 return 0;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, AST_MODFLAG_LOAD_ORDER, "SIP Auto Answer Support",
 .load = load_module,
 .unload = unload_module,
 .load_pri = AST_MODPRI_APP_DEPEND,
 );


```


### Initial directives

Let's go into deeper detail about what we have just written. Let's start at the top:




---

  
  


```

c#include "asterisk.h"

#include <pjsip.h>
#include <pjsip_ua.h>
#include <pjlib.h>

#include "asterisk/res_pjsip.h"
#include "asterisk/res_pjsip_session.h"
#include "asterisk/module.h"

/*\*\* MODULEINFO
 <depend>pjproject</depend>
 <depend>res_pjsip</depend>
 <depend>res_pjsip_session</depend>
 *\* */


```


The `#includes` here grab the necessary headers we will need. All code in Asterisk starts by including `asterisk.h`. After that, we will need the `pjsip.h, `pjsip_ua.h`,` and `pjlib.h` files in order to make use of PJSIP functions. We will use these later in the tutorial. The inclusion of `asterisk/res_pjsip.h` and `asterisk/res_pjsip_session.h` is what allows us to be able to create a session supplement. Finally, the inclusion of `asterisk/module.h` is necessary since our file is going to be a loadable module in Asterisk.

The `MODULEINFO` block is used by the menuselect system in Asterisk in order to allow for the module to only be selectable if the necessary dependencies are met. In our case, we need the PJPROJECT library to be present, and we need `res_pjsip` and `res_pjsip_session` to be built as well, since they supply the APIs for using session supplements.

### Module boilerplate

Next let's jump down to the bottom of the file:




---

  
  


```

cstatic int load_module(void)
{
 if (ast_sip_session_register_supplement(&auto_answer_supplement)) {
 return AST_MODULE_LOAD_DECLINE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

static int unload_module(void)
{
 ast_sip_session_unregister_supplement(&auto_answer_supplement);
 return 0;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, AST_MODFLAG_LOAD_ORDER, "SIP Auto Answer Support",
 .load = load_module,
 .unload = unload_module,
 .load_pri = AST_MODPRI_APP_DEPEND,
 );


```


We will not go into a lot of detail about the module-specific code here since it is covered in a tutorial [here](/Development/Reference-Information/Asterisk-Framework-and-API-Examples/Modules). However, notice that when the module loads, it registers the `auto_answer_supplement` with `res_pjsip_session` and when the module unloads, it unregisters the `auto_answer_supplement`.

### The session supplement

Now let's have a look at the important part of the code:




---

  
  


```

cstatic void auto_answer_outgoing_request(struct ast_sip_session \*session, pjsip_tx_data \*tdata)
{
 /* STU */
}

static struct ast_sip_session_supplement auto_answer_supplement = {
 .method = "INVITE",
 .outgoing_request = auto_answer_outgoing_request,
};


```


Let's start with the bottom struct declaration. It defines a session supplement called `auto_answer_supplement`. For this supplement, the important fields to fill out are the `method` and the `outgoing_request` fields. By setting `.method = "INVITE"` it tells `res_pjsip_session` only to call into this supplement on INVITEs and not for other methods. If the method had been left empty, then the supplement would be called into for all SIP method types. We also set `.outgoing_request`. This makes it so that on outgoing SIP requests, our method will be called. Combined with the earlier `method` setting, it means that our session will only be called into for outgoing INVITE requests. Other session supplement fields are as follows:

* `outgoing_response`: The specified callback is called when an outgoing SIP response is sent on the session.
* `incoming_request`: The specified callback is called when an incoming SIP request arrives on the session.
* `incoming_response`: The specified callback is called when an incoming SIP response arrives on the session.
* `priority`: This is mostly applicable to session supplements that wish to act on the initial incoming INVITE in a session. This will help determine when the supplements are called. Supplements with lower numbered priority are called before those with higher numbers. The most common use for this is to ensure that the supplement is called either before or after the `ast_channel` associated with the session is created.

Our `outgoing_request` callback currently is just a stub. The next thing we are going to do is try to start filling it in. We'll start by unconditionally adding the necessary auto answer headers to the outbound INVITE. For the rest of this documentation, we will focus solely on the `auto_answer_outgoing_request` function.

Filling in the supplement callback
----------------------------------

Let's take a look at where we are currently with our callback:




---

  
  


```

cstatic void auto_answer_outgoing_request(struct ast_sip_session \*session, pjsip_tx_data \*tdata)
{
 /* STU */
}


```


Let's go over the function in a little more detail. The first parameter to this callback is our SIP session. This contains information such as the associated `ast_channel` structure as well as other session-specific details. The `tdata` parameter is a PJSIP outgoing SIP message structure. In this case, we know the `tdata` is an outbound INVITE request due to the constraints of our supplement.

Let's start by adding the necessary headers to the outgoing INVITE. According to RFC 5373, there are two headers we should be adding:

* Require: answermode
* Answer-Mode: auto

The top one requires that the UAS supports the "answermode" option. A UAS that does not support this option will likely reject the call. The second header tells the UAS that it should automatically answer the call instead of awaiting interaction from the UAS's UI (e.g. having a person answer a ringing phone).

So let's add these headers:




---

  
  


```

cstatic void auto_answer_outgoing_request(struct ast_sip_session \*session, pjsip_tx_data \*tdata)
{
 static const pj_str_t answer_mode_name = { "Answer-Mode", 11 };
 static const pj_str_t answer_mode_value = { "auto", 4 };
 static const pj_str_t require_value = { "answermode", 10 };
 pjsip_generic_string_hdr \*answer_mode;
 pjsip_require_hdr \*require;

 /* Let's add the require header. There could already be a require header present in the
 * request. If so, then we just need to add "answermode" to the list of requirements. Otherwise,
 * we need to create a require header and add "answermode" to it.
 */
 require = pjsip_msg_find_hdr(tdata->msg, PJSIP_H_REQUIRE, NULL);
 if (!require) {
 require = pjsip_require_hdr_create(tdata->pool);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) require);
 }
 pj_strdup(tdata->pool, &require->values[require->count++], &require_value);

 /* Now we can add the Answer-Mode header. This is easier since nothing else should be adding this
 * header to the message before we get it.
 */
 answer_mode = pjsip_generic_string_hdr_create(tdata->pool, &answer_mode_name, &answer_mode_value);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) answer_mode);
}


```


### Variable Declarations

Now we have some content! Let's go into it in more detail, starting from the top:




---

  
  


```

c static const pj_str_t answer_mode_name = { "Answer-Mode", 11 };
 static const pj_str_t answer_mode_value = { "auto", 4 };
 static const pj_str_t require_value = { "answermode", 10 };
 pjsip_generic_string_hdr \*answer_mode;
 pjsip_require_hdr \*require;


```


First is to declare the parameters we will need. The names should be self-evident here, but in case it's not clear, we have created the name and value of the Answer-Mode header, as well as the header itself. Since PJSIP does not know about the Answer-Mode header, we just use a generic string header for it. We also have defined the value we need to place in the Require header and the Require header itself.

### Require header handling

Next, let's have a look at what we are doing with the Require header:




---

  
  


```

c require = pjsip_msg_find_hdr(tdata->msg, PJSIP_H_REQUIRE, NULL);
 if (!require) {
 require = pjsip_require_hdr_create(tdata->pool);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) require);
 }
 pj_cstr(&require->values[require->count++], &require_value);


```


First we try to see if a Require header already exists in the INVITE request. If it does not, then we create a new Require header and add it to the INVITE. Finally, we modify the header by adding the `require_value` to the last spot in the array of values for the header and incrementing the number of members in the array.

### Answer-Mode header handling

Next, let's have a look at what we are doing with the Auto-Answer header:




---

  
  


```

c answer_mode = pjsip_generic_string_hdr_create(tdata->pool, &answer_mode_name, &answer_mode_value);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) answer_mode);


```


Since we don't expect anyone else to be adding an Auto-Answer header to the outbound request, we simply create a new generic string header with the appropriate name and value and then add it to the outgoing message.

Adjustments
-----------

### Using the `SIP_AUTO_ANSWER` channel variable

At this point, we have a simple session supplement written, but we don't actually want to add the auto-answer information to every single outgoing INVITE. Instead, we want to do so based on the presence of the SIP_AUTO_ANSWER channel variable on the outbound channel. Let's modify the code to do this. We will insert the code just before our Require header handling:




---

  
  


```

c ...
 pjsip_require_hdr \*require;
 int add_auto_answer;

 ast_channel_lock(session->channel);
 add_auto_answer = ast_true(pbx_builtin_getvar_helper(session->channel, "SIP_AUTO_ANSWER"));
 ast_channel_unlock(session->channel);

 if (!add_auto_answer) {
 return;
 }
 
 /* Let's add the require header. There could already be a require header present in the
 ...


```


With this new code, we'll check the `SIP_AUTO_ANSWER` channel variable to see if it tells us we should add auto-answer headers. The `ast_true` function checks that the header checks a string's value for words like "yes", "on", or "1" in order to be sure that it is intentional for the auto-answer feature to be invoked. The `pbx_builtin_getvar_helper` function requires that the channel is locked while it is called and the value returned by it is used. In order to use `pbx_builtin_getvar_helper` we will need to include `asterisk/pbx.h`.

### A final adjustment

So now we have code that will conditionally add the auto-answer headers. We only have one final change to make. Think about when this callback is called. It's called on outbound INVITE requests. The thing is, that means it will be called both for the initial outbound INVITE for a session and it will be called on reinvites as well. Auto-answer does not pertain to reinvites, so we should add code to ensure that we only attempt to add the headers for initial outbound INVITEs.




---

  
  


```

c ...
 int add_auto_answer;

 if (session->inv_session->state >= PJSIP_INV_STATE_CONFIRMED) {
 return;
 }

 ast_channel_lock(session->channel);
 ...


```


The `session->inv_session` is a PJSIP structure that keeps up with details of the underlying INVITE dialog. The `PJSIP_INV_STATE_CONFIRMED` state indicates that the initial INVITE transaction has completed. Therefore, if the state is here or beyond, then this outbound request must be a reinvite.

Finished Supplement
===================

At this point, we are finished. So let's put it all together and see what we have:




```bash title="res_pjsip_auto_answer.c  " linenums="1"
#include "asterisk.h"

#include <pjsip.h>
#include <pjsip_ua.h>
#include <pjlib.h>

#include "asterisk/res_pjsip.h"
#include "asterisk/res_pjsip_session.h"
#include "asterisk/module.h"
#include "asterisk/pbx.h"

/*\*\* MODULEINFO
 <depend>pjproject</depend>
 <depend>res_pjsip</depend>
 <depend>res_pjsip_session</depend>
 *\* */
static void auto_answer_outgoing_request(struct ast_sip_session \*session, pjsip_tx_data \*tdata)
{
 static const pj_str_t answer_mode_name = { "Answer-Mode", 11 };
 static const pj_str_t answer_mode_value = { "auto", 4 };
 static const pj_str_t require_value = { "answermode", 10 };
 pjsip_generic_string_hdr \*answer_mode;
 pjsip_require_hdr \*require;
 int add_auto_answer;
 
 if (session->inv_session->state >= PJSIP_INV_STATE_CONFIRMED) {
 return;
 }

 ast_channel_lock(session->channel);
 add_auto_answer = ast_true(pbx_builtin_getvar_helper(session->channel, "SIP_AUTO_ANSWER"));
 ast_channel_unlock(session->channel);

 if (!add_auto_answer) {
 return;
 }

 /* Let's add the require header. There could already be a require header present in the
 * request. If so, then we just need to add "answermode" to the list of requirements. Otherwise,
 * we need to create a require header and add "answermode" to it.
 */
 require = pjsip_msg_find_hdr(tdata->msg, PJSIP_H_REQUIRE, NULL);
 if (!require) {
 require = pjsip_require_hdr_create(tdata->pool);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) require);
 }
 pj_strdup(tdata->pool, &require->values[require->count++], &require_value);

 /* Now we can add the Answer-Mode header. This is easier since nothing else should be adding this
 * header to the message before we get it.
 */
 answer_mode = pjsip_generic_string_hdr_create(tdata->pool, &answer_mode_name, &answer_mode_value);
 pjsip_msg_add_hdr(tdata->msg, (pjsip_hdr \*) answer_mode);
}

static struct ast_sip_session_supplement auto_answer_supplement = {
 .method = "INVITE",
 .outgoing_request = auto_answer_outgoing_request,
};

static int load_module(void)
{
 if (ast_sip_session_register_supplement(&auto_answer_supplement)) {
 return AST_MODULE_LOAD_DECLINE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

static int unload_module(void)
{
 ast_sip_session_unregister_supplement(&auto_answer_supplement);
 return 0;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, AST_MODFLAG_LOAD_ORDER, "SIP Auto Answer Support",
 .load = load_module,
 .unload = unload_module,
 .load_pri = AST_MODPRI_APP_DEPEND,
 );


```


And there you have it. In approximately 80 lines of code, you've added an Asterisk module that can modify outgoing INVITE requests!

