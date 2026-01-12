---
search:
  boost: 0.5
title: stasis
---

# stasis

This configuration documentation is for functionality provided by stasis.

## Configuration File: stasis.conf

### [threadpool]: Settings that configure the threadpool Stasis uses to deliver some messages.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| idle_timeout_sec| Integer| 20| false| Number of seconds before an idle thread is disposed of.| |
| initial_size| Integer| 5| false| Initial number of threads in the message bus threadpool.| |
| max_size| Integer| 50| false| Maximum number of threads in the threadpool.| |


### [declined_message_types]: Stasis message types for which to decline creation.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [decline](#decline)| Custom| | false| The message type to decline.| |


#### Configuration Option Descriptions

##### decline

This configuration option defines the name of the Stasis message type that Asterisk is forbidden from creating and can be specified as many times as necessary to achieve the desired result.<br>


* `stasis_app_recording_snapshot_type`

* `stasis_app_playback_snapshot_type`

* `stasis_test_message_type`

* `confbridge_start_type`

* `confbridge_end_type`

* `confbridge_join_type`

* `confbridge_leave_type`

* `confbridge_start_record_type`

* `confbridge_stop_record_type`

* `confbridge_mute_type`

* `confbridge_unmute_type`

* `confbridge_talking_type`

* `cel_generic_type`

* `ast_bridge_snapshot_type`

* `ast_bridge_merge_message_type`

* `ast_channel_entered_bridge_type`

* `ast_channel_left_bridge_type`

* `ast_blind_transfer_type`

* `ast_attended_transfer_type`

* `ast_endpoint_snapshot_type`

* `ast_endpoint_state_type`

* `ast_device_state_message_type`

* `ast_test_suite_message_type`

* `ast_mwi_state_type`

* `ast_mwi_vm_app_type`

* `ast_format_register_type`

* `ast_format_unregister_type`

* `ast_manager_get_generic_type`

* `ast_parked_call_type`

* `ast_channel_snapshot_type`

* `ast_channel_dial_type`

* `ast_channel_varset_type`

* `ast_channel_hangup_request_type`

* `ast_channel_dtmf_begin_type`

* `ast_channel_dtmf_end_type`

* `ast_channel_flash_type`

* `ast_channel_hold_type`

* `ast_channel_unhold_type`

* `ast_channel_chanspy_start_type`

* `ast_channel_chanspy_stop_type`

* `ast_channel_fax_type`

* `ast_channel_hangup_handler_type`

* `ast_channel_moh_start_type`

* `ast_channel_moh_stop_type`

* `ast_channel_monitor_start_type`

* `ast_channel_monitor_stop_type`

* `ast_channel_mixmonitor_start_type`

* `ast_channel_mixmonitor_stop_type`

* `ast_channel_mixmonitor_mute_type`

* `ast_channel_agent_login_type`

* `ast_channel_agent_logoff_type`

* `ast_channel_talking_start`

* `ast_channel_talking_stop`

* `ast_security_event_type`

* `ast_named_acl_change_type`

* `ast_local_bridge_type`

* `ast_local_optimization_begin_type`

* `ast_local_optimization_end_type`

* `stasis_subscription_change_type`

* `ast_multi_user_event_type`

* `stasis_cache_clear_type`

* `stasis_cache_update_type`

* `ast_network_change_type`

* `ast_system_registry_type`

* `ast_cc_available_type`

* `ast_cc_offertimerstart_type`

* `ast_cc_requested_type`

* `ast_cc_requestacknowledged_type`

* `ast_cc_callerstopmonitoring_type`

* `ast_cc_callerstartmonitoring_type`

* `ast_cc_callerrecalling_type`

* `ast_cc_recallcomplete_type`

* `ast_cc_failure_type`

* `ast_cc_monitorfailed_type`

* `ast_presence_state_message_type`

* `ast_rtp_rtcp_sent_type`

* `ast_rtp_rtcp_received_type`

* `ast_call_pickup_type`

* `aoc_s_type`

* `aoc_d_type`

* `aoc_e_type`

* `dahdichannel_type`

* `mcid_type`

* `session_timeout_type`

* `cdr_read_message_type`

* `cdr_write_message_type`

* `cdr_prop_write_message_type`

* `corosync_ping_message_type`

* `agi_exec_start_type`

* `agi_exec_end_type`

* `agi_async_start_type`

* `agi_async_exec_type`

* `agi_async_end_type`

* `queue_caller_join_type`

* `queue_caller_leave_type`

* `queue_caller_abandon_type`

* `queue_member_status_type`

* `queue_member_added_type`

* `queue_member_removed_type`

* `queue_member_pause_type`

* `queue_member_penalty_type`

* `queue_member_ringinuse_type`

* `queue_agent_called_type`

* `queue_agent_connect_type`

* `queue_agent_complete_type`

* `queue_agent_dump_type`

* `queue_agent_ringnoanswer_type`

* `meetme_join_type`

* `meetme_leave_type`

* `meetme_end_type`

* `meetme_mute_type`

* `meetme_talking_type`

* `meetme_talk_request_type`

* `appcdr_message_type`

* `forkcdr_message_type`

* `cdr_sync_message_type`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 