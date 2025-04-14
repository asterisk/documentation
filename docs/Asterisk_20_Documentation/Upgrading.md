# Upgrading to Asterisk 20

## Functionality changes from Asterisk 19.0.0 to Asterisk 20.0.0

### New EXPORT function
 * A new function, EXPORT, allows writing variables
   and functions on other channels, the complement
   of the IMPORT function.

### app_amd
 * An audio file to play during AMD processing can
   now be specified to the AMD application or configured
   in the amd.conf configuration file.

### app_bridgewait
 * Adds the n option to not answer the channel when
   the BridgeWait application is called.

### features
 * The Bridge application now has the n "no answer" option
   that can be used to prevent the channel from being
   automatically answered prior to bridging.

### func_strings
 * Three new functions, TRIM, LTRIM, and RTRIM, are
   now available for trimming leading and trailing
   whitespace.

### res_pjsip
 * A new option named "peer_supported" has been added to the endpoint option
   100rel. When set to this option, Asterisk sends provisional responses
   reliably if the peer supports it. If the peer does not support reliable
   provisional responses, Asterisk sends them normally.

### Transfer feature
 * The following capabilities have been added to the
   transfer feature:

   - The transfer initiation announcement prompt can
   now be customized in features.conf.

   - The TRANSFER_EXTEN variable now can be set on the
   transferer's channel in order to allow the transfer
   function to automatically attempt to go to the extension
   contained in this variable, if it exists. The transfer
   context behavior is not changed (TRANSFER_CONTEXT is used
   if it exists; otherwise the default context is used).

### app_confbridge
 * Adds the end_marked_any option which can be used
   to kick users from a conference after any
   marked user leaves (including marked users).

### db
 * The DBPrefixGet AMI action now allows retrieving
   all of the DB keys beginning with a particular
   prefix.

### locks
 * A new AMI event, DeadlockStart, is now available
   when Asterisk is compiled with DETECT_DEADLOCKS,
   and can indicate that a deadlock has occured.

### res_geolocation
 * Added processing for the 'confidence' element.
 * Added documentation to some APIs.
 * removed a lot of complex code related to the very-off-nominal
   case of needing to process multiple location info sources.
 * Create a new 'ast_geoloc_eprofile_to_pidf' API that just takes
   one eprofile instead of a datastore of multiples.
 * Plugged a huge leak in XML processing that arose from
   insufficient documentation by the libxml/libxslt authors.
 * Refactored stylesheets to be more efficient.
 * Renamed 'profile_action' to 'profile_precedence' to better
   reflect it's purpose.
 * Added the config option for 'allow_routing_use' which
   sets the value of the 'Geolocation-Routing' header.
 * Removed the GeolocProfileCreate and GeolocProfileDelete
   dialplan apps.
 * Changed the GEOLOC_PROFILE dialplan function as follows:
   * Removed the 'profile' argument.
   * Automatically create a profile if it doesn't exist.
   * Delete a profile if 'inheritable' is set to no.
 * Fixed various bugs and leaks
 * Updated Asterisk WiKi documentation.

   Added 4 built-in profiles:
     "<prefer_config>"
     "<discard_config>"
     "<prefer_incoming>"
     "<discard_incoming>"
   The profiles are empty except for having their precedence
   set.

   Added profile parameter "suppress_empty_ca_elements" that
   will cause Civic Address elements that are empty to be
   suppressed from the outgoing PIDF-LO document.

   You can now specify the location object's format, location_info,
   method, location_source and confidence parameters directly on
   a profile object for simple scenarios where the location
   information isn't common with any other profiles.  This is
   mutually exclusive with setting location_reference on the
   profile.

   Added an 'a' option to the GEOLOC_PROFILE function to allow
   variable lists like location_info_refinement to be appended
   to instead of replacing the entire list.

   Added an 'r' option to the GEOLOC_PROFILE function to resolve all
   variables before a read operation and after a Set operation.

### res_musiconhold_answeredonly
 * This change adds an option, answeredonly, that will prevent music
   on hold on channels that are not answered.

### res_pjsip
 * TLS transports in res_pjsip can now reload their TLS certificate
   and private key files, provided the filename of them has not
   changed.

### Applications
 * added support for Danish syntax, playing the correct plural sound file
   dependen on where you have 1 or multipe messages
   based on the existing SE/NO code

 * added that we set DIALEDPEERNUMBER on the outgoing channels
   so it is avalible in b(content^extension^line)
   this add the same behaviour as Dial

### Channel-agnostic MF support
 * A SendMF application and PlayMF manager
   application are now included to send
   arbitrary standard R1 MF tones on the
   current channel or another specified channel.

