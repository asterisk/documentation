---
title: MeetMe Channel Variables
pageid: 4620408
---

* ${MEETME_RECORDINGFILE} - Name of file for recording a conference with the "r" option
* ${MEETME_RECORDINGFORMAT} - Format of file to be recorded
* ${MEETME_EXIT_CONTEXT} - Context for exit out of meetme meeting
* ${MEETME_AGI_BACKGROUND} - AGI script for Meetme (DAHDI only)
* ${MEETMESECS} \* - Number of seconds a user participated in a MeetMe conference
* ${CONF_LIMIT_TIMEOUT_FILE} - File to play when time is up. Used with the L() option.
* ${CONF_LIMIT_WARNING_FILE} - File to play as warning if 'y' is defined. The default is to say the time remaining. Used with the L() option.
* ${MEETMEBOOKID} \* - This variable exposes the bookid column for a realtime configured conference bridge.
* ${MEETME_EXIT_KEY} - DTMF key that will allow a user to leave a conference
