---
title: Asterisk Module Support States
pageid: 13076175
---

Introduction
============

In Asterisk, modules can take one of three supported states. These states include:

* Core
* Extended
* Deprecated

The definition of the various states is described in the following sections.

Core
----

Most modules in Asterisk are in the Core state, which means issues found with these modules can freely be reported to the Asterisk issue tracker, where the issue will be triaged and placed into a queue for resolution. Core modules are supported by both Sangoma and the community.

Extended
--------

This module is supported by the Asterisk community, and may or may not have an active developer. Some extended modules have active community developers; others do not. Issues reported against these modules may have a low level of support. For more information about which extended support modules have an active developer supporting them, see [Asterisk Open Source Maintainers.](/Development/Asterisk-Open-Source-Maintainers) Extended modules receive no bug fix support from Sangoma. Sangoma will try to ensure they continue to build and investigate security issues, but that is the extent of support.

Deprecated
----------

The module will remain in the tree, but there is a better way to do it. For module deprecation policy and process please see [Module Deprecation](/Development/Policies-and-Procedures/Module-Deprecation). Deprecated modules receive no bug fix support from Sangoma. Sangoma will try to ensure they continue to build and investigate security issues, but that is the extent of support.

MODULEINFO Configurations
=========================

At the top of modules there is the ability to set meta information about that module. Currently we have the following tags:

```
<defaultenabled>
<use>
<depend>
```
The meta data added to **MODULEINFO** in the module causes data to be generated in *menuselect*. For example, when you use ```<defaultenabled>no</defaultenabled>``` the module will not be selected by default. We would use the ```<defaultenabled>``` tag for *deprecated* modules so that they are not built unless explicitly selected by an Asterisk administrator.

Adding New Metadata
-------------------

On top of the existing tags, we would add two additional tags to communicate via menuselect that a module was extended or deprecated (and what module supersedes the deprecated module). These tags include:

- ```<support_level>```
	+ *Example: ```<support_level>deprecated</support_level>```*  --  This module would be deprecated. Maintenance of this module may not exist. It is possible this module could eventually be tagged as deprecated, or removed from the tree entirely.
- ```<replacement>```
	+ *Example: ```<replacement>func_odbc</replacement>```  --  The replacement for this module is the func_odbc module. This is used when the ```<support_level>``` is set to **deprecated**.

### Menuselect Display

The following two images show the suggested menuselect output based on the addition of the ```<support_level>``` and ```<replacement>``` tags. This would be a new line that has not been used before, and therefore would be added to menuselect as that new line.

If the **deprecated** value is used, then the value between the ```<replacement>``` tags will replace the value of *app_superQ* as shown in the image below. The text surrounding *app_superQ* would be static (same for all modules that used **deprecated**).

![](menuselect-deprecated.png)

If the ```<support_level>``` tag is used, then the value of *extended* would cause the additional text of **EXTENDED** to be displayed.

![](menuselect-unmaintained.png)

Display in menuselect-newt for supported modules. If no ```<support_level>``` is specified, then it is assumed the module is supported:

![](menuselect-newt-supported.png)

Display in menuselect-newt for extended modules:

![](menuselect-newt-unmaintained.png)

Display in menuselect-newt for deprecated modules:

![](menuselect-newt-deprecated.png)

Listing Modules at Selected Support States
==========================================

You can list the modules at selected support states directly within a checked out branch of the version of the Asterisk source code that you are interested in querying.

Core
----

```make module-list-core```

Extended
--------

```make module-list-extended```

Deprecated
----------

```make module-list-deprecated```

### Example 

