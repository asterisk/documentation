---
title: New in 21
---

# What's New in Asterisk 21

Asterisk 21 saw fewer new additions than previous versions. Many of the changes are actually removals of old modules that were deprecated in previous versions.

## Changes

1. http_bindaddr: For bound addresses, the HTTP status page now combines the bound address and bound port in a single line. Additionally, the SSL bind address has been renamed to TLS.
2. translate: When setting up translation between two codecs the quality was not taken into account, resulting in suboptimal translation. The quality is now taken into account, which can reduce the number of translation steps required, and improve the resulting quality.

## Removals

1. app_cdr: The previously deprecated NoCDR application has been removed. Additionally, the previously deprecated 'e' option to the ResetCDR application has been removed.
2. app_macro: This module was deprecated in Asterisk 16 and is now being removed in accordance with the Asterisk Module Deprecation policy. For most modules that interacted with app_macro, this change is limited to no longer looking for the current context from the macrocontext when set. The following modules have additional impacts:
    1. app_dial - no longer supports M^ connected/redirecting macro
    2. app_minivm - samples written using macro will no longer work. The sample needs to be re-written
    3. app_queue - can no longer call a macro on the called party's channel.  Use gosub which is currently supported
    4. ccss - no callback macro, gosub only
    5. app_voicemail - no macro support
    6. channel  - remove macrocontext and priority, no connected line or redirection macro options
    7. options - stdexten is deprecated to gosub as the default and only options
    8. pbx - removed macrolock
    9. pbx_dundi - no longer look for macro
    10. snmp - removed macro context, exten, and priority
3. app_osplookup: This module was deprecated in Asterisk 19 and is now being removed in accordance with the Asterisk Module Deprecation policy.
4. chan_alsa: This module was deprecated in Asterisk 19 and is now being removed in accordance with the Asterisk Module Deprecation policy.
5. chan_mgcp: This module was deprecated in Asterisk 19 and is now being removed in accordance with the Asterisk Module Deprecation policy.
6. chan_sip: This module was deprecated in Asterisk 17 and is now being removed in accordance with the Asterisk Module Deprecation policy.
7. chan_skinny: This module was deprecated in Asterisk 19 and is now being removed in accordance with the Asterisk Module Deprecation policy.
8. pbx_builtins: The previously deprecated ImportVar and SetAMAFlags applications have now been removed.
9. res_monitor: This module was deprecated in Asterisk 16 and is now being removed in accordance with the Asterisk Module Deprecation policy. This also removes the 'w' and 'W' options for app_queue. MixMonitor should be default and only option for all settings that previously used either Monitor or MixMonitor.

For a complete list of changes and new things in Asterisk 21 please see the [ChangeLogs](https://github.com/asterisk/asterisk/tree/releases/21/ChangeLogs) included with Asterisk 21.
