---
search:
  boost: 0.5
title: MP3Player
---

# MP3Player()

### Synopsis

Play an MP3 file or M3U playlist file or stream.

### Description

Executes mpg123 to play the given location, which typically would be a mp3 filename or m3u playlist filename or a URL. Please read https://en.wikipedia.org/wiki/M3U to see what the M3U playlist file format is like.<br>

Note that mpg123 does not support HTTPS, so use HTTP for web streams.<br>

User can exit by pressing any key on the dialpad, or by hanging up.<br>

``` title="Example: Play an MP3 playlist"

exten => 1234,1,MP3Player(/var/lib/asterisk/playlist.m3u)


```
This application does not automatically answer and should be preceeded by an application such as Answer() or Progress().<br>


### Syntax


```

MP3Player(Location)
```
##### Arguments


* `Location` - Location of the file to be played. (argument passed to mpg123)<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 