---
title: Tests for Registration Functionality
pageid: 24248353
---

## Overview

This page outlines registration tests for the new SIP channel driver.

All registration / un-registration tests will need to be run multiple times. Details on each iteration are given below:

| Iteration | Transport-specific options | Comment |
| --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol = udp | IPv4 UDP |
| 2 | bind = 127.0.0.1:5060protocol = tcp | IPv4 TCP |
| 3 | bind = [::1]:5060protocol = udp | IPv6 UDP |
| 4 | bind = [::1]:5060protocol = tcp | IPv6 TCP |

Note that if a specific test requires multiple iteration, the total number of test iterations will be the product of the test's number of iteration multiplied by the number of iterations in the above table.

## Inbound Registration Tests

### Nominal Tests

#### Test 1: Single contact

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1minimum_expiration=5default_expiration=30 | none | Contact: &lt;sip:alice@127.0.0.2:5061&gt; | Identify by username, no auth,**no *Expires* header,no *expires* Contact param defined** | yes |
| 2 | auth=alice-authaors=alice | username=alicepassword=swordfish | max_contacts=1minimum_expiration=5default_expiration=30 | realm=asterisk  username=alice password=swordfish | Contact: &lt;sip:alice@127.0.0.2:5061&gt; | Identify by username, userpass auth,**no *Expires* header,no *expires* Contact param defined** | yes |

Procedure:

1. The UA sends a REGISTER request containing a single contact to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. If applicable, authentication occurs.
3. Asterisk properly adds the contact to the configured AOR
4. Asterisk sets the expiration of the contact to the value of the *default_expiration* configuration setting
5. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly adds the contact to the proper AOR
* Asterisk sets the expiration of the contact to the value of the *default_expiration* configuration setting
* Asterisk responds with a 200 OK with the single contact listed

#### Test 2: Multiple contacts

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=2minimum_expiration=5default_expiration=30 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt; Contact: &lt;sip:alice-home@127.0.0.3:5062&gt; Expires: 10 | Identify by username,no auth,two contacts, one AOR,*Expires* header | yes |
| 2 | auth=alice-authaors=alice | username=alicepassword=swordfish | max_contacts=2minimum_expiration=5default_expiration=30 | realm=asteriskusername=alicepassword=swordfish | Contact: \&lt;sip:alice-office@127.0.0.2:5061\&gt;Contact: \&lt;sip:alice-home@127.0.0.3:5062\&gt;Expires: 10 | Identify by username,userpass auth,two contacts, one AOR,*Expires* header | yes |
| 3 | aors=alice | none | max_contacts=2minimum_expiration=5default_expiration=30 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;;expires=20Expires: 10 | Identify by username,no auth,two contacts, one AOR,*Expires* header,*expires* Contact param |  yes |
| 4 | auth=alice-authaors=alice  | username=alicepassword=swordfish  | max_contacts=2minimum_expiration=5default_expiration=30 | realm=asteriskusername=alicepassword=swordfish | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;;expires=20 | Identify by username,userpass auth,two contacts, one AOR,*expires* Contact param |  yes |
| 5 | auth=alice-authaors=alice | username=alicepassword=swordfish | max_contacts=2minimum_expiration=5default_expiration=30 | realm=asteriskusername=alicepassword=swordfish | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;Expires: 10 | Identify by username,userpass auth,two contacts, one AOR,*Expires* header,one *expires* Contactparam | yes |
| 6 | auth=alice-authaors=alice | username=alicepassword=swordfish | max_contacts=2minimum_expiration=5default_expiration=30 | realm=asteriskusername=alicepassword=swordfish | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Contact: &lt;sip:alice-home@127.0.0.3:5062&gt; | Identify by username,userpass auth,two contacts, one AOR,one *expires* Contactparam | yes |

Procedure:

1. The UA sends a REGISTER request containing multiple contacts to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. If applicable, authentication occurs.
3. Asterisk properly adds the contact to the configured AOR
4. For iteration:
	* 1 & 2, Asterisk sets the expiration of the contacts to what was received in the *Expires* header.
	* 3 & 4, Asterisk sets the expiration of the contacts to what was received in the *expires* parameter of the *Contacts* header.
	* 5, Asterisk sets the expiration of the contact **with** the *expires* parameter to the value it is set to; the contact **without** the *expires* parameter is set to the value specified in the *Expires* header.
	* 6, Asterisk sets the expiration of the contact **with** the *expires* parameter to the value it is set to; the contact **without** the *expires* parameter is set to the value of the *default_expiration* configuration setting.
5. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly adds the contact(s) to the proper AOR
* For iteration:
	+ 1 & 2, Asterisk sets the expiration of the contacts to what was received in the *Expires* header.
	+ 3 & 4, Asterisk sets the expiration of the contacts to what was received in the *expires* parameter of the *Contacts* header.
	+ 5, Asterisk sets the expiration of the contact **with** the *expires* parameter to the value it is set to; the contact **without** the *expires* parameter is set to the value specified in the *Expires* header.
	+ 6, Asterisk sets the expiration of the contact **with** the *expires* parameter to the value it is set to; the contact **without** the *expires* parameter is set to the value of the *default_expiration* configuration setting.
* Asterisk responds with a 200 OK with both contacts listed

#### Test 3: Multiple contacts - Registration and Un-registration Mixed

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=2minimum_expiration=5default_expiration=30 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=0Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;;expires=20Expires: 10 | Identify by username,no auth,two contacts, one AOR,*Expires* header,*expires* Contact param,Un-register one contact& register another |  yes |

Procedure:

1. The UA sends a REGISTER request containing only **one** contact with an expiration set to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk properly adds the contact to the configured AOR
3. Asterisk responds with a 200 OK
4. The UA sends a REGISTER request containing multiple contacts to Asterisk for an endpoint & AOR defined in pjsip.conf. The contact that is already registered has an *expires* parameter of *0*. The other contact that is not registered has an *expires* value as defined in the above table.
5. Asterisk removes the contact that had an expiration of 0 set from the AOR (un-registers) and adds the contact that had an expiration of 20 set to the AOR (registers).
6. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk removes the contact that had an expiration of 0 set from the AOR (un-registers) and adds the contact that had an expiration of 20 set to the AOR (registers).
* Asterisk responds with a 200 OK with listing only the contact that was registered (that had an expiration of 20 set)

#### Test 4: Configuration Option *maximum_expiration*

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | default_expiration=30maximum_expiration=60 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=120Expires: 300 | Identify by username,no auth,one contacts, one AOR,*Expires* header,*expires* Contact param |  yes |

Procedure:

1. The UA sends a REGISTER request containing a single contact to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk properly adds the contact to the configured AOR
3. Asterisk sets the expiration of the contact to the value of the *maximum_expiration* configuration setting
4. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly adds the contact to the proper AOR
* Asterisk sets the expiration of the contact to the value of the *maximum_expiration* configuration setting
* Asterisk responds with a 200 OK with the single contact listed

#### Test 5: Configuration Option *minimum_expiration*

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | default_expiration=60minimum_expiration=30 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Expires: 20 | Identify by username,no auth,one contacts, one AOR,*Expires* header,*expires* Contact param |  yes |

Procedure:

1. The UA sends a REGISTER request containing a single contact to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk properly adds the contact to the configured AOR
3. Asterisk sets the expiration of the contact to the value of the *minimum_expiration* configuration setting
4. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly adds the contact to the proper AOR
* Asterisk sets the expiration of the contact to the value of the *minimum_expiration* configuration setting
* Asterisk responds with a 200 OK with the single contact listed

#### Test 6: Configuration Option *remove_existing*

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=3remove_existing=yes | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;Expires: 20 | Identify by username,no auth,two contacts, one AOR,*Expires* header |  yes |
| 2 | aors=alice | none | max_contacts=3remove_existing=yes | none | Contact: &lt;sip:alice-mobile@127.0.0.2:5061&gt;Contact: &lt;sip:alice-pc@127.0.0.3:5062&gt;Expires: 20 | Identify by username,no auth,two contacts, one AOR,*Expires* header | yes |

Procedure:

1. The UA sends a REGISTER request containing two contacts to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk properly adds the contacts to the configured AOR
3. Asterisk responds with a 200 OK
4. The UA sends a REGISTER request containing two **different** contacts to Asterisk for an endpoint & AOR defined in pjsip.conf.
5. Asterisk properly replaces the first set of contacts with the second set of contacts for the configured AOR
6. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly adds the contacts to the proper AOR
* Asterisk responds with a 200 OK with both contacts listed
* Asterisk properly replaces the first set of contacts with the second set of contacts for the configured AOR
* Asterisk responds with a 200 OK with both contacts listed from the second set.

### Off-nominal Tests

#### Test 1: Invalid expirations

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1minimum_expiration=5default_expiration=30 | none | Contact: &lt;sip:alice@127.0.0.2:5061&gt;Expires: 4294967296 | Identify by username,no auth,***invalid Expires* header** | no |
| 2 | auth=alice-authaors=alice | username=alicepassword=swordfish | max_contacts=1minimum_expiration=5default_expiration=30 | realm=asterisk  username=alice password=swordfish | Contact: &lt;sip:alice@127.0.0.2:5061&gt;;expires=4294967296 | Identify by username,userpass auth,***invalid expires*Contact parameter** | no |

