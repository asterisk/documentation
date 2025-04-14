---
title: Asterisk 14 Project - URI Media Playback
pageid: 30279111
---

Project Overview
================

One of the features that was discussed for the [Asterisk 13 Projects](/Development/Roadmap/Asterisk-13-Projects) was the ability to playback media from a URI to a channel or bridge. See <http://lists.digium.com/pipermail/asterisk-app-dev/2014-April/000425.html> for more information.

!!! note 
    The conversation on the mailing list included both playback of a URI, as well as allowing for a unicast stream of media to be injected into a channel/bridge. At this time, that would be considered a separate project from this one.

[//]: # (end-note)

The primary reason to add this feature is scalability. Allowing sounds to be placed on a remote HTTP server allows a cluster of Asterisk servers to access and pull down the sounds as needed. This is much easier for system administration, as the sounds don't have to all be pushed to individual Asterisk machines.

Requirements and Specification
==============================

### Extensions

Normally, Asterisk eschews usage of a file extension and instead picks the best extension available based on the native formats of the channel. In the case of a remote URI, this impractical as the URI represents a unique location to retrieve. The optimal file extension may not be present, and checking for each file extension may be costly.

As such, the extension should be provided of the resource to retrieve; however, that may not result in a playable file depending on the channel formats. That is expected behaviour.

### URI Schemes

Playback of a remote URI should support both HTTP and HTTPS.

### Caching

When a sound file has been retrieved, it should be cached on the local server. The management of the file should follow standard HTTP caching rules - for more information, see:

<https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching>

Generally, the rules should follow as such:

* If a `Cache-Control` header is included, Asterisk will obey whatever rules it specifies. In particular, the following should be checked:
	+ If `no-cache` is specified, the resulting file is marked as always 'dirty' - that is, we have to always retrieve a new resource from the server.
	+ If `no-store` is specified, Asterisk must attempt to purge the information before Asterisk shutdown and will always retrieve the resource from the server.

	---

	**Note:**  We can't play back the file if we don't store it temporarily on disk. With file streams, we may not get notified when the playback completes, so it may be difficult to purge it out of the cache until Asterisk shuts down. If Asterisk does shut down however, we have an opportunity to flush it out of any semi-permanent storage we may have set up.

	---
	+ `s-maxage` or `max-age`: mark the file as 'dirty' after so many seconds.
* If the cached resource is 'dirty', look at the `E-Tag` header on the remote resource and compare it to the local `E-Tag`. If the two are different, retrieve the resource and update the entry in the cache. If the cached resource was retrieved with `no-store`, then we always retrieve the full resource.

CLI commands and an ARI resource should be provided to view the local cached files, the last time they were updated, and their originating URIs. Similar mechanisms should be provided to flush the entire cache.

### Video

Video is particularly difficult, as it typically requires multiple files (one video, one audio) to be useful. Container formats are beyond the scope of this project. To support video, remote playback of URIs should support a parallel form of extraction using the pipe `|` character:

```
same => n,Playback(http://myserver.com/monkeys.h264|http://myserver.com/monkeys.wav)

```

The behaviour of the files retrieved in such a fashion are as follows:

* Playback does not begin until all files are retrieved.
* Files are treated individually in the cache.
* While files with different names can be played back, the first file in the parallel list will be the actual "core sound file" played back. That is, assuming `monkeys.h264` and `monkeys.wav` already existed on the server, the `Playback` operation would operate on sound file `monkeys`, which would play both the audio and video files.

### Persistence

The cached entries and their metadata should be stored in the `AstDB`. When Asterisk starts, the entries in the `AstDB` should be verified to still be accurate (that is, that the local files still exist), and if so, the buckets for them re-created.

### Playback of a URI

Playback of a URI can be done via any of the supported playback operations, through any API. This functionality should be a part of the Asterisk core, and available through any of the media playback operations.

##### Dialplan

```
same => n,Playback(http://myserver.com/monkeys.wav)

```

Note that this can be combined with multiple URIs or sounds to form a playlist:

```
same => n,Playback(http://myserver.com/monkeys.wav&http://myserver.com/weasels.wav)

```

Since an `&` is valid for a URI but is also used as a separator in dialplan, ampersands in a resource cannot be supported. If an ampersand is used in a URI (say, as part of a query), then the entire URI must be URI encoded.

!!! note 
    URIs in a resource can't be supported, as performing a URI decode on the URI cannot tell the difference between an `&` in a resource and an `&` in a query. That is:

    `http://myserver.com/media?sound=monkeys%26weasels&format=wav => http%3A%2F%2Fmyserver.com%2Fmedia%3Fsound%3dmonkeys%26weasels%26format%3Dwav`

    The latter cannot be decoded correctly as the `&` that forms the query parameter cannot now be distinguished from the already URI encoded `&` in the resource.

[//]: # (end-note)

##### AGI

```
CONTROL STREAM FILE http://myserver.com/monkeys.wav "" 3000

```

##### ARI

Playback can be done on either a channel or a bridge. Since the resource being requested is a URI, it should be presented in the body of the request encoded using `text/uri-list` (see [RFC 2483](https://www.ietf.org/rfc/rfc2483.txt)). Note that we still need to provide a media query parameter that specifies the resource type to play - the actual 'entity' being played back is simply specified in the body of the request.

```
http://localhost:8088/ari/channels/12345/play/p1?media=uri:list

Content-Type: text/uri-list
http://myserver.com/monkeys.wav

```

This format works nicely with simple playlists, as it can specify multiple files to retrieve. Note that these files should be played back sequentially as a playlist (which is not yet supported, but will need to be by the time we get here!)

```
http://localhost:8088/ari/channels/12345/play/p2?media=uri:list

Content-Type: text/uri-list
# Audio File One (I'm a comment and should be ignored)
http://myserver.com/monkeys.wav
# Comment comment comment
http://myserver.com/awesome-sound.wave

```

Note that when the `Content-Type` is `text/uri-list`, the resource specified by the `uri` media scheme is simply tossed away, as we can only have a single list of URIs. Note that this approach is somewhat limiting in that supporting multiples

Another option is to provide the URIs in JSON. This would allow parallel playback of files for video support. Note that the JSON must follow the following schema:

```
http://localhost:8088/ari/channels/12345/play/p3

{
 "media": "playlist",
 "playlist": [
 { "media_group": [
 {
 "scheme": "uri",
 "resource": "http://myserver.com/monkeys.wav"
 },
 {
 "scheme": "uri",
 "resource": "http://myserver.com/monkeys.h264"
 }
 ]
 }
 { "media_group": [
 { "scheme": "uri",
 "resource": "http://myserver.com/awesome-sound.wav",
  }
 ]
 }
 ]
}

```

There's some obvious differences here:

1. The `schema` type **must** be `playlist`. We can't use a `uri` schema type, as doing so would prevent combining `URI` resources with other media resource types for playlists.
2. The playlist must be strongly typed. Otherwise, swagger code generation turns into a nightmare. As such, that means a new strongly named body parameter must be used.

Configuration
=============

No configuration should be needed.

Design
======

Core - media_cache
-------------------

This new file in the Asterisk core will provide the following:

* A universal API that the core and rest of Asterisk can do to query for something in the media cache.
* Caching of the bucket information in the `AstDB`
* Informing the bucket implementation that a new bucket has been created during startup (or otherwise creating the buckets itself)
* CLI commands

Implementations of a cache should implement the `bucket` API for a particular scheme.

### API

```
cpp/*
 * \brief Return whether or not a URI is currently stored in the cache
 *
 * \param uri The URI to the resource to query
 *
 * \retval 0 The item is not in the cache
 * \retval 1 The item is in the cache
 */
int ast_media_cache_exists(const char \*uri);

/*
 * \brief Retrieve media from a URI or in the cache
 *
 * \param preferred_file_name If not yet retrieved from the remote server, use the preferred file name
 * for the media file. Note that this does not include the extension of the
 * file, if any.
 * \param file_path Buffer to hold the location of the media on the local file system, minus the extension
 * \param len Length of \c file_path
 *
 * \retval 0 on success
 * \retval -1 on error
 */
int ast_media_cache_retrieve(const char \*uri, const char \*preferred_file_name, char \*file_path, size_t len);

/*!
 * \brief Update an item in the cache
 *
 * \param uri The item to update
 * \param file_path The location to the local file to associate with \c uri
 * \param metadata A list of key/value pairs to store with the URI
 *
 * \retval 0 success
 * \retval -1 error
 */
int ast_media_cache_create_or_update(const char \*uri, const char \*file_path, struct ast_variable \*metadata);

/*
 * \brief Remove an item from the cache
 *
 * \param uri The item to remove
 *
 * \retval 0 success
 * \retval -1 error
 */
int ast_media_cache_delete(const char \*uri);

```

### CLI Commands

#### core show media-cache

Just for fun! It'd be good to see what is in the cache, the timestamps, etc.

```
\*CLI>core show media-cache

URI Last update Local file
http://myserver.com/awesome.wav 2014-10-30 00:52:25 UTC /var/spool/asterisk/media_cache/ahsd98d1.wav
http://myserver.com/monkeys.wav 2014-09-14 10:10:00 UTC /var/spool/asterisk/media_cache/77asdf7a.wav
http://myserver.com/monkeys.h264 2014-09-14 10:10:00 UTC /var/spool/asterisk/media_cache/77asdf7a.h264 

3 items found.

```

Note that the last two files would have been created using a preferred file prefix. This allow the `file` and `app` core to "find" both the audio and the video file when opening up the stream returned by the `file_path` by the `media_cache`.

#### core clear media-cache

This is really a handy way for a system administrator to force files to be pulled down.

```
\*CLI>core clear media-cache

3 items purged.

\*CLI>core show media-cache

URI Last update Local file
0 items found.

```

res_http_media_cache
-----------------------

### File Retrieval

A module should be implemented that does the actual work of using `libcurl` to retrieve a media file from the system subject to caching constraints, if they exist. It should:

* Implement the HTTP caching, noted previously
* cURL files down to a local file, create a bucket, and store the bucket along with the appropriate metadata

Core - Usage of ast_openstream
-------------------------------

Prior to call `ast_openstream`, users who want to support URI playback should first:

* Determine if the provided "file" is actually a URI. A simple 'strncmp' is sufficient for this.
* If so, ask the cache for the actual file. Use that for subsequent calls to `ast_openstream` and `ast_openvstream`.
* If not, move on as normal.

!!! note 
    There are other callers of `ast_openstream`, but it's probably not worth updating `ExternalIVR` (sorry )

[//]: # (end-note)

### Core - file.c::ast_streamfile

This covers most functionality, as most dialplan applications (and other things) end up calling `ast_streamfile`.

### AGI - res_agi.c::handle_streamfile | handle_getoption

AGI implementations of basic sound playback, which emulate their dialplan counterparts. These will need to be updated in the same way as `ast_streamfile`.

Core - HTTP server
------------------

Support for a new Content-Type, `text/uri-list`, needs to be added to the HTTP server. Since we typically parse the body as JSON using `ast_http_get_json`, this should be a new public function `ast_http_get_uri_list` that pulls a body as a `text/uri-list`. Since we now have core support for URIs, a bit of basic support for a list of URIs should be added to `uri.h` and used by the HTTP server.

### http.h

```
/*!
 * \brief Get the text/uri-list body of a request
 *
 * \param ser TCP/TLS session object
 * \param headers List of HTTP headers
 *
 * \retval NULL on error or a body not encoded as text/uri-list
 * \retval A list of URIs. This an ao2 object that must be disposed of by the caller of the function.
 */
struct ast_uri_list \*ast_http_get_uri_list(struct ast_tcptls_session_instance \*ser, struct ast_variable \*headers);

```

### uri.h

```
/*!
 * \brief Get the string representation of a URI
 *
 * \param The URI
 *
 * \retval The string representation of the URI.
 */
const char \*ast_uri_to_string(struct ast_uri \*uri);

struct ast_uri_list;
struct ast_uri_list_iterator;

/*!
 * \brief Create a URI list
 *
 * \retval A new \c ast_uri_list on success. This is an ao2 object.
 * \retval NULL on error
 */
struct ast_uri_list \*ast_uri_list_create(void);

/*!
 * \brief Append a \c ast_uri to a \c ast_uri_list
 *
 * \param uri The \c ast_uri to append
 */
void ast_uri_list_append(struct ast_uri \*uri);

/*!
 * \brief Create an iterator for a \c ast_uri_list
 *
 * \param uri_list The \c ast_uri_list to iterate over
 *
 * \retval A \c ast_uri_list_iterator on success
 * \retval NULL on error
 */
struct ast_uri_list_iterator \*ast_uri_list_iterator_create(struct ast_uri_list \*uri_list);

/*!
 * \brief Dispose of a \c ast_uri_list_iterator
 *
 * \param iterator The \c ast_uri_list_iterator to destroy
 */
void ast_uri_list_iterator_destroy(struct ast_uri_list_iterator \*iterator);

/*!
 * \brief Retrieve the next \c ast_uri in an \c ast_uri_list
 *
 * \param iterator The \c ast_uri_list_iterator for the list
 *
 * \retval NULL if no more items in the list
 * \retval The next \c ast_uri otherwise
 */
struct ast_uri \*ast_uri_list_iterator_next(struct ast_uri_list_iterator \*iterator);

```

ARI
---

### Swagger Schema

Providing a 'type' for the `media` parameter is a bit tricky. We have the following situation:

* If the `media` parameter does not specify a resource type of `uri`, treat it as a string.
* If the `media` parameter does specify a resource type of `uri`, look to the body as a URI list.
* If the `media` parameter is in the body, however, it must be of type `string`. Hence, we cannot specify the URIs directly in the `media` parameter. Thus, to specify URIs, a body parameter of `playlist` must be provided and the URIs provided in a `Playlist` model object.

```json title="playbacks.json" linenums="1"
js "models": {
 "Playback": {
 "id": "Playback",
 "description": "Object representing the playback of media to a channel",
 "properties": {
 "id": {
 "type": "string",
 "description": "ID for this playback operation",
 "required": true
 },
 "media_uri": {
 "type": "string",
 "description": "URI for the media to play back.",
 "required": true
 },
 "playlist": {
 "$ref": "Playlist",
 "description": "If media_uri is of schema type playlist, the playlist to play",
 "required": false
 },
 "target_uri": {
 "type": "string",
 "description": "URI for the channel or bridge to play the media on",
 "required": true
 },
 "language": {
 "type": "string",
 "description": "For media types that support multiple languages, the language requested for playback."
 },
 "state": {
 "type": "string",
 "description": "Current state of the playback operation.",
 "required": true,
 "allowableValues": {
 "valueType": "LIST",
 "values": [
 "queued",
 "playing",
 "complete"
 ]
 }
 }
 }
 }
 "MediaResource": {
 "id": "MediaResource",
 "description": "A single media resource to operate on",
 "properties": {
 "scheme": {
 "type": "string",
 "description": "The type for this media resource.",
 "required": true
 },
 "resource": {
 "type": "string",
 "description": "The actual media resource to manipulate.",
 "required": true
 }
 }
 }
 "MediaGroup": {
 "id": "MediaGroup",
 "description": "One or more MediaResources that are associated together as a logical unit",
 "properties": {
 "media_group": {
 "type": "array",
 "description": "Array of MediaResources to treat as a single logical unit",
 "required": true,
 "items": {
 "$ref": "MediaResource"
 }
 }
 }
 } 
 "Playlist": {
 "id": "Playlist",
 "description": "One or more MediaGroups to play sequentially",
 "properties": {
 "playlist": {
 "type": "array",
 "description": "Array of MediaGroups to play sequentially",
 "required": true,
 "items": {
 "$ref": "MediaGroup"
 }
 }
 }
 }
 }

```

Note that the following for `channels.json` would be repeated for `bridges.json`:

```json title="channels.json" linenums="1"
js {
 "path": "/channels/{channelId}/play",
 "description": "Play media to a channel",
 "operations": [
 {
 "httpMethod": "POST",
 "summary": "Start playback of media.",
 "notes": "The media URI may be any of a number of URI's. Currently sound:, recording:, number:, digits:, characters:, uri:, and tone: URI's are supported. This operation creates a playback resource that can be used to control the playback of media (pause, rewind, fast forward, etc.)",
 "nickname": "play",
 "responseClass": "Playback",
 "parameters": [
 ...
 {
 "name": "playlist",
 "description": "A play list to play.",
 "paramType": "body",
 "required": false,
 "allowMultiple": false,
 "$ref": "Playlist"
 }
 ],
 "errorResponses": [
 {
 "code": 404,
 "reason": "Channel not found"
 },
 {
 "code": 409,
 "reason": "Channel not in a Stasis application"
 }
 ]
 }
 ]
 },

```

### Mustache Templates

The Mustache templates generated will need to be modified to check for `text/uri-list` as a possible body type:

* The existing `body_parsing.mustache` should be renamed to note that it parses JSON. The caller of the `body_parsing` routines should be made to only look at the results if the function returns non-NULL.
	+ If it does return NULL, it should also check for a `text/uri-list` using the new function in `http.h`.
	+ The body parsers should be updated for a playback operation to return the structured Playback object.
* A new `text_uri_body_parser` should be added that parses a body into a `struct ast_uri_list`. This should be hard-typed to convert the URI list into a structured Playback object.

!!! note 
    This is limiting, but for now, we don't have any use for a URI list in ARI outside of specifying a list of media resources. If that assumption proves false later, that code should be re-visited.

[//]: # (end-note)

Test Plan
=========

Unit Tests
----------

| Category | Test | Description |
| --- | --- | --- |
| `/main/media_cache/exists` | `nominal` | Nominal test that verifies a valid item in the cache can be found |
| `/main/media_cache/exists` | `non_existent` | Test that verifies that an item in the cache that doesn't exist isn't located |
| `/main/media_cache/exists` | `bad_scheme` | Verify that we reject a URI with an unknown or unsupported scheme |
| `/main/media_cache/exists` | `bad_params` | Pass in bad parameters, make sure we get back a "huh?" |
| `/main/media_cache/retrieve` | `nominal` | Retrieve a file from the Asterisk HTTP server (using magic!) and make sure it is in the cache. Retrieve it again and make sure we didn't do an HTTP request twice. |
| `/main/media_cache/retrieve` | `non_existent` | Ask for a file that doesn't exist. Get an error back. |
| `/main/media_cache/retrieve` | `bad_scheme` | Ask for something that has a bad URI scheme. |
| `/main/media_cache/retrieve` | `bad_params` | Ask for something with no URI and no file_path. Make sure we reject it. |
| `/main/media_cache/retrieve` | `new_file` | Retrieve a media file, cache it. Update the file, ask for the file again; make sure it gets the new copy. |
| `/main/media_cache/retrieve` | `preferred_file_name` | Ask for a file with a preferred file name; verify that we retrieve the file and set the file name accordingly (with the right extension). |
| `/main/media_cache/delete` | `nominal` | Put something in the cache. Call delete; verify the cache is purged. |
| `/main/media_cache/empty` | `nominal` | Call delete on an empty cache; make sure everything is cool. |
| `/main/media_cache/update` | `create` | Verify that a new item in the cache can be created |
| `/main/media_cache/update` | `update` | Verify that an existing item in the cache can be updated |
| `/main/uri` | `to_string` | Test that a constructed URI can be converted back to a string |
| `/main/uri` | `list_ctor` | Verify that we can make a URI list |
| `/main/uri` | `list_append_nominal` | Test appending URIs to a list |
| `/main/uri` | `list_append_off_nominal` | Test appending things that aren't a URI, and make sure we fail appropriately |
| `/main/uri` | `iterator_ctor` | Test nominal creation of an iterator |
| `/main/uri` | `iterator_ctor_off_nominal` | Test off-nominal creation of an iterator with a bad list |
| `/main/uri` | `iterator_iteration` | Test nominal iteration over lists. Include empty lists. |

Asterisk Test Suite
-------------------

| Test | Level | Description |
| --- | --- | --- |
| `funcs/func_curl/read` | Asterisk Test Suite | A regression test that verifies that the current read functionality of `CURL` is maintained |
| `funcs/func_curl/write` | Asterisk Test Suite | Verify that we can cURL a file down and store it |
| `funcs/func_curl/curl_opt/timestamp` | Asterisk Test Suite | Verify that we can retrieve the timestamp from a resource |
| `tests/apps/playback/uri` | Asterisk Test Suite | Verify that the `Playback` dialplan application can playback a remote URI |
| `tests/apps/control_playback/uri` | Asterisk Test Suite | Verify that the `ControlPlayback` dialplan application can playback a remote URI |
| `tests/fastagi/stream-file-uri` | Asterisk Test Suite | Verify that the AGI Stream File command can play a URI |
| `tests/fastagi/control-stream-file-uri` | Asterisk Test Suite | Verify that the AGI Control Stream File command can play a URI |
| `tests/rest_api/channels/playback/playlist` | Asterisk Test Suite | Verify that a Playback resource that contains a playlist can be played back to a channel |
| `tests/rest_api/bridges/playback/playlist` | Asterisk Test Suite | Verify that a Playback resource that contains a playlist can be played back to a bridge |
| `tests/rest_api/channels/playback/uri` | Asterisk Test Suite | Verify that a Playback resource can be created from a URI for a Channel |
| `tests/rest_api/bridges/playback/uri` | Asterisk Test Suite | Verify that a Playback resource can be created from a URI for a Bridge |

Project Planning
================

The following are rough tasks that need to be done in order to complete this feature. These are meant to be guidelines, and should not necessarily be followed verbatim. Note that many of these are actually independent of each other, and can be worked out simultaneously. If you're interested in helping out with any of these tasks, please speak up on the `asterisk-dev` mailing list!

The various phases are meant to be implemented as separately as possible to ease the process of peer review.

Phase One - Core Media Cache
----------------------------

| Task | Description | Status |
| --- | --- | --- |
| Implement the basic API | Mask callbacks into the `bucket` API based on the URI scheme being requested. Add handling for manipulating the created bucket's local file if the predefined filename is provided. | Done |
| Integrate with the AstDB | When items are created via a bucket `create` or `retrieve`, update entries in the AstDB.When Asterisk is started, re-create buckets based on the entries currently in the AstDB. | Done |
| Add CLI commands | Both for showing elements in the media cache as well as for purging the cache. If the cache is purged, remove entries from the AstDB. | Done |

Phase Two - res_http_media_cache
-----------------------------------

| Task | Description | Status |
| --- | --- | --- |
| Create `http_media_cache`. Add bucket wizards for schema types `http` and `https`.* Define basic unit tests for creation/deletion
* Implement bucket wizard callbacks for basic manipulation
 | Generally, get the basic structure of the the thing defined, implement unit tests, and make sure the unit tests fail. TDD. | Done |
| Implement retrieval. Use the underlying `CURL` function to retrieve a provided URI and store as a temporary file (or use the predetermined filename). | A few observations:* This shouldn't worry about marking the cache entries as dirty yet using the caching rules. This should:
	+ Check to see if we have a bucket with the URI. If not, create the bucket.
	+ `cURL` the resource down into the provided file path.
	+ Update the bucket entry with the now locally stored file.
	+ Return the location of the local file on the file system.
 | Done |
| Implement 'dirtying' of cache entry based on HTTP caching rules. | Implement handling of `E-Tags` as well as the `Cache-Control` header. | Done |

Phase Three - Core/dialplan/AGI implementations
-----------------------------------------------

| Task | Description | Status |
| --- | --- | --- |
| Update the `file` core to use the `http_media_cache` | Update the core `file` users of `ast_openstream` to first look for the resource in the `http_media_cache`. If found, use the returned file. | Done |
| Update the dialplan users | Same as the core, except for dialplan functions. | Done |
| Add tests for `Playback` and `ControlPlayback` |  | Done |
| Update the AGI users | Same as the core, except for `res_agi` functions. | Done |
| Add tests for `stream file` and `control stream file` |  | Done |

Phase Four - ARI Playlists
--------------------------

!!! note 
    This is actually a completely separate and super useful feature. URI playbacks really need it to function so... here it is.

    Note that this does not envision complete playlist control (such as 'skip to next sound in the playlist'). That could be added either as part of this work or at a future date.

[//]: # (end-note)

| Task | Description | Status |
| --- | --- | --- |
| Update the JSON schema with JSON playlists | This should require updates to the `Playbacks` model, as well as the `play` operations for `channels` and `bridges`. The mustache templates may need to be updated to properly extract this complex of a body type. | Not Done (see Note below) |
| Re-generate stubs; add connecting logic | Re-generating the stubs will create a new body handler and a more complex 'playlist' object that can be optionally present. This will be passed to the `resource_channels` and `resource_bridges` operations. | Not Done (see Note below) |
| Add a 'playlist' media resource type | * Update `resource_channels:ari_channels_handle_play` and `resource_bridges:ari_handle_play` (boiling down to `ari_bridges_play_helper` ) to understand a body playlist. This should pass it off to `stasis_app_control_play_uri` or an equivalent function for actual handling.
* Update `stasis_app_control_play_uri` or add an equivalent function to actually play the list.
 | Not Done (see Note below) |
| Update `res_stasis_playback` | The various function calls boil down to `play_on_channel` in `res_stasis_playback`. This is passed the actual `Playback` resource object, which now can contain a `Playlist`. The function should be updated to parse out the various items in the playlist and pass them to `ast_control_streamfile_lang`. | Not Done (see Note below) |
| Add `rest_api` tests for playlists. |  | Not Done (see Note below) |

!!! note 
    Arguably, we don't really need a 'playlist' media resource type. Lists of media are now played back in sequence by simply specifying multiple media URIs in a sequence, e.g., `media=``sound:foo.wav,sound:bar.wav`, or as a list, e.g., `media=sound:foo.wav,media=sound:bar.wav`.

    This works as well for remote URIs, although admittedly the syntax is a bit clunky right now:

    `media=sound:http://localhost/foo.wav,media=sound:http://localhost/bar.wav`

[//]: # (end-note)

Phase Five - HTTP Server Updates
--------------------------------

| Task | Description | Status |
| --- | --- | --- |
| Update `uri.h` to support URI lists and URI iterators. | Add unit tests! | Not Done |
| Update `http.h` to support body types of `text/uri-list`. Generate a `ast_uri_list` as a result of said body type. |  | Not Done |

Phase Six - ARI `text/uri-list` support/URI playbacks
-----------------------------------------------------

| Task | Description | Status |
| --- | --- | --- |
| Update mustache templates to understand a body type of `text/uri-list`. Re-generate appropriate stubs. | Body parsing should be made to handle both JSON as well as the `text/uri-list` body type. A `text/uri-list` body parser can be made to explicitly return `Playback` objects suitable for consumption in the existing playlist mechanisms. | Not Done |
| Wire generated code to `resource_channels`, `resource_bridges`. Update API callbacks as needed. | Generally, this should "just work" (or nearly) at this point. We have:* Understanding of URI playbacks in the core
* Understanding of playlists in ARI
* The ability to handle URI playbacks (including parallel playbacks) in `ast_control_streamfile_lang`, which is what is used by `res_stasis_playback:play_on_channel`.

Most of this should be just gluing the pieces together as needed. | Not Done |
| Add URI playback tests to Asterisk Test Suite. |  | Not Done |

JIRA Issues
-----------

Digium/Asterisk JIRAee634d14-2067-31b4-9ca3-00e0845ec070ASTERISK-25654

Contributors
------------

| Name | E-mail Address |
| --- | --- |
| unknown user | [mjordan@digium.com](mailto:mjordan@digium.com) |

Reference Information
=====================

http%3A%2F%[2Fmyserver.com](http://2Fmyserver.com)%2Fmedia%3Fsound%3Dmonkeys%26format%3Dwav
