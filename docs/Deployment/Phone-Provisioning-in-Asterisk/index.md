---
title: Overview
pageid: 5243047
---

Asterisk includes basic phone provisioning support through the res\_phoneprov module. The current implementation is based on a templating system using Asterisk dialplan function and variable substitution and obtains information to substitute into those templates from phoneprov.conf and users.conf. A profile and set of templates is provided for provisioning Polycom phones. Note that res\_phoneprov is currently limited to provisioning a single user per device.

