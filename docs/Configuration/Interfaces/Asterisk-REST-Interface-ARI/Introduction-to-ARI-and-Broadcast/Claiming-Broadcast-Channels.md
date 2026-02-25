# Claiming Broadcast Channels

This guide walks through a complete StasisBroadcast setup: Asterisk configuration,
the dialplan, the `CallBroadcast` event your application receives, the claim REST call,
and working examples in Python and Node.js.

## Prerequisites

* Asterisk 20.20, 22.10, or 23.4 or later with `res_stasis_broadcast.so` and
  `app_stasis_broadcast.so` built and installed.
* The ARI HTTP interface enabled (see below).
* One or more ARI applications connected via WebSocket.

## Configuring Asterisk

### Enable the HTTP Server

ARI relies on Asterisk's built-in HTTP server. Enable it in `http.conf`:

```ini title="http.conf" linenums="1"
[general]
enabled = yes
bindaddr = 0.0.0.0
bindport = 8088
```

### Configure ARI

Create at least one ARI user in `ari.conf`. The same credentials are used for both
the REST API and the WebSocket connection:

```ini title="ari.conf" linenums="1"
[general]
enabled = yes
pretty = yes

[my-ari-user]
type = user
password = my-secret-password
password_format = plain
```

/// tip | Channel variables in events
To include channel variable values in `CallBroadcast` events (for routing decisions
in your ARI application), list the variable names in `ari.conf`:

```ini title="ari.conf (channelvars)"
[general]
enabled = yes
channelvars = SKILL_REQUIRED,PRIORITY,QUEUE_NAME
```

Variables will appear inside the `channel.channelvars` object of each event.
///

### Load the Modules

Ensure both modules are listed (or autoloaded) in `modules.conf`:

```ini title="modules.conf" linenums="1"
[modules]
autoload = yes

; StasisBroadcast requires res_stasis and res_ari, which are loaded automatically.
; Add explicit load lines only if autoload is disabled:
; load = res_stasis_broadcast.so
; load = app_stasis_broadcast.so
```

## Dialplan Configuration

