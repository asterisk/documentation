---
title: Configuring Asterisk for WebRTC Clients
pageid: 40818051
---

Overview
========

This tutorial will walk you through configuring Asterisk to service WebRTC clients.

You will...

* Modify or create an Asterisk HTTPS TLS server.
* Create a PJSIP WebSocket transport.
* Create PJSIP Endpoint, AOR and Authentication objects that represent a WebRTC client.



Prerequisites
=============

Asterisk Installation
---------------------

You should have a working `chan_pjsip` based Asterisk installation to start with and for purposes of this tutorial, it must be version 15.5 or higher. Either install Asterisk from your distribution's packages or, preferably, [install Asterisk from source](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source). Either way, there are a few modules over and above the standard ones that must be present for WebSockets and WebRTC to work:

* `res_crypto`
* `res_http_websocket`
* `res_pjsip_transport_websocket`
* `codec_opus` (optional but highly recommended for high quality audio)

We recommend installing Asterisk from source because it's easy to make sure these modules are built and installed.Certificates
------------

Technically, a client can use WebRTC over an insecure WebSocket to connect to Asterisk. In practice though, most browsers will require a TLS based WebSocket to be used. You can use self-signed certificates to set up the Asterisk TLS server but getting browsers to accept them is tricky so if you're able, we highly recommend getting trusted certificates from an organization such as [LetsEncrypt](https://letsencrypt.org).

If you already have certificate files (certificate, key, CA certificate), whether self-signed or trusted, you can skip the rest of this section. If you need to generate a self-signed certificate, read on.

### Create Certificates

Asterisk provides a utility script, `**ast\_tls\_cert**` in the `**contrib/scripts**` source directory. We will use it to make a self-signed certificate authority and a server certificate for Asterisk, signed by our new authority.

From the Asterisk source directory run the following commands. You'll be prompted to set a a pass phrase for the CA key, then you'll be asked for that same pass phrase a few times. Use anything you can easily remember. The pass phrase is indicated below with "`********`".  Replace "`pbx.example.com`" with your PBX's hostname or IP address. Replace "`My Organization`" as appropriate.




---

**Note: Private Key Size**  In Asterisk 13, 16, and 17, the `ast_tls_cert` script creates 1024 bit private keys by default. Newer versions of OpenSSL prevent Asterisk from loading private keys that are only 1024 bits resulting in a "key too small" error. The `ast_tls_cert` script in Asterisk versions 13.32.0, 16.9.0, and 17.3.0 and later includes a new command line flag (`-b`) that allows you to set the size of the generated private key in bits.

  



---




---

  
  


```

text$ sudo mkdir /etc/asterisk/keys
$ sudo contrib/scripts/ast\_tls\_cert -C pbx.example.com -O "My Organization" -b 2048 -d /etc/asterisk/keys
 
No config file specified, creating '/etc/asterisk/keys/tmp.cfg'
You can use this config file to create additional certs without
re-entering the information for the fields in the certificate
Creating CA key /etc/asterisk/keys/keys/ca.key
Generating RSA private key, 4096 bit long modulus
............................................................................++
.....................++
e is 65537 (0x010001)
Enter pass phrase for /etc/asterisk/keys/ca.key:\*\*\*\*\*\*\*\*
Verifying - Enter pass phrase for /etc/asterisk/keys/ca.key:\*\*\*\*\*\*\*\*
Creating CA certificate /etc/asterisk/keys/ca.crt
Enter pass phrase for /etc/asterisk/keys/ca.key:\*\*\*\*\*\*\*\*
Creating certificate /etc/asterisk/keys/asterisk.key
Generating RSA private key, 1024 bit long modulus
........++++++
............++++++
e is 65537 (0x010001)
Creating signing request /etc/asterisk/keys/asterisk.csr
Creating certificate /etc/asterisk/keys/asterisk.crt
Signature ok
subject=CN = pbx.example.com, O = My Organization
Getting CA Private Key
Enter pass phrase for /etc/asterisk/keys/ca.key:\*\*\*\*\*\*\*\*
Combining key and crt into /etc/asterisk/keys/asterisk.pem


$ ls -l /etc/asterisk/keys
total 32
-rw------- 1 root root 1204 Mar 4 2019 asterisk.crt
-rw------- 1 root root 574 Mar 4 2019 asterisk.csr
-rw------- 1 root root 887 Mar 4 2019 asterisk.key
-rw------- 1 root root 2091 Mar 4 2019 asterisk.pem
-rw------- 1 root root 149 Mar 4 2019 ca.cfg
-rw------- 1 root root 1736 Mar 4 2019 ca.crt
-rw------- 1 root root 3311 Mar 4 2019 ca.key
-rw------- 1 root root 123 Mar 4 2019 tmp.cfg



```



---


We'll use the `asterisk.crt` and `asterisk.key` files later to configure the HTTP server.

Asterisk Configuration
======================

Configure Asterisk's built-in HTTP server
-----------------------------------------

To communicate with WebSocket clients, Asterisk uses its built-in HTTP server. Configure `**/etc/asterisk/http.conf**` as follows:




---

  
/etc/asterisk/http.conf  