### Core
 * Bundled PJProject Build

   The build process has been updated to make pjproject troubleshooting
   and development easier. See third-party/pjproject/README-hacking.md or
   https://wiki.asterisk.org/wiki/display/AST/Bundled+PJProject
   for more info.

### Handle non-standard Meter metric type safely
 * A meter_support flag has been introduced that defaults to true to maintain current behaviour.
   If disabled, a counter metric type will be used instead wherever a meter metric type was used,
   the counter will have a "_meter" suffix appended to the metric name.

### MessageSend
 * The MessageSend AMI action has been updated to allow the Destination
   and the To addresses to be provided separately. This brings the
   MessageSend manager command in line with the capabilities of the
   MessageSend dialplan application.

### ToneScan application
 * A new application, ToneScan, allows for
   synchronous detection of call progress
   signals such as dial tone, busy tone,
   Special Information Tones, and modems.

### ami
 * An AMI event now exists for "Wink".

 * AMI events can now be globally disabled using
   the disabledevents [general] setting.

### app_confbridge
 * Added the hear_own_join_sound option to the confbridge user profile to
   control who hears the sound_join audio file. When set to 'yes' the user
   entering the conference and the participants already in the conference
   will hear the sound_join audio file. When set to 'no' the user entering
   the conference will not hear the sound_join audio file, but the
   participants already in the conference will hear the sound_join audio file.

 * Adds the CONFBRIDGE_CHANNELS function which can
   be used to retrieve a list of channels in a ConfBridge,
   optionally filtered by a particular category. This
   list can then be used with functions like SHIFT, POP,
   UNSHIFT, etc.

### app_dtmfstore
 * New application which collects digits
   dialed and stores them into
   a specified variable.

### app_mf
 * Adds MF receiver and sender applications to support
   the R1 MF signaling protocol, including integration
   with the Dial application.

 * Adds an option to ReceiveMF to cap the
   number of digits read at a user-specified
   maximum.

### app_milliwatt
 * The Milliwatt application's existing behavior is
   incorrect in that it plays a constant tone, which
   is not how digital milliwatt test lines actually
   work.

   An option is added so that a proper milliwatt test
   tone can be provided, including a 1 second silent
   interval every 10 seconds. However, for compatability
   reasons, the default behavior remains unchanged.

### app_morsecode
 * Extends the Morsecode application by adding support for
   American Morse code and adds a configurable option
   for the frequency used in off intervals.

### app_originate
 * Codecs can now be specified for dialplan-originated
   calls, as with call files and the manager action.
   By default, only the slin codec is now used, instead
   of all the slin* codecs.

### app_playback
 * A new option 'mix' is added to the Playback application that 
   will play by filename and say.conf. It will look on the format of the 
   name, if it is like say format it will play with say.conf if not it 
   will play the file name.

### app_queue
 * Reload behavior in app_queue has been changed so
   queue and agent stats are not reset during full
   app_queue module reloads. The queue reset stats
   CLI command may still be used to reset stats while
   Asterisk is running.

 * Add field to save the time value when a member enter a queue.
   Shows this time in seconds using 'queue show' command and the
   field LoginTime for responses for AMI the events.

   The output for the CLI command `queue show` is changed by added a
   extra data field for the information of the time login time for each
   member.

 * added that we set DIALEDPEERNUMBER on the outgoing channels
   so it is avalible in b(content^extension^line)
   this add the same behaviour as Dial

 * Load queues and members from Realtime for
   AMI actions: QueuePause, QueueStatus and QueueSummary,
   Applications: PauseQueueMember and UnpauseQueueMember.

 * Added a new AMI action: QueueWithdrawCaller
   This AMI action makes it possible to withdraw a caller from a queue
   back to the dialplan. The call will be signaled to leave the queue
   whenever it can, hence, it not guaranteed that the call will leave
   the queue.

   Optional custom data can be passed in the request, in the WithdrawInfo
   parameter. If the call successfully withdrawn the queue,
   it can be retrieved using the QUEUE_WITHDRAW_INFO variable.

   This can be useful for certain uses, such as dispatching the call
   to a specific extension.

 * The m option now allows an override music on hold
   class to be specified for the Queue application
   within the dialplan.

### app_queue.c
 * Allow multiple files to be streamed for agent announcement.

### app_queues
 * adding support for playing the correct en/et for nordic languages

 * Don't play sound_thanks if there is no leading hold_time message
   When the only announcement is hold time, and there is no hold time (0 min, 0 sec), asterisk will say "thank you for your patience"

### app_read
 * A new option allows the digit '#' to be read literally,
   rather than used exclusively as the input terminator
   character.

### app_sendtext
 * A ReceiveText application has been added that can be
   used in conjunction with the SendText application.

