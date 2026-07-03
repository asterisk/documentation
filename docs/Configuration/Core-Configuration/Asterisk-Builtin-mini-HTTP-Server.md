---
title: Asterisk Builtin mini-HTTP Server
pageid: 28315001
---

## Overview

Asterisk provides a basic built-in HTTP/HTTPS server.

Certain Asterisk modules may make use of the HTTP service, such as the [Asterisk Manager Interface](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI) over HTTP, the [Asterisk Restful Interface](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Getting-Started-with-ARI) or WebSocket transports for modules that support that, like chan_pjsip.

## Configuration

The configuration file is [by default](/Fundamentals/Directory-and-File-Structure) located at `/etc/asterisk/http.conf`.

A very basic configuration of `http.conf` could be as follows:

```
[general]
enabled=yes
bindaddr=0.0.0.0
```

That configuration would enable the HTTP server and have it bind to all available network interfaces on the default port 8088.

### Configuration Options

Some important configuration options are shown below.

| Value | Description |
| ----- | ----------- |
| **servername** | Name of the webserver. Defaults to "Asterisk/{version}" |
| **enabled** | Must be set to "yes" for the server to run |
| **bindaddr** | Address to bind to for HTTP sessions. Must be set for the server to run |
| **bindport** | Port to bind to for HTTP sessions. Default is 8088 |
| **enable_static** | If static content from `static-http` should be served. Defaults to "no" |

Static content serving can be useful if you are using IP Phones which fetch configuration over HTTP. With **enable_static** set to "yes", files in `/var/lib/asterisk/static-http/` will be made available at `http://192.0.2.5/static/` (replace the example IP Address with your Asterisk server or domain name).

The built-in server also supports HTTPS, with options available for supplying certificate paths, etc.

See the [sample configuration file supplied with Asterisk sources](https://github.com/asterisk/asterisk/blob/master/configs/samples/http.conf.sample) for full detail on all possible configuration options.  

## Console Command

The built-in server supports a single Asterisk console command `http show status`. This outputs the status of the built-in server, including details on if the server is enabled, which IP and port it is bound to, enabled URIs, and enabled Redirects.
