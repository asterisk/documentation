# ARI Outbound Websockets - DRAFT

/// warning
This document is currently in DRAFT status and may change before final publication.
///

Historically, Asterisk has accepted websocket connections _from_ external ARI applications.  Since a Stasis application can be handled by only one websocket connection, this limited opportunities for load sharing and redundancy. Upcoming releases of Asterisk however, will allow you to configure Asterisk to make outbound websocket connections _to_ external ARI applications.

## Outbound Websocket Types

There are two types of outbound websocket connections:

### Persistent Connections

A persistent connection is established to your ARI application when Asterisk starts and remains open as long as Asterisk is running.  All activity for the Stasis applications configured for the connection happens over that single connection.  Should the connection be broken for any reason, Asterisk will attempt to reconnect at a configurable interval until the connection is re-established.

### Per-Call Connections

A Per-Call connection is one where you configure a template connection that only connects when the Stasis() dialplan app is called with a Stasis application that matches one configured in the template, then disconnects when the Stasis() dialplan app returns.  As with the persistent connection type, if the connection is broken, Asterisk will attempt to reconnect at a configurable interval but you can also set the number of reconnection attempts Asterisk will make before returning an error.

## Configuration

All configfuration is done in ari.conf.

### Configuration Parameters

| Parameter | Default<br>Value | Description |
| :-------- | :--------------- | :-----------|
|[&lt;object_name&gt;] | none | The connection name |
|type | none | Must be "outbound_websocket" |
|connection_type | none | "persistent" or "per_call_config" |
|uri | none | The URI needed to contact the remote server |
|apps | none | A comma-separated list of Stasis applications that will be served by this connection. No other connection may serve these apps. |
|subscribe_all | no  | If set to "yes", the server will receive all events just as though "subscribeAll=true" was specified on an incoming websocket connection. |
|protocols | none | A comma-separated list of websocket protocols expected by the server. |
|username | none | An authentication username if required by the server. |
|password | none | The authentication password for the username. |
|local_ari_user | none | The name of a local ARI user defined elsewhere in ari.conf. This controls whether this connection can make read/write requests or is read-only. The user specified MUST use a plain-text password. |
|connection_timeout | 500 | Connection timeout in milliseconds.|
|reconnect_interval | 500 | Number of milliseconds between reconnection attempts.|
|reconnect_attempts | 4 | The number of (re)connection attempts to make for a per-call connection before returning to the dialplan with an error.  Persistent connections always retry forever but this parameter will determine how often connection failure log messages are emitted. |
|tls_enabled | no | Set to "yes" to enable TLS connections. |
|ca_list_file | none | A file containing all CA certificates needed for the connection.  Not needed if your server has a certificate from a recognized CA. |
|ca_list_path | none | A directory containing individual CA certificates as an alternative to ca_list_file.  Rarely needed. |
|cert_file | none | If the server requires you to have a client certificate, specify it here and if it wasn't issued by a recognized CA, make sure the matching CA certificate is available in ca_list_file or ca_list_path. |
|priv_key_file | none | The private key for the client certificate. |
|verify_server_cert | yes | Verify that the server certificate is valid. |
|verify_server_hostname | yes| Verify that the hostname in the server's certificate matches the hostname in the URI configured above.|

You can define as many connections as you need but, as stated above, a single Stasis app can be associated with only one connection.

Most mis-configuration issues will cause the connection object to fail to load.  If the issue is detected on a reload, the original config will remain in effect.  There are several mis-configuration issues that can only be detected after all objects have been loaded however:

* Duplicate app registration: As stated above, a Stasis app can only be registered by one connection at a time.  Detecting duplicate registrations requires that all connection objects be loaded first.

* local_ari_user not found: This can only be detected once all of the `user` objects in the config file have been loaded.

Should either of these situations occur, log messages will be emitted but because the old object was already disposed of, we can't revert to it.  Instead, the connection object will be marked as "invalid".  No new sessions can be created with this configuration.

### Changing Configurations

You can make changes to the config and do a `module reload res_ari.so` but be aware of the following:

Per-call configurations can be changed at any time.  New per-call connections using that configuration will use the new parameters but any existing connections will continue uninterrupted using the previous configuration until the call ends . If you delete a per-call configuration, no new connections can be created of course, but existing connections will continue uninterrupted until the call ends.

For persistent connections, what happens on a reload depends on the parameters changed.

* Changing `apps` is fairly safe.  Adding a new app to the list simply registers that app to this connection (assuming it's not already registered to another connection).  Deleting an app from the list simply unregisters it.  If you need to move an app from one connection to another, you need to do it in two stages.  Remove it from one connection and reload, then add it to the other connection and reload.  Regardless of the action, the connection will remain active.

* Changing `subscribe_all` will result in all apps being unregistered and re-registered so for a brief instant, no stasis apps will be registered.  The connection will remain active however.

* Changing `connection_timeout`, `reconnect_interval` or `reconnect_attempts` doesn't affect the existing connection until it disconnects for some reason and has to reconnect so these can be changed at any time without affecting the existing connection.

 * Changing any other parameter and reloading will cause the connection to disconnect and reconnect.

* Deleting a persistent connection will immediately unregister all its apps and disconnect the websocket.

* Renaming a connection is the same as deleting it then adding it with the new name.

### Sample ari.conf

```ini
[general]
enabled = yes
pretty = no
allowed_origins = *
websocket_write_timeout = 100

[ari_user]
type = user
read_only = no
password = mypassword

[connection1]
type = outbound_websocket
connection_type = persistent
uri = wss://some.appserver.net:443
apps = app1, app2
subscribe_all = yes
protocols = ari
username = some_user
password = some_password
local_ari_user = ari_user
connection_timeout = 500
reconnect_interval = 1000
tls_enabled = yes
verify_server_cert = no
verify_server_hostname = no
```

This sample creates a persistent secure websocket connection to `some.appserver.net` which has a certificate issued by a recognized certificate authority, and authenticates as `some_user`. The connection is granted read/write access via ARI user `ari_user`.

## Operation

### Persistent Connections

When a connection is initialized, it automatically creates an ARI/Stasis application for each app listed in the `apps` connection parameter.  This mimics exactly what happens if you were to initiate the connection from your external application by making an `GET /ari/events&app=app1,app2` HTTP request. For convenience, a dialplan context named `stasis-<app name>` with a `Stasis(<app name>)` extension is also created automatically, just as it is for inbound websockets.  Incoming channels can be directed to that context or you can create your own.  In either case the Stasis() dialplan app is called with one of the configured app names.

Once the apps are registered, Asterisk will attempt to connect to to your application server using the `connection_timeout`, `reconnect_interval` parameters. Upon successful (re-)connection, you application will receive an `ApplicationRegistered` event for each application configured for the connection.  If you reconfigure a connection and reload and the only changes are to `apps` or `subscribe_all`, you'll receive an `ApplicationRegistered` event for each new application, an `ApplicationUnregistered` event for every application that was removed, and an `ApplicationReplaced` event for every application that was in both the old and new config.

### Per-Call Connections

There are a few differences between persistent and per-call connections.  When Asterisk starts, per-call connections only create the dialplan contexts named `stasis-<app name>` with the `Stasis(<app name>)` extension.  Nothing else happens until a channel causes `Stasis(<app name>)` to be called.  When it does, Stasis() checks the internal app registry and if it doesn't find an ARI/Stasis app registered with that name (which it won't in this case), it looks to see if an outbound-websocket "per_call" connection has been defined and if it finds one, it creates an ephemeral ARI/Stasis app with the name `<app name>:<channel name>` and that's the name that will appear in the initial `ApplicationRegistered` event your external application will see.

Active per-call connections are never reconfigured so there'll be no further `Application*` messages sent.

If a per-call connection fails to (re-)connect after `reconnect_attempts` tries, the  Stasis() application will set the `${STASISSTATUS}` variable to `FAILED` and return control to the dialplan.

### CLI Commands

#### ari show outbound-websockets

This command lists the currently configured outbound websocket connections.
The "Status" column indicates whether the configuration is valid or invalid.