```shell
$ git clone git@github.com:asterisk/asterisk.git

$ git checkout releases/certified-22.8

$ make module-list-deprecated
Showing all modules at support level 'deprecated':
apps/app_adsiprog.c
apps/app_getcpeid.c
apps/app_meetme.c
res/res_adsi.c

$ make module-list-core
Showing all modules at support level 'core':
apps/app_agent_pool.c
apps/app_authenticate.c
apps/app_bridgeaddchan.c
apps/app_bridgewait.c
apps/app_cdr.c
apps/app_celgenuserevent.c
apps/app_channelredirect.c
apps/app_chanspy.c
apps/app_confbridge.c
apps/app_controlplayback.c
apps/app_db.c
apps/app_dial.c
apps/app_directed_pickup.c
apps/app_directory.c
apps/app_disa.c
apps/app_dumpchan.c
apps/app_echo.c
apps/app_exec.c
apps/app_flash.c
apps/app_followme.c
apps/app_forkcdr.c
apps/app_milliwatt.c
apps/app_mixmonitor.c
apps/app_originate.c
apps/app_page.c
apps/app_playback.c
apps/app_playtones.c
apps/app_privacy.c
apps/app_queue.c
apps/app_read.c
apps/app_readexten.c
apps/app_record.c
apps/app_sayunixtime.c
apps/app_senddtmf.c
apps/app_sendtext.c
apps/app_skel.c
apps/app_softhangup.c
apps/app_speech_utils.c
apps/app_stack.c
apps/app_stasis.c
apps/app_stream_echo.c
apps/app_system.c
apps/app_talkdetect.c
apps/app_transfer.c
apps/app_userevent.c
apps/app_verbose.c
apps/app_waituntil.c
apps/app_while.c
apps/confbridge/conf_config_parser.c
apps/confbridge/conf_state.c
apps/confbridge/conf_state_empty.c
apps/confbridge/conf_state_inactive.c
apps/confbridge/conf_state_multi.c
apps/confbridge/conf_state_multi_marked.c
apps/confbridge/conf_state_single.c
apps/confbridge/conf_state_single_marked.c
bridges/bridge_builtin_features.c
bridges/bridge_builtin_interval_features.c
bridges/bridge_holding.c
bridges/bridge_native_rtp.c
bridges/bridge_simple.c
bridges/bridge_softmix.c
cdr/cdr_adaptive_odbc.c
cdr/cdr_custom.c
cdr/cdr_manager.c
cel/cel_custom.c
cel/cel_manager.c
cel/cel_odbc.c
channels/chan_bridge_media.c
channels/chan_dahdi.c
channels/chan_iax2.c
channels/chan_motif.c
channels/chan_pjsip.c
channels/chan_rtp.c
channels/chan_websocket.c
channels/dahdi/bridge_native_dahdi.c
channels/iax2/codec_pref.c
channels/iax2/firmware.c
channels/iax2/format_compatibility.c
channels/iax2/netsock.c
channels/iax2/parser.c
channels/iax2/provision.c
channels/pjsip/dialplan_functions.c
channels/sig_analog.c
channels/sig_pri.c
channels/sig_ss7.c
codecs/codec_a_mu.c
codecs/codec_adpcm.c
codecs/codec_alaw.c
codecs/codec_codec2.c
codecs/codec_dahdi.c
codecs/codec_g722.c
codecs/codec_g726.c
codecs/codec_gsm.c
codecs/codec_ilbc.c
codecs/codec_lpc10.c
codecs/codec_resample.c
codecs/codec_speex.c
codecs/codec_ulaw.c
formats/format_g719.c
formats/format_g723.c
formats/format_g726.c
formats/format_g729.c
formats/format_gsm.c
formats/format_h263.c
formats/format_h264.c
formats/format_ilbc.c
formats/format_ogg_vorbis.c
formats/format_pcm.c
formats/format_siren14.c
formats/format_siren7.c
formats/format_sln.c
formats/format_wav.c
formats/format_wav_gsm.c
funcs/func_aes.c
funcs/func_base64.c
funcs/func_blacklist.c
funcs/func_callcompletion.c
funcs/func_callerid.c
funcs/func_cdr.c
funcs/func_channel.c
funcs/func_config.c
funcs/func_curl.c
funcs/func_cut.c
funcs/func_db.c
funcs/func_devstate.c
funcs/func_dialgroup.c
funcs/func_dialplan.c
funcs/func_enum.c
funcs/func_env.c
funcs/func_extstate.c
funcs/func_global.c
funcs/func_groupcount.c
funcs/func_hangupcause.c
funcs/func_holdintercept.c
funcs/func_iconv.c
funcs/func_jitterbuffer.c
funcs/func_lock.c
funcs/func_logic.c
funcs/func_math.c
funcs/func_md5.c
funcs/func_module.c
funcs/func_odbc.c
funcs/func_periodic_hook.c
funcs/func_pjsip_aor.c
funcs/func_pjsip_contact.c
funcs/func_pjsip_endpoint.c
funcs/func_presencestate.c
funcs/func_rand.c
funcs/func_realtime.c
funcs/func_sha1.c
funcs/func_shell.c
funcs/func_sorcery.c
funcs/func_speex.c
funcs/func_sprintf.c
funcs/func_srv.c
funcs/func_strings.c
funcs/func_sysinfo.c
funcs/func_talkdetect.c
funcs/func_timeout.c
funcs/func_uri.c
funcs/func_version.c
funcs/func_vmcount.c
funcs/func_volume.c
main/abstract_jb.c
main/acl.c
main/alaw.c
main/aoc.c
main/app.c
main/asterisk.c
main/astfd.c
main/astmm.c
main/astobj2.c
main/astobj2_global.c
main/audiohook.c
main/autochan.c
main/autoservice.c
main/backtrace.c
main/bridge.c
main/bridge_after.c
main/bridge_channel.c
main/bridge_roles.c
main/bucket.c
main/callerid.c
main/ccss.c
main/cdr.c
main/cel.c
main/channel.c
main/channel_internal_api.c
main/chanvars.c
main/cli.c
main/codec.c
main/codec_builtin.c
main/config.c
main/config_options.c
main/conversions.c
main/core_local.c
main/core_unreal.c
main/crypt.c
main/data_buffer.c
main/datastore.c
main/db.c
main/devicestate.c
main/dial.c
main/dns.c
main/dns_core.c
main/dns_naptr.c
main/dns_query_set.c
main/dns_recurring.c
main/dns_srv.c
main/dns_test.c
main/dns_tlsa.c
main/dns_txt.c
main/dnsmgr.c
main/dsp.c
main/endpoints.c
main/enum.c
main/event.c
main/features.c
main/file.c
main/fixedjitterbuf.c
main/format.c
main/format_cache.c
main/format_cap.c
main/format_compatibility.c
main/frame.c
main/framehook.c
main/fskmodem.c
main/fskmodem_float.c
main/fskmodem_int.c
main/global_datastores.c
main/hashtab.c
main/heap.c
main/http.c
main/image.c
main/indications.c
main/io.c
main/jitterbuf.c
main/json.c
main/libasteriskpj.c
main/loader.c
main/lock.c
main/logger.c
main/manager.c
main/media_cache.c
main/media_index.c
main/message.c
main/mixmonitor.c
main/mwi.c
main/netsock2.c
main/options.c
main/pbx.c
main/pbx_app.c
main/pbx_builtins.c
main/pbx_functions.c
main/pbx_hangup_handler.c
main/pbx_ignorepat.c
main/pbx_include.c
main/pbx_sw.c
main/pbx_switch.c
main/pbx_timing.c
main/pbx_variables.c
main/pickup.c
main/plc.c
main/presencestate.c
main/privacy.c
main/refer.c
main/rtp_engine.c
main/say.c
main/sched.c
main/sdp_srtp.c
main/security_events.c
main/slinfactory.c
main/smoother.c
main/sorcery.c
main/sounds.c
main/srv.c
main/stasis.c
main/stasis_bridges.c
main/stasis_cache.c
main/stasis_cache_pattern.c
main/stasis_channels.c
main/stasis_endpoints.c
main/stasis_message.c
main/stasis_message_router.c
main/stasis_state.c
main/stasis_system.c
main/stdtime/localtime.c
main/strcompat.c
main/stream.c
main/strings.c
main/stun.c
main/syslog.c
main/taskprocessor.c
main/tdd.c
main/term.c
main/test.c
main/threadstorage.c
main/time.c
main/timing.c
main/translate.c
main/udptl.c
main/ulaw.c
main/utf8.c
main/utils.c
main/xml.c
main/xmldoc.c
pbx/pbx_config.c
pbx/pbx_loopback.c
pbx/pbx_spool.c
res/ari/resource_asterisk.c
res/ari/resource_bridges.c
res/ari/resource_channels.c
res/ari/resource_device_states.c
res/ari/resource_events.c
res/ari/resource_mailboxes.c
res/ari/resource_playbacks.c
res/ari/resource_recordings.c
res/res_aeap.c
res/res_agi.c
res/res_ari.c
res/res_ari_applications.c
res/res_ari_asterisk.c
res/res_ari_bridges.c
res/res_ari_channels.c
res/res_ari_device_states.c
res/res_ari_endpoints.c
res/res_ari_events.c
res/res_ari_mailboxes.c
res/res_ari_model.c
res/res_ari_playbacks.c
res/res_ari_recordings.c
res/res_ari_sounds.c
res/res_clialiases.c
res/res_clioriginate.c
res/res_config_curl.c
res/res_config_odbc.c
res/res_config_sqlite3.c
res/res_convert.c
res/res_crypto.c
res/res_curl.c
res/res_fax.c
res/res_format_attr_celt.c
res/res_format_attr_g729.c
res/res_format_attr_h263.c
res/res_format_attr_h264.c
res/res_format_attr_ilbc.c
res/res_format_attr_opus.c
res/res_format_attr_silk.c
res/res_format_attr_siren14.c
res/res_format_attr_siren7.c
res/res_format_attr_vp8.c
res/res_geolocation.c
res/res_http_media_cache.c
res/res_http_post.c
res/res_http_websocket.c
res/res_limit.c
res/res_manager_devicestate.c
res/res_manager_presencestate.c
res/res_musiconhold.c
res/res_mutestream.c
res/res_mwi_devstate.c
res/res_mwi_external.c
res/res_mwi_external_ami.c
res/res_odbc.c
res/res_odbc_transaction.c
res/res_parking.c
res/res_pjproject.c
res/res_pjsip.c
res/res_pjsip_acl.c
res/res_pjsip_authenticator_digest.c
res/res_pjsip_caller_id.c
res/res_pjsip_config_wizard.c
res/res_pjsip_dialog_info_body_generator.c
res/res_pjsip_diversion.c
res/res_pjsip_dlg_options.c
res/res_pjsip_dtmf_info.c
res/res_pjsip_empty_info.c
res/res_pjsip_endpoint_identifier_anonymous.c
res/res_pjsip_endpoint_identifier_ip.c
res/res_pjsip_endpoint_identifier_user.c
res/res_pjsip_exten_state.c
res/res_pjsip_geolocation.c
res/res_pjsip_header_funcs.c
res/res_pjsip_logger.c
res/res_pjsip_messaging.c
res/res_pjsip_mwi.c
res/res_pjsip_mwi_body_generator.c
res/res_pjsip_nat.c
res/res_pjsip_notify.c
res/res_pjsip_one_touch_record_info.c
res/res_pjsip_outbound_authenticator_digest.c
res/res_pjsip_outbound_publish.c
res/res_pjsip_outbound_registration.c
res/res_pjsip_path.c
res/res_pjsip_pidf_body_generator.c
res/res_pjsip_pidf_digium_body_supplement.c
res/res_pjsip_pidf_eyebeam_body_supplement.c
res/res_pjsip_publish_asterisk.c
res/res_pjsip_pubsub.c
res/res_pjsip_refer.c
res/res_pjsip_registrar.c
res/res_pjsip_rfc3326.c
res/res_pjsip_rfc3329.c
res/res_pjsip_sdp_rtp.c
res/res_pjsip_send_to_voicemail.c
res/res_pjsip_session.c
res/res_pjsip_sips_contact.c
res/res_pjsip_stir_shaken.c
res/res_pjsip_t38.c
res/res_pjsip_transport_websocket.c
res/res_pjsip_xpidf_body_generator.c
res/res_realtime.c
res/res_resolver_unbound.c
res/res_rtp_asterisk.c
res/res_rtp_multicast.c
res/res_security_log.c
res/res_sorcery_astdb.c
res/res_sorcery_config.c
res/res_sorcery_memory.c
res/res_sorcery_memory_cache.c
res/res_sorcery_realtime.c
res/res_speech.c
res/res_speech_aeap.c
res/res_srtp.c
res/res_stasis.c
res/res_stasis_answer.c
res/res_stasis_device_state.c
res/res_stasis_mailbox.c
res/res_stasis_playback.c
res/res_stasis_recording.c
res/res_stasis_snoop.c
res/res_stasis_test.c
res/res_stir_shaken.c
res/res_stun_monitor.c
res/res_timing_dahdi.c
res/res_timing_timerfd.c
res/res_websocket_client.c
res/res_xmpp.c
```
