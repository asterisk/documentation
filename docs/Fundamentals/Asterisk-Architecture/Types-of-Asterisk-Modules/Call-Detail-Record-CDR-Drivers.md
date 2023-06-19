---
title: Call Detail Record (CDR) Drivers
pageid: 4817500
---

CDR modules are used to store [Call Detail Records (CDR)](/Call-Detail-Records--CDR-) in a variety of formats. Popular storage mechanisms include comma-separated value (CSV) files, as well as relational databases such as MySQL or PostgreSQL. Call detail records typically contain one record per call, and give details such as who made the call, who answered the call, the amount of time spent on the call, and so forth.

Call detail record modules have file names that look like **cdr\_xxxxx.so**, such as **cdr\_csv.so**. The recommended module to use for connecting to [CDR Storage Backends](/CDR-Storage-Backends) is **cdr\_adaptive\_odbc.so**.

