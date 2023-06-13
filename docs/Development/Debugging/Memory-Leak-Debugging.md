---
title: Memory Leak Debugging
pageid: 33128633
---

If Asterisk is crashing due to potential memory corruption then head to the  page.

If Asterisk developers suspect that you have a memory leak then you will be asked to follow the instructions below.

Follow the instructions here and all linked instructions closely to speed up the debugging process.

 

1. Verify the Description field of your issue report contains details about the environment in which the issue occurs.
	1. Basic information - Linux environment, Asterisk version, modifications in use, third-party modules, etc.
	2. Information about the call flow - What channel driver is in use? What dialplan do the calls execute? Attach specific configuration details and examples if possible.
2. You should attach logger output showing general Asterisk activity during the problem.
	1.
3. You should attach output generated (mmlog file) utilizing the MALLOC\_DEBUG compiler flag.
	1.

All debug should be attached using ( More > Attach Files ) on the JIRA issue report.