```

text[general]
enabled=yes
bindaddr=0.0.0.0
bindport=8088
tlsenable=yes
tlsbindaddr=0.0.0.0:8089
tlscertfile=/etc/asterisk/keys/asterisk.crt
tlsprivatekey=/etc/asterisk/keys/asterisk.key

```



---




---

**Note:**  If you have not used the generated self-signed certificates produced in the "[Create Certificates](#CreateCertificates)" section then you will need to set the "`tlscertfile`" and "`tlsprivatekey`" to the path of your own certificates if they differ.

  



---


 

Now start or restart Asterisk and make sure the TLS server is running by issuing the following CLI command:




---

  
Asterisk CLI  


```

text\*CLI> http show status

HTTP Server Status:
Prefix: 
Server: Asterisk/GIT-16-a84c257cd6
Server Enabled and Bound to [::]:8088

HTTPS Server Enabled and Bound to [::]:8089

Enabled URI's:
/test\_media\_cache/... => HTTP Media Cache Test URI
/guimohdir\_rh => HTTP POST mapping
/httpstatus => Asterisk HTTP General Status
/phoneprov/... => Asterisk HTTP Phone Provisioning Tool
/amanager => HTML Manager Event Interface w/Digest authentication
/backups => HTTP POST mapping
/arawman => Raw HTTP Manager Event Interface w/Digest authentication
/manager => HTML Manager Event Interface
/rawman => Raw HTTP Manager Event Interface
/static/... => Asterisk HTTP Static Delivery
/amxml => XML Manager Event Interface w/Digest authentication
/mxml => XML Manager Event Interface
/moh => HTTP POST mapping
/ari/... => Asterisk RESTful API
/ws => Asterisk HTTP WebSocket
<there may be more>

```



---


Note that the HTTPS Server is enabled and bound to `[::]:8089` and that the `/ws` URI is enabled.

Configure PJSIP
---------------

 If you're not already familiar with configuring Asterisk's `chan_pjsip` driver, visit the [`res_pjsip` configuration page](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip).

### PJSIP WSS Transport

Although the HTTP server does the heavy lifting for WebSockets, we still need to define a basic PJSIP Transport:




---

  
/etc/asterisk/pjsip.conf  


```

[transport-wss]
type=transport
protocol=wss
bind=0.0.0.0
; All other transport parameters are ignored for wss transports.



```



---


### PJSIP Endpoint, AOR and Auth

We now need to create the basic PJSIP objects that represent the client. In this example, we'll call the client `webrtc_client` but you can use any name you like, such as an extension number. Only the minimum options needed for a working configuration are shown. NOTE: It's normal for multiple objects in `pjsip.conf` to have the same name as long as the types differ.




---

  
/etc/asterisk/pjsip.conf  


```

[webrtc\_client]
type=aor
max\_contacts=5
remove\_existing=yes
 
[webrtc\_client]
type=auth
auth\_type=userpass
username=webrtc\_client
password=webrtc\_client ; This is a completely insecure password! Do NOT expose this 
 ; system to the Internet without utilizing a better password.

[webrtc\_client]
type=endpoint
aors=webrtc\_client
auth=webrtc\_client
dtls\_auto\_generate\_cert=yes
webrtc=yes
; Setting webrtc=yes is a shortcut for setting the following options:
; use\_avpf=yes
; media\_encryption=dtls
; dtls\_verify=fingerprint
; dtls\_setup=actpass
; ice\_support=yes
; media\_use\_received\_transport=yes
; rtcp\_mux=yes
context=default
disallow=all
allow=opus,ulaw



```



---


An explanation of each of these settings parameters can be found on the [Asterisk 16 Configuration for `res_pjsip`](/Asterisk-16-Configuration_res_pjsip) page. Briefly:

* Declare an endpoint that references our previously-made aor and auth.
* Notify Asterisk to expect the AVPF profile (secure RTP)
* Setup the DTLS method of media encryption.
* Specify which certificate files to use for TLS negotiations with this endpoint and our verification and setup methods.
* Enable ICE support
* Tell Asterisk to send media across the same transport that we receive it from.
* Enable mux-ing of RTP and RTCP events onto the same socket.
* Place received calls from this endpoint into an Asterisk [Dialplan](/Configuration/Dialplan) context called "default"
* And setup codecs by first disabling all and then selectively enabling Opus (presuming that you installed the Opus codec for Asterisk as mentioned at the beginning of this tutorial), then G.711 μ-law.

Restart Asterisk
----------------

Restart Asterisk to pick up the changes and if you have a firewall, don't forget to allow TCP port 8089 through so your client can connect.

Wrap Up
=======

At this point, your WebRTC client should be able to register and make calls. If you've used self-signed certificates however, your browser may not allow the connection and because the attempt is not from a normal URI supplied by the user, the user might not even be notified that there's an issue.  You *may* be able to get the browser to accept the certificate by visiting "`https://pbx.example.com:8089/ws`" directly.  This will usually result in a warning from the browser and may give you the opportunity to accept the self-signed certificate and/or create an exception. If you generated your certificate from a pre-existing local Certificate Authority, you can also import that Certificate Authority's certificate into your trusted store but that procedure is beyond the scope of this document.

