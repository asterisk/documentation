---
title: Sections and Settings
pageid: 4817449
---

The configuration files are broken into various section, with the section name surrounded by square brackets. Section names should not contain spaces, and are case sensitive. Inside of each section, you can assign values to various settings. Note that settings are also referred to as configuration options or just, options. In general, settings in one section are independent of values in another section. Some settings take values such as true or false, while other settings have more specific settings. The syntax for assigning a value to a setting is to write the setting name, an equals sign, and the value, like this:

```
[section-name]
setting=true

[another_section]
setting=false
setting2=true
```

Additionally here is closer to real-life example from the [pjsip.conf](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip).sample file:

```
[transport-udp-nat]
type=transport
protocol=udp
bind=0.0.0.0
local_net=192.0.2.0/24
external_media_address=203.0.113.1
external_signaling_address=203.0.113.1
```