### app_voicemail
 * Add a new 'S' option to VoiceMail which prevents the instructions
   (vm-intro) from being played if a busy/unavailable/temporary greeting
   from the voicemail user is played. This is similar to the existing 's'
   option except that instructions will still be played if no user
   greeting is available.

 * added support for Danish syntax, playing the correct plural sound file
   dependen on where you have 1 or multipe messages
   based on the existing SE/NO code

 * The r option has been added, which prevents deletion
   of messages from VoiceMailMain, which can be
   useful for shared mailboxes.

### apps
 * A new option 'mix' is added to the Playback application that 
   will play by filename and say.conf. It will look on the format of the 
   name, if it is like say format it will play with say.conf if not it 
   will play the file name.

### ari
 * Expose channel driver's unique id (which is the Call-ID for SIP/PJSIP)
   to ARI channel resources as 'protocol_id'.

   ASTERISK-30027

### ast_coredumper
 * New options:
    --pid=<asterisk_pid>
      Allows specification of an Asterisk instance when trying to
      and the script can't determine it itself.
    --libdir=<system library directory>
      Allows specification of a non-standard installation directory
      containing the Asterisk modules.
    --(no-)rename
      Renames the coredump and the output files with readable
      timestamps. This is the default.
   Removed unneeded or confusing options:
    --append-coredumps
    --conffile
    --no-default-search
    --tarball-uniqueid
   Changed Variables:
    COREDUMPS is now just "/tmp/core!(*.txt)"
    DATEFORMAT is renamed to DATEOPTS and defaults to '-u +%FT%H-%M-%SZ'
   Changed behavior:
    If you use 'running' or 'RUNNING' you no longer need to specify
    '--no-default-search' to ignore existing coredumps.

### cdr
 * A new CDR option, channeldefaultenabled, allows controlling
   whether CDR is enabled or disabled by default on
   newly created channels. The default behavior remains
   unchanged from previous versions of Asterisk (new
   channels will have CDR enabled, as long as CDR is
   enabled globally).

### chan_dahdi
 * Previously, cadences were appended on dahdi restart,
   rather than reloaded. This prevented cadences from
   being updated and maxed out the available cadences
   if reloaded multiple times. This behavior is fixed
   so that reloading cadences is idempotent and cadences
   can actually be reloaded.

 * A POLARITY function is now available that allows
   getting or setting the polarity on a channel
   from the dialplan.

### chan_iax2
 * ANI2 (OLI) is now transmitted over IAX2 calls
   as an information element.

 * Both a secret and an outkey may be specified at dial time,
   since encryption is possible with RSA authentication.

### chan_pjsip
 * Add function PJSIP_HEADERS() to get list of headers by pattern in the same way as SIP_HEADERS() do.

   Add ability to read header by pattern using PJSIP_HEADER().

 * added global config option "allow_sending_180_after_183"

   Allow Asterisk to send 180 Ringing to an endpoint
   after 183 Session Progress has been send.
   If disabled Asterisk will instead send only a
   183 Session Progress to the endpoint.

 * Hook flash events can now be sent on a PJSIP channel
   if requested to do so.

### chan_sip
 * Session timers get removed on UPDATE
   Fix if Asterisk receives a SIP REFER with Session-Timers UAC
   that Asterisk maintains Session-Timers when sending UPDATE request

### chan_sip.c
 * resolve issue with pickup on device that uses "183" and not "180"

### channel_internal_api
 * CHANNEL(lastcontext) and CHANNEL(lastexten)
   are now available for use in the dialplan.

### cli
 * The "module refresh" command has been added,
   which allows unloading and then loading a
   module with a single command.

 * A new CLI command 'dialplan eval function' has been
   added which allows users to test the behavior of
   dialplan function calls directly from the CLI.

### func_channel
 * Adds the CHANNEL_EXISTS function to check for the existence
   of a channel by name or unique ID.

### func_db
 * The function DB_KEYCOUNT has been added, which
   returns the cardinality of the keys at a specified
   prefix in AstDB, i.e. the number of keys at a
   given prefix.

### func_env.c
 * Two new functions, DIRNAME and BASENAME, are now
   included which allow users to obtain the directory
   or the base filename of any file.

### func_evalexten
 * This adds the EVAL_EXTEN function which may be
   used to evaluate data at dialplan extensions.

### func_framedrop
 * New function to selectively drop specified frames
   in either direction on a channel.

### func_json
 * The JSON_DECODE dialplan function can now be used
   to parse JSON strings, such as in conjunction with
   CURL for using API responses.

### func_odbc
 * A SQL_ESC_BACKSLASHES dialplan function has been added which
   escapes backslashes. Usage of this is dependent on whether the
   database in use can use backslashes to escape ticks or not. If
   it can, then usage of this prevents a broken SQL query depending
   on how the SQL query is constructed.