```
*CLI> ari show outbound-websockets
Name          Type            Apps         Status  URI
------------- --------------- ------------ ------- --------------------
connection1   persistent      voicebot     invalid wss://localhost:8765
connection2   per_call_config voicebotpc   valid   wss://localhost:8765
```

#### ari show outbound-websocket &lt;connection_id&gt;

This command shows the details for a specific outbound websocket configuration. Notice that the connection's `local_ari_user` is invalid.

```
*CLI> ari show outbound-websocket connection1
[connection1] **INVALID**
uri =                wss://localhost:8765
protocols =          ari
apps =               voicebot
username =           username
password =           ********
local_ari_user =     someuser (invalid)
connection_type =    persistent
subscribe_all =      Yes
connec_timeout =     500
reconnect_attempts = 5
reconnect_interval = 1000
tls_enabled =        Yes
ca_list_file =
ca_list_path =
cert_file =
priv_key_file =
verify_server =      No
verify_server =      No
```

#### ari show sessions

This command shows both inbound and outbound websocket sessions.  You'll notice that `connection2` is also listed even though it's a per_call_config and doesn't create a connection of its own. `connection2:PJSIP/1172-00000000` _is_ listed since it's a per_call websocket created for a specific channel from the `cxonnection2` configuration.

```
*CLI> ari show sessions
Connection ID                         Type            RemoteAddr                       State Apps
------------------------------------- --------------- -------------------------------- ----- ----------------
b7ceaa68-27cc-4552-a004-dfb6b941cf49  inbound         127.0.0.1:42988                  Up    voicebt,voicebt2
connection1                           persistent      127.0.0.1:8765                   Down  voicebot
connection2                           per_call_config N/A                              N/A   voicebotpc
connection2:PJSIP/1172-00000000       per_call        127.0.0.1:8765                   Up    voicebotpc:PJSIP/1172-00000000
```

#### ari shutdown websocket session &lt;connection_id&gt;

There might be times when you need to shut down an inbound or outbound websocket session.  A good example might be if an outbound websocket can't connect to a server and you need to stop any further attempts while you troubleshoot.

```
*CLI> ari shutdown websocket session connection1
Shutting down websocket session 'connection1'
[2025-04-23 15:04:00.709 -0600] NOTICE[502751]: connection1: Shutting down persistent ARI websocket session to 127.0.0.1:8765
```

#### ari start outbound-websocket &lt;connection_id&gt;

If you _have_ shut down a session, you'll probably need to start it again at some point.

```
*CLI> ari start outbound-websocket connection1
Starting websocket session for outbound-websocket 'connection1'
[2025-04-23 15:05:19.308 -0600] NOTICE[502751]: connection1: Creating outbound websocket session
```

#### ari shutdown websocket sessions

In extreme cases, you might need to shut down all incoming and outgoing websockets. This doesn't prevent new inbound connections however.  To do that you'll need to set `enabled = no` in the `general` section of ari.conf then run `module reload res_ari.so`.

```
*CLI> ari shutdown websocket sessions
Shutting down all websocket sessions
[2025-04-23 15:04:00.709 -0600] NOTICE[502751]: connection1: Shutting down persistent ARI websocket session to 127.0.0.1:8765
[2025-04-23 15:04:00.709 -0600] NOTICE[502751]: connection2: Shutting down persistent ARI websocket session to 127.0.0.1:8765
[2025-04-23 15:04:00.709 -0600] NOTICE[502751]: b7ceaa68-27cc-4552-a004-dfb6b941cf49: Shutting down per-call ARI websocket session to 127.0.0.1:8765
```

## Failure Recovery and Load Balancing

Both outbound websockets connection types create several possibilities for failure recovery and load balancing.

If you have multiple external application servers, you could assign them the same DNS hostname and let the DNS round-robin process offer a different IP address each time the hostname is resolved.  If a connection attempt should fail or an existing connection drop, the next connection attempt should get a different IP address from the pool of hosts with the same hostname.  For per-call connections, this could also provide a simple load balancing method.

A websocket-aware HTTP load balancer can give you even more fail-over and load balancing options by allowing you to set policies that determine how connections are routed.