Procedure:

1. The UA sends a REGISTER request containing a single contact to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. If applicable, authentication occurs.
3. Asterisk properly **adds** the contact to the configured AOR
4. Asterisk sets the expiration of the contact to the value of **one** of the following:
	* the *default_expiration* configuration setting
	* 4294967295
	* 3600
5. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly **adds** the contact(s) to the proper AOR
* Asterisk sets the expiration of the contact to the value of **one** of the following:
	+ the *default_expiration* configuration setting
	+ 4294967295
	+ 3600
* Asterisk responds with a 200 OK with the contact(s) listed

#### Test 2: No Contact header

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1minimum_expiration=5default_expiration=30 | none | Expires: 10 | Identify by username,no auth,**no Contact header**,***Expires* header** | yes |

Procedure:

1. The UA sends a REGISTER request **without** a *Contact* header to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk does **not** add any contact to the configured AOR
3. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk does **not** add the contact to the AOR
* Asterisk responds with a 200 OK with **no***Contact* header

#### Test 3: Configuration Option *max_contacts*

| Iteration | Alice-specific Data | Alice-auth-specific Data | Alice-aor-specific Data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=15Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;;expires=20Expires: 10 | Identify by username,no auth,two contacts, one AOR,*Expires* header,*expires* Contact param | yes |

Procedure:

1. The UA sends a REGISTER request containing two contacts to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk does **not** add the contacts to the configured AOR
3. Asterisk responds with a 403 Forbidden

Pass Conditions:

* Asterisk does **not** add the contacts to the configured AOR
* Asterisk responds with a 403 Forbidden

#### Test 4: Wrong Password

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | auth=alice-authaors=alice | username=alicepassword=swordfish |  | realm=asterisk  username=alice password=wrong | Contact: &lt;sip:alice@127.0.0.2:5061&gt;Expires: 10 | Identify by username, userpass auth,*Expires* header,**wrong password** | yes |

Procedure:

1. The UA sends a REGISTER request containing a single contact to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Authentication occurs.
3. Asterisk responds with a 401 Unauthorized

Pass Conditions:

* Asterisk does **not** add the contact to the AOR
* Asterisk responds with a 401 Unauthorized with **no** contacts listed

## Un-registration Tests

### Nominal Tests

#### Test 1: Un-register single contact from AOR

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1 | none | Contact: &lt;sip:alice@127.0.0.2:5061&gt;Expires: 0 | Identify by username,no auth,***Contact* header**,***Expires* header** | yes |

Procedure:

1. The UA sends a REGISTER request **with** a valid *Contact* header and **with** an *Expires* header of ***0*** to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly un-registers the contact
* Asterisk responds with a 200 OK

#### Test 2: Un-register multiple contacts from AOR

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=2 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;Expires: 0 | Identify by username,no auth,***Contact* headers**,***Expires* header** | yes |
| 2 | aors=alice | none | max_contacts=2 | none | Contact: &lt;sip:alice-office@127.0.0.2:5061&gt;;expires=0Contact: &lt;sip:alice-home@127.0.0.3:5062&gt;;expires=0Expires: 55 | Identify by username,no auth,***Contact* headers**,***Expires* header**,***expires* Contact param** | yes |

Procedure:

1. The UA sends a REGISTER request **with** a multiple *Contact* headers with a mix of using the *Expires* header and the *expires* *Contact* parameter to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly un-registers both contacts
* Asterisk responds with a 200 OK

#### Test 3: Un-register all contacts using '\*' from AOR

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1minimum_expiration=5default_expiration=30 | none | Contact: \*Expires: 0 | Identify by username,no auth,***Contact* header**,***Expires* header** | yes |

Procedure:

1. The UA sends a REGISTER request **with** a *Contact* header of '**\***' and **with** an *Expires* header of ***0*** to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk responds with a 200 OK

Pass Conditions:

* Asterisk properly un-registers all contacts
* Asterisk responds with a 200 OK

### Off-nominal Tests

#### Test 1: Un-register single contact using '\*' without an *Expires* header from AOR

| Iteration | Alice-specific Data | Alice-auth-specific data | Alice-aor-specific data | Supplied Credentials | Supplied SIP Headers | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | aors=alice | none | max_contacts=1minimum_expiration=5default_expiration=30 | none | Contact: \* | Identify by username,no auth,***Contact* header**,***no Expires* header** | yes |

Procedure:

1. The UA sends a REGISTER request **with** a *Contact* header of '**\***' and **without** an *Expires* header to Asterisk for an endpoint & AOR defined in pjsip.conf.
2. Asterisk responds with a 400 Bad Request

Pass Conditions:

* Asterisk does **not** un-register any contacts
* Asterisk responds with a 400 Bad Request