### func_scramble
 * Adds an audio scrambler function that may be used to
   distort voice audio on a channel as a privacy
   enhancement.

### func_strings
 * A new STRBETWEEN function is now included which
   allows a substring to be inserted between characters
   in a string. This is particularly useful for transforming
   dial strings, such as adding pauses between digits
   for a string of digits that are sent to another channel.

### func_vmcount
 * Multiple mailboxes may now be specified instead of just one.

### logger
 * Added the ability to define custom log levels in logger.conf
   and use them in the Log dialplan application. Also adds a
   logger show levels CLI command.

### res_agi
 * Agi command 'exec' can now be enabled
   to evaluate dialplan functions and variables
   by setting the variable AGIEXECFULL to yes.

### res_cliexec
 * A new CLI command, dialplan exec application, has
   been added which allows dialplan applications to be
   executed at the CLI, useful for some quick testing
   without needing to write dialplan.

### res_fax_spandsp
 * Adds support for spandsp 3.0.0.

### res_geolocation
 * Added res_geolocation which creates the core capabilities
   to manipulate Geolocation information on SIP INVITEs.

### res_parking
 * An m option to Park and ParkAndAnnounce now allows
   specifying a music on hold class override.

### res_pjproject
 * In pjproject.conf you can now map pjproject log levels
   to the Asterisk TRACE log level.  The default mappings
   have therefore changed so that only pjproject levels
   3 and 4 are mapped to DEBUG and 5 and 6 are now mapped
   to TRACE.  Previously 3, 4, 5, and 6 were all mapped to
   DEBUG.

### res_pjsip
 * A new transport option 'allow_wildcard_certs' has been added that when it
   and 'verify_server' are both set to 'yes', enables verification against
   wildcards, i.e. '*.' in certs for common, and subject alt names of type DNS
   for TLS transport types. Names must start with the wildcard. Partial wildcards,
   e.g. 'f*.example.com' and 'foo.*.com' are not allowed. As well, names only
   match against a single level meaning '*.example.com' matches 'foo.example.com',
   but not 'foo.bar.example.com'.

### res_pjsip_geolocation
 * Added res_pjsip_geolocation which gives chan_pjsip
   the ability to use the core geolocation capabilities.

### res_pjsip_header_funcs
 * Add function PJSIP_RESPONSE_HEADERS() to get list of header names from 200 response, in the same way as PJSIP_HEADERS() from the request.

   Add function PJSIP_RESPONSE_HEADER() to read header from 200 response, in the same way as PJSIP_HEADER() from the request.

### res_pjsip_pubsub
 * A new resource_list option, resource_display_name, indicates
   whether display name of resource or the resource name being
   provided for RLS entries.
   If this option is enabled, the Display Name will be provided.
   This option is disabled by default to remain the previous behavior.
   If the 'event' set to 'presence' or 'dialog' the non-empty HINT name
   will be set as the Display Name.
   The 'message-summary' is not supported yet.

 * The Resource List Subscriptions (RLS) is dynamic now.
   The asterisk now updates current subscriptions to reflect the changes
   to the list on subscription refresh. If list items are added,
   removed, updated or do not exist anymore, the asterisk regenerates
   the resource list.

### res_pjsip_registrar
 * Adds new PJSIP AOR option remove_unavailable to either
   remove unavailable contacts when a REGISTER exceeds
   max_contacts when remove_existing is disabled, or
   prioritize unavailable contacts over other existing
   contacts when remove_existing is enabled.

### res_pjsip_t38
 * In res_pjsip_sdp_rtp, the bind_rtp_to_media_address option and the
   fallback use of the transport's bind address solve problems sending
   media on systems that cannot send ipv4 packets on ipv6 sockets, and
   certain other situations. This change extends both of these behaviors
   to UDPTL sessions as well in res_pjsip_t38, to fix fax-specific
   problems on these systems, introducing a new option
   endpoint/t38_bind_udptl_to_media_address.

### res_rtp_asterisk
 * When the address of the STUN server (stunaddr) is a name resolved via DNS, the
   stunaddr will be recurringly resolved when the DNS answer Time-To-Live (TTL)
   expires. This allows the STUN server to change its IP address without having to
   reload the res_rtp_asterisk module.

### res_tonedetect
 * Arbitrary tone detection is now available through a
   WaitForTone application (blocking) and a TONE_DETECT
   function (non-blocking).

### say.c
 * Adds SAYFILES function to retrieve the file names that would
   be played by corresponding Say applications, such as
   SayDigits, SayAlpha, etc.

   Additionally adds SayMoney and SayOrdinal applications.

### stasis_channels
 * Expose channel driver's unique id (which is the Call-ID for SIP/PJSIP)
   to ARI channel resources as 'protocol_id'.

   ASTERISK-30027
