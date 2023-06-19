---
title: MeetMe Channel Variables
pageid: 4620408
---

* ${MEETME\_RECORDINGFILE} - Name of file for recording a conference with the "r" option
* ${MEETME\_RECORDINGFORMAT} - Format of file to be recorded
* ${MEETME\_EXIT\_CONTEXT} - Context for exit out of meetme meeting
* ${MEETME\_AGI\_BACKGROUND} - AGI script for Meetme (DAHDI only)
* ${MEETMESECS} \* - Number of seconds a user participated in a MeetMe conference
* ${CONF\_LIMIT\_TIMEOUT\_FILE} - File to play when time is up. Used with the L() option.
* ${CONF\_LIMIT\_WARNING\_FILE} - File to play as warning if 'y' is defined. The default is to say the time remaining. Used with the L() option.
* ${MEETMEBOOKID} \* - This variable exposes the bookid column for a realtime configured conference bridge.
* ${MEETME\_EXIT\_KEY} - DTMF key that will allow a user to leave a conference
