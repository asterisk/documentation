---
title: Overview
pageid: 5242932
---

## Overview

Asterisk's Channel Event Logging provides a mechanism for tracking many channel related events. CEL is granular and fine-grained, having been designed with billing information in mind. It supports many storage back-ends and is a great alternative to Call Detail Records for administrators that need extremely detailed event logs. The extensive detail will allow building of accurate billing or call-flow data.

Features:

* Control over which Asterisk applications are tracked.
* Control over which events should be raised.
* Configurable date format.
* Integration with the Asterisk Manager Interface.
* Integration with RADIUS
* Modules for various logging back-ends including customized CEL output, integration with ODBC, PGSQL, SQLite and TDS.

The child pages in this section discuss the configuration of Channel Event Logging.

## Events

While CEL, CDR and AMI are all basically event tracking mechanisms, the events tracked by CEL are focused on a use case for generating billing data. The specific events and fields are covered in the **[Asterisk CEL Specification](CEL-Specification).**
