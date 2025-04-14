---
title: SMS File Formats
pageid: 5243004
---

By default all queues are held in a director /var/spool/asterisk/sms. Within this directory are sub directories mtrx, mttx, morx, motx which hold the received messages and the messages ready to send. Also, /var/log/asterisk/sms is a log file of all messages handled.

The file name in each queue directory starts with the queue parameter to SMS which is normally the CLI used for an outgoing message or the called number on an incoming message, and may have -X (X being sub address) appended. If no queue ID is known, then 0 is used by smsq by default. After this is a dot, and then any text. Files are scanned for matching queue ID and a dot at the start. This means temporary files being created can be given a different name not starting with a queue (we recommend a . on the start of the file name for temp files). Files in these queues are in the form of a simple text file where each line starts with a keyword and an = and then data. udh and ud have options for hex encoding, see below. 

##### UTF-8.

The user data (ud) field is treated as being UTF-8 encoded unless the DCS is specified indicating 8 bit format. If 8 bit format is specified then the user data is sent as is. The keywords are as follows: 

* oa - Originating address The phone number from which the message came Present on mobile terminated messages and is the CLI for morx messages
* da - Destination Address The phone number to which the message is sent Present on mobile originated messages
* scts - The service centre time stamp Format YYYY-MM-DDTHH:MM:SS Present on mobile terminated messages
* pid - One byte decimal protocol ID See GSM specs for more details Normally 0 or absent
* dcs - One byte decimal data coding scheme If omitted, a sensible default is used (see below) See GSM specs for more details
* mr - One byte decimal message reference Present on mobile originated messages, added by default if absent
* srr - 0 or 1 for status report request Does not work in UK yet, not implemented in app_sms yet
* rp - 0 or 1 return path See GSM specs for details
* vp - Validity period in seconds Does not work in UK yet
* udh - Hex string of user data header prepended to the SMS contents, excluding initial length byte. Consistent with ud, this is specified as udh# rather than udh= If blank, this means that the udhi flag will be set but any user data header must be in the ud field
* ud - User data, may be text, or hex, see below

udh is specified as as udh# followed by hex (2 hex digits per byte). If present, then the user data header indicator bit is set, and the length plus the user data header is added to the start of the user data, with padding if necessary (to septet boundary in 7 bit format). User data can hold an USC character codes U+0000 to U+FFFF. Any other characters are coded as U+FEFF 

ud can be specified as ud= followed by UTF-8 encoded text if it contains no control characters, i.e. only (U+0020 to U+FFFF). Any invalid UTF-8 sequences are treated as is (U+0080-U+00FF). 

ud can also be specified as ud# followed by hex (2 hex digits per byte) containing characters U+0000 to U+00FF only. 

ud can also be specified as ud## followed by hex (4 hex digits per byte) containing UCS-2 characters. 

When written by app_sms (e.g. incoming messages), the file is written with ud= if it can be (no control characters). If it cannot, the a comment line ;ud= is used to show the user data for human readability and ud# or ud## is used.
