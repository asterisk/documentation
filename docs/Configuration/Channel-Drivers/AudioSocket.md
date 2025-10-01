---
title: AudioSocket
pageid: 42012937
---

AudioSocket
===========

AudioSocket is a simple TCP-based protocol for sending and receiving real-time audio streams, and sending DTMF digits.

There exists a protocol definition (below), a Go [library](https://github.com/CyCoreSystems/audiosocket), and Asterisk application and channel interfaces.

Protocol definition
-------------------

The singular design goal of AudioSocket is to present the simplest possible audio streaming protocol, initially based on the constraints of Asterisk audio. Each packet contains a three-byte header and a variable payload. The header is composed of a one-byte type and a two-byte length indicator.

The minimum message length is three bytes: type and payload-length. Hangup indication, for instance, is `0x00 0x00 0x00`.

### Types

* `0x00` - Terminate the connection (socket closure is also sufficient)
* `0x01` - Payload will contain the UUID (16-byte binary representation) for the audio stream
* `0x03` - Payload is 1 byte (ascii) DTMF (dual-tone multi-frequency) digit
* `0x10` - Payload is signed linear, 16-bit, 8kHz, mono PCM (little-endian)
* `0x11` - Payload is signed linear, 16-bit, 12kHz, mono PCM (little-endian)
* `0x12` - Payload is signed linear, 16-bit, 16kHz, mono PCM (little-endian)
* `0x13` - Payload is signed linear, 16-bit, 24kHz, mono PCM (little-endian)
* `0x14` - Payload is signed linear, 16-bit, 32kHz, mono PCM (little-endian)
* `0x15` - Payload is signed linear, 16-bit, 44.1kHz, mono PCM (little-endian)
* `0x16` - Payload is signed linear, 16-bit, 48kHz, mono PCM (little-endian)
* `0x17` - Payload is signed linear, 16-bit, 96kHz, mono PCM (little-endian)
* `0x18` - Payload is signed linear, 16-bit, 192kHz, mono PCM (little-endian)
* `0xff` - An error has occurred; payload is the (optional) application-specific error code. Asterisk-generated error codes are listed below.

### Payload length

The payload length is a 16-bit unsigned integer (big endian) indicating how many bytes are in the payload.

### Payload

The content of the payload is defined by the header: type and length.
