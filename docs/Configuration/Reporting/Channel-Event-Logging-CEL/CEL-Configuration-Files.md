---
title: CEL Configuration Files
pageid: 5242946
---

CEL General Configuration
=========================

Primary CEL configuration settings are located in `cel.conf`. Note that CEL only publishes record types to back-ends that are enabled in the general CEL configuration.

Back-end Configuration
======================

Configuration for specific logging or storage back-ends is located in separate configuration files. The exception is the AMI and RADIUS back-ends. Sample configurations are provided with the Asterisk 12 source for all of these back-ends.

| Name | Config File | Description |
| --- | --- | --- |
| Manager (AMI) | cel.conf | The manager CEL output module publishes records over AMI as CEL events with the record type published under the "EventName" key. This module is configured in cel.conf in the [manager] section. |
| RADIUS | cel.conf | The RADIUS CEL output module allows the CEL engine to publish records to a RADIUS server. This module is configured in cel.conf in the [radius] section. |
| CEL Custom | cel_custom.conf | The Custom CEL output module provides logging capability to a CSV file in a format described in the configuration file. |
| ODBC | cel_odbc.conf | The ODBC CEL output module provides logging capability to any ODBC-compatible database. |
| PGSQL | cel_pgsql.conf | The PGSQL CEL output module provides logging capability to PostgreSQL databases when it is desirable to avoid the ODBC abstraction layer.  |
| SQLite | cel_sqlite3_custom.conf | The SQLite CEL output module provides logging capability to a SQLite3 database in a format described in its configuration file. |
| TDS | cel_tds.conf | The TDS CEL output module provides logging capability to Sybase or Microsoft SQL Server databases when it is desirable to avoid the ODBC abstraction layer. |
