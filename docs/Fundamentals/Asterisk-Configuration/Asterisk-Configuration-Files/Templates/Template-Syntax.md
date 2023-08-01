---
title: Template Syntax
pageid: 4817465
---

To define a section as a template **only** (not to be loaded for use as configuration by itself), place an exclamation mark in parentheses after the section heading, as shown in the example below.

```javascript title=" " linenums="1"
[template-name](!)
setting=value

```

Alternatively the [Using Templates](/Fundamentals/Asterisk-Configuration/Asterisk-Configuration-Files/Templates/Using-Templates) page will also discuss how to have a section inherit another section's settings without defining a template. In effect, using an "active" or "live" configuration section as your template.

