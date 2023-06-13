---
title: Overview
pageid: 5243066
---

The Asterisk Calendaring API is provided by the res\_calendar module. It aims to be a generic interface for integrating Asterisk with various calendaring technologies. The goal is to be able to support reading and writing of calendar events as well as allowing notification of pending events through the Asterisk dialplan.

There are four calendaring modules that ship with Asterisk that provide support for the following calendaring servers.



| Calendar Server Support | Module Name |
| --- | --- |
| iCalendar | res\_calendar\_icalendar.so |
| CalDAV | res\_calender\_caldav.so |
| Microsoft Exchange Server | res\_calendar\_exchange.so |
| Microsoft ExchangeWeb Services  | res\_calendar\_ews.so |

All four modules support event notification. Both CalDAV and Exchange support reading and writing calendars, while iCalendar is a read-only format.

You can see list all registered calendar types at the CLI with **"****calendar show types"**.

\*CLI> calendar show types
Type Description
caldav CalDAV calendars
exchange MS Exchange calendars
ews MS Exchange Web Service calend
ical iCalendar .ics calendars