Use `StasisBroadcast()` anywhere in the dialplan in place of `Stasis()`. After the
application returns, branch on the `STASISSTATUS` channel variable to handle the
outcome. A complete set of patterns with inline comments is provided in the
[examples below](#examples).

### Application Parameters

`StasisBroadcast([timeout[,app_filter[,args[,notify_claimed]]]])`

Arguments are comma-delimited. All are optional.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `timeout` | integer (ms) | `500` | Milliseconds to wait for a claim before returning to the dialplan. Valid range: 0–60000. |
| `app_filter` | regex | _(all apps)_ | Regular expression applied to ARI application names. Only matching applications receive the `CallBroadcast` event. Because arguments are comma-delimited, commas cannot appear in the pattern — use character classes such as `[,]` if needed. |
| `args` | string | _(none)_ | Colon-delimited arguments passed to the winning application in its `StasisStart` event as the `args` array. The colon separator is used because commas separate `StasisBroadcast()` parameters. Equivalent to `Stasis(app,arg1,arg2)` — the winner receives the same `args` array. Example: `sales:priority-high`. |
| `notify_claimed` | boolean | `no` | When `yes`, a [`CallClaimed`](#callclaimed-event) event is sent to all filtered applications once the channel is claimed. Disabled by default to minimise WebSocket traffic; losing claimants already receive a `409` HTTP response. To set only this parameter while accepting defaults for the others, use empty commas as placeholders: `StasisBroadcast(,,, yes)`. |

### Examples

The following annotated sample covers the most common patterns:

```ini title="extensions.conf"
--8<-- "Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Broadcast/extensions.conf"
```

### STASISSTATUS Variable

After `StasisBroadcast()` returns, the `STASISSTATUS` channel variable contains the
outcome:

| Value | Meaning |
|-------|---------|
| `SUCCESS` | An application claimed the channel and the Stasis session completed without error. |
| `FAILED` | An application claimed the channel but an error occurred when executing the Stasis application. |
| `TIMEOUT` | No application claimed the channel within the timeout. |

## ARI Events

### CallBroadcast Event

Sent simultaneously over the WebSocket to all connected ARI applications (or the
filtered subset) when `StasisBroadcast()` is called. Your application evaluates the
event and decides whether to claim the channel.

```json title="CallBroadcast event (example)"
{
  "type": "CallBroadcast",
  "application": "my-ari-app",
  "timestamp": "2026-02-25T10:15:00.000+0000",
  "asterisk_id": "my-asterisk-server",
  "channel": {
    "id": "1740477300.1",
    "name": "PJSIP/Alice-00000001",
    "state": "Up",
    "caller": {
      "name": "Alice",
      "number": "200"
    },
    "connected": {
      "name": "",
      "number": ""
    },
    "accountcode": "",
    "dialplan": {
      "context": "default",
      "exten": "1000",
      "priority": 3
    },
    "creationtime": "2026-02-25T10:15:00.000+0000",
    "language": "en",
    "channelvars": {
      "SKILL_REQUIRED": "billing",
      "PRIORITY": "high"
    }
  },
  "caller": "200",
  "called": "1000"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | string | yes | Always `"CallBroadcast"`. |
| `application` | string | yes | Name of the ARI application receiving this event. |
| `timestamp` | Date | yes | Time the broadcast was initiated. |
| `channel` | Channel | yes | Full channel snapshot. Includes `channelvars` if configured in `ari.conf`. |
| `caller` | string | no | Caller ID number of the originating party. |
| `called` | string | no | Dialled extension. |
| `asterisk_id` | string | no | Asterisk system identifier. |

### CallClaimed Event

Sent when a channel has been successfully claimed, if `notify_claimed` was set to
`yes` in the dialplan. Useful for dashboards or observability tooling; not required
for normal claim-based dispatch.

```json title="CallClaimed event (example)"
{
  "type": "CallClaimed",
  "application": "my-ari-app",
  "timestamp": "2026-02-25T10:15:00.123+0000",
  "asterisk_id": "my-asterisk-server",
  "channel": { "...": "..." },
  "winner_app": "billing_agent_1"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | string | yes | Always `"CallClaimed"`. |
| `application` | string | yes | Name of the ARI application receiving this event. |
| `timestamp` | Date | yes | Time the claim was accepted. |
| `channel` | Channel | yes | Channel snapshot at claim time. |
| `winner_app` | string | yes | Name of the application that won the claim. |

## Claiming a Channel

To claim a channel, issue an HTTP `POST` to `/ari/events/claim`:

```
POST /ari/events/claim?channelId={channel_id}&application={app_name}
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `channelId` | yes | The unique ID of the channel from the `CallBroadcast` event (`channel.id`). |
| `application` | yes | The ARI application name making the claim. Must match the application's registered name. |

### Response Codes

| Code | Meaning |
|------|---------|
| `204 No Content` | Claim accepted. The channel will enter your application via a `StasisStart` event. |
| `409 Conflict` | Another application already claimed this channel. |
| `404 Not Found` | No broadcast is active for the given channel ID (already timed out or cleaned up). |

/// note | Race timing
The claim endpoint is designed for concurrent access. Multiple applications can call
it simultaneously; exactly one will receive `204`. The rest receive `409`. There is no
need for external locking or coordination between applications.
///

## Example: Python

The following is a complete, self-contained ARI client that connects to Asterisk,
listens for `CallBroadcast` events, applies routing logic, and claims matching calls.
When the channel arrives via `StasisStart`, it answers and plays a greeting.

```python title="broadcast_agent.py" linenums="1"
#!/usr/bin/env python3
"""
StasisBroadcast ARI client.

Usage:
    python3 broadcast_agent.py <app_name> [host:port] [username] [password]

Requirements:
    pip install websocket-client requests
"""

import sys
import json
import time
import random
import logging
import requests
import websocket

logging.basicConfig(level=logging.INFO, format='%(message)s')
log = logging.getLogger(__name__)

APP_NAME      = sys.argv[1] if len(sys.argv) > 1 else 'my_agent'
ASTERISK_HOST = sys.argv[2] if len(sys.argv) > 2 else 'localhost:8088'
USERNAME      = sys.argv[3] if len(sys.argv) > 3 else 'asterisk'
PASSWORD      = sys.argv[4] if len(sys.argv) > 4 else 'asterisk'

host, _, port = ASTERISK_HOST.partition(':')
port = port or '8088'

BASE_URL = f'http://{host}:{port}/ari'
WS_URL   = f'ws://{host}:{port}/ari/events?app={APP_NAME}&api_key={USERNAME}:{PASSWORD}'


def should_claim(event):
    """
    Return True if this application should try to claim the channel.
    Customise this function to implement your routing logic.
    """
    caller    = event.get('caller', '')
    called    = event.get('called', '')
    variables = event.get('channel', {}).get('channelvars', {})

    # Example: billing agents only handle calls to extensions starting with 3
    if APP_NAME.startswith('billing_') and called.startswith('3'):
        return True

    # Example: route based on a channel variable set in the dialplan
    if variables.get('SKILL_REQUIRED') == 'billing' and 'billing' in APP_NAME:
        return True

    return False


def claim_channel(channel_id):
    """Attempt to claim channel_id. Returns True on success."""
    resp = requests.post(
        f'{BASE_URL}/events/claim',
        params={'channelId': channel_id, 'application': APP_NAME},
        auth=(USERNAME, PASSWORD),
        timeout=5,
    )
    if resp.status_code == 204:
        log.info('[%s] Claim accepted', channel_id)
        return True
    elif resp.status_code == 409:
        log.info('[%s] Already claimed by another app', channel_id)
    elif resp.status_code == 404:
        log.info('[%s] Broadcast expired before claim', channel_id)
    else:
        log.warning('[%s] Unexpected claim response: %s', channel_id, resp.status_code)
    return False


def on_call_broadcast(event):
    channel_id = event['channel']['id']
    log.info('CallBroadcast: channel=%s caller=%s called=%s',
             channel_id, event.get('caller'), event.get('called'))

    if should_claim(event):
        claim_channel(channel_id)
    else:
        log.info('[%s] Not claiming — routing criteria not met', channel_id)


def on_stasis_start(event):
    """Channel has entered our application. Apply business logic here."""
    channel = event['channel']
    channel_id = channel['id']
    log.info('[%s] StasisStart — channel is ours', channel_id)

    # Answer the channel
    requests.post(f'{BASE_URL}/channels/{channel_id}/answer',
                  auth=(USERNAME, PASSWORD), timeout=5)

    # Play a greeting; handle hangup via the PlaybackFinished event
    requests.post(f'{BASE_URL}/channels/{channel_id}/play',
                  params={'media': 'sound:hello-world'},
                  auth=(USERNAME, PASSWORD), timeout=5)


def on_playback_finished(event):
    target = event.get('playback', {}).get('target_uri', '')
    if target.startswith('channel:'):
        channel_id = target.split(':', 1)[1]
        requests.delete(f'{BASE_URL}/channels/{channel_id}',
                        auth=(USERNAME, PASSWORD), timeout=5)


def on_message(ws, raw):
    event = json.loads(raw)
    etype = event.get('type')
    if etype == 'CallBroadcast':
        on_call_broadcast(event)
    elif etype == 'StasisStart':
        on_stasis_start(event)
    elif etype == 'StasisEnd':
        log.info('[%s] StasisEnd', event['channel']['id'])
    elif etype == 'PlaybackFinished':
        on_playback_finished(event)


ws = websocket.WebSocketApp(WS_URL, on_message=on_message)
log.info('Connecting as "%s" ...', APP_NAME)
ws.run_forever()
```

Start multiple instances, each with a distinct application name, to simulate competing agents:

```bash title=" "
python3 broadcast_agent.py billing_agent_1 localhost:8088 asterisk asterisk &
python3 broadcast_agent.py billing_agent_2 localhost:8088 asterisk asterisk &
python3 broadcast_agent.py support_agent_1 localhost:8088 asterisk asterisk &
```

## Example: Node.js

The Node.js example uses the
[`ari-client`](https://github.com/asterisk/node-ari-client) library and follows the
same structure as the Python example.

```javascript title="broadcast_agent.js" linenums="1"
#!/usr/bin/env node
/**
 * StasisBroadcast ARI client (Node.js)
 *
 * Usage:
 *   node broadcast_agent.js <app_name> [host:port] [username] [password]
 *
 * Requirements:
 *   npm install ari-client
 */

const ari         = require('ari-client');
const http        = require('http');
const querystring = require('querystring');

const APP_NAME      = process.argv[2] || 'my_agent';
const ASTERISK_HOST = process.argv[3] || 'localhost:8088';
const USERNAME      = process.argv[4] || 'asterisk';
const PASSWORD      = process.argv[5] || 'asterisk';

const [host, port = '8088'] = ASTERISK_HOST.split(':');
const BASE_URL = `http://${host}:${port}/ari`;

/** Return true if this application should try to claim the channel. */
function shouldClaim(event) {
    const called    = event.called || '';
    const variables = (event.channel && event.channel.channelvars) || {};

    if (APP_NAME.startsWith('billing_') && called.startsWith('3')) return true;
    if (variables.SKILL_REQUIRED === 'billing' && APP_NAME.includes('billing')) return true;

    return false;
}

/** Attempt to claim channel_id. Returns a Promise<boolean>. */
function claimChannel(channelId) {
    return new Promise((resolve) => {
        const qs = querystring.stringify({ channelId, application: APP_NAME });
        const req = http.request({
            hostname: host, port, method: 'POST',
            path: `/ari/events/claim?${qs}`,
            auth: `${USERNAME}:${PASSWORD}`,
        }, (res) => {
            res.resume();  // drain the body
            if (res.statusCode === 204) {
                console.log(`[${channelId}] Claim accepted`);
                resolve(true);
            } else {
                console.log(`[${channelId}] Claim failed: ${res.statusCode}`);
                resolve(false);
            }
        });
        req.on('error', (e) => { console.error(e); resolve(false); });
        req.end();
    });
}

ari.connect(`http://${host}:${port}`, USERNAME, PASSWORD, (err, client) => {
    if (err) { console.error('Connect error:', err); process.exit(1); }

    console.log(`Connected as "${APP_NAME}". Waiting for broadcasts...`);
    client.start(APP_NAME);

    client.on('CallBroadcast', async (event) => {
        const channelId = event.channel.id;
        console.log(`CallBroadcast: channel=${channelId} caller=${event.caller} called=${event.called}`);

        if (shouldClaim(event)) {
            await claimChannel(channelId);
        } else {
            console.log(`[${channelId}] Not claiming — routing criteria not met`);
        }
    });

    client.on('StasisStart', (event, channel) => {
        console.log(`[${channel.id}] StasisStart — channel is ours`);

        channel.answer().then(() => {
            return client.channels.play({ channelId: channel.id, media: 'sound:hello-world' });
        }).then((playback) => {
            playback.on('PlaybackFinished', () => channel.hangup());
        }).catch((e) => console.error(e));

        channel.on('StasisEnd', () => console.log(`[${channel.id}] StasisEnd`));
    });
});

process.on('SIGINT', () => process.exit(0));
```

## Advanced Topics

### Filtering by Application Name

The `app_filter` parameter accepts a regular expression. Only ARI applications whose
registered name matches the regex receive the `CallBroadcast` event:

```ini title="extensions.conf"
; Only notify applications whose names start with "billing_"
exten => 3000,1,StasisBroadcast(1000,^billing_)

; Notify apps matching either "sales" or "support"
exten => 4000,1,StasisBroadcast(1000,sales|support)

; Use a channel variable to build the regex dynamically
; (dialplan variables are expanded before the application sees its arguments)
exten => 5000,1,Set(REGION=eu-west)
 same => n,StasisBroadcast(2000,^agent-${REGION}-.*)
```

/// note
Because dialplan arguments are comma-delimited, literal commas are not allowed in
the regex. Use character classes (`[,]`) if a literal comma is required. In
practice, application names do not contain commas, so this is rarely a concern.
///

### Routing with Channel Variables

For routing decisions based on call metadata, set channel variables before calling
`StasisBroadcast()` and list them in `ari.conf` under `channelvars`:

```ini title="extensions.conf — setting routing variables"
exten => _1XXX,1,NoOp()
 same => n,Set(SKILL_REQUIRED=billing)
 same => n,Set(PRIORITY=high)
 same => n,StasisBroadcast(1000)
```

The variables appear in `event.channel.channelvars` in the `CallBroadcast` event,
allowing each ARI application to make an informed routing decision without a
centralised lookup.

### Timeout and Fallback Handling

Choose a `timeout` that balances responsiveness against the time your applications
need to evaluate the call:

```ini title="extensions.conf — timeout and fallback"
[default]
exten => _X.,1,Answer()
 same => n,StasisBroadcast(2000)   ; wait up to 2 seconds

 ; --- Handle all outcomes ---
 same => n,GotoIf($["${STASISSTATUS}" = "SUCCESS"]?done)
 same => n,GotoIf($["${STASISSTATUS}" = "FAILED"]?failed)
 ; TIMEOUT: no agent claimed the call
 same => n,Playback(sorry-no-agent)
 same => n,Hangup()

 same => n(done),Hangup()

 same => n(failed),Playback(an-error-has-occured)
 same => n,Hangup()
```

### Passing Arguments to the Winning Application

The `args` parameter is forwarded to the winning application in its `StasisStart`
event as the `args` array, equivalent to `Stasis(app,arg1,arg2)`.

/// note | Colon delimiter vs. `Stasis()` comma delimiter
In `Stasis(app,arg1,arg2)`, extra arguments are additional comma-delimited positions
in the dialplan. In `StasisBroadcast()`, the entire `args` value is a single
comma-delimited position, so a different separator is needed inside it: **colons**.
Both end up producing the same `args` array in the `StasisStart` event.
///

```ini title="extensions.conf — passing args"
exten => 5000,1,StasisBroadcast(1000,,queue-a:priority-high)
```

In the winning application:

```python
def on_stasis_start(event):
    args = event.get('args', [])
    queue    = args[0] if len(args) > 0 else None   # 'queue-a'
    priority = args[1] if len(args) > 1 else None   # 'priority-high'
```
