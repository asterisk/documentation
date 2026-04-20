
# Function Tracing

Function tracing can sometimes be a useful tool when CPU utilization is an issue.
For that, the `perf` suite of Linux performance tools is your best bet.  A full discussion
of using perf is beyond the scope of this document but here are some basic instructions
for using `perf record` and `perf report` which can give you a good idea of CPU instruction
counts by Asterisk function.  In most cases, `perf` doesn't require special compilation
settings but you may get more accurate results by enabling the recently added
`KEEP_FRAME_POINTERS` menuselect option under `Compiler Flags`.

```shell
# Start perf-record on a running Asterisk process to capture instruction counts and
# latency by function.
# Let it run for a few minutes then use ctrl-c to stop it.
$ sudo perf record -p `pidof asterisk` -q -e instructions --latency --call-graph fp -o perf.out

# Run perf-report to generate the results report.
$ sudo perf report --force -i perf.out --call-graph=none -c asterisk --percentage relative > report.txt

# Filter out kernel and C library calls.
$ sed -i -r -e "/kernel|libc.so.6/d" report.txt
```

The output file will be a few thousand lines long but here's an example:

```
#
# comm: asterisk
#
# Total Lost Samples: 0
#
# Samples: 33K of event 'instructions'
# Event count (approx.): 6561076235
#
# Children  Latency      Self   Latency  Shared Object           Symbol          
# ........  .......  ........  ........  ......................  .................
#
    99.46%   99.56%     0.00%     0.00%  asterisk                [.] dummy_start
    70.01%   68.68%     0.02%     0.01%  asterisk                [.] default_tps_processing_function
    62.30%   62.25%     0.19%     0.15%  asterisk                [.] ast_taskprocessor_execute
    38.04%   42.77%     0.01%     0.01%  asterisk                [.] execute_tasks
    22.81%   21.61%     0.75%     0.71%  asterisk                [.] internal_ao2_traverse
    22.73%   21.57%     0.18%     0.14%  asterisk                [.] __ao2_callback
    21.51%   16.72%     0.04%     0.03%  asterisk                [.] dispatch_exec_async
    19.33%   14.91%     0.11%     0.08%  asterisk                [.] subscription_invoke
    18.73%   14.40%     0.04%     0.03%  asterisk                [.] router_dispatch
    17.85%   21.51%     0.00%     0.00%  res_pjsip.so            [.] distribute
    17.77%   21.43%     0.03%     0.04%  libasteriskpj.so.2      [.] pjsip_endpt_process_rx_data
    15.40%   14.69%     0.00%     0.00%  asterisk                [.] __ast_pbx_run
    15.40%   14.69%     0.00%     0.00%  asterisk                [.] pbx_thread
    14.82%   14.27%     0.00%     0.00%  asterisk                [.] pbx_extension_helper
    14.77%   14.23%     0.00%     0.00%  asterisk                [.] ast_spawn_extension
    14.71%   14.15%     0.00%     0.00%  asterisk                [.] pbx_exec
    14.61%   14.05%     0.00%     0.00%  app_dial.so             [.] dial_exec
    14.60%   14.04%     0.01%     0.01%  app_dial.so             [.] dial_exec_full
    12.51%   15.40%     0.00%     0.00%  res_pjsip_session.so    [.] session_on_rx_request
    12.51%   15.40%     0.00%     0.00%  res_pjsip_session.so    [.] handle_new_invite_request
    11.82%    9.36%     0.00%     0.00%  asterisk                [.] cel_report_event
    11.35%   13.95%     0.00%     0.00%  res_pjsip_session.so    [.] new_invite
    10.82%    9.97%     4.81%     4.70%  asterisk                [.] __ao2_ref
    10.79%   13.57%     0.00%     0.00%  res_pjsip_sdp_rtp.so    [.] create_rtp
    10.54%   12.81%     0.00%     0.01%  asterisk                [.] taskpool_sync_task
    10.42%   13.15%     0.00%     0.00%  asterisk                [.] ast_rtp_instance_new
    10.39%   13.12%     0.00%     0.00%  res_rtp_asterisk.so     [.] ast_rtp_new
     9.86%   12.54%     0.00%     0.00%  res_rtp_asterisk.so     [.] rtp_allocate_transport
     9.24%    7.31%     0.01%     0.01%  res_cdrel_custom.so     [.] cdrel_logger
     9.18%    7.26%     0.29%     0.22%  res_cdrel_custom.so     [.] log_advanced_record
     8.92%   11.37%     0.01%     0.01%  res_rtp_asterisk.so     [.] ice_create
     8.85%    7.15%     0.16%     0.14%  asterisk                [.] __ao2_find
     8.64%    6.90%     0.00%     0.00%  asterisk                [.] cel_backend_send_cb
     8.63%    6.89%     0.00%     0.00%  cel_custom.so           [.] custom_log
     8.20%    6.73%     0.01%     0.01%  asterisk                [.] cel_snapshot_update_cb
     7.98%    6.54%     0.02%     0.01%  asterisk                [.] cel_channel_state_change
     7.61%    6.34%     0.02%     0.01%  asterisk                [.] ast_sem_wait
     7.36%    6.66%     0.00%     0.00%  asterisk                [.] ast_bridge_call
     7.36%    6.66%     0.00%     0.00%  asterisk                [.] ast_bridge_call_with_flags
     7.06%    6.21%     0.37%     0.34%  asterisk                [.] __ao2_cleanup_debug
     6.88%    8.69%     0.00%     0.00%  chan_pjsip.so           [.] call
     6.77%    8.54%     0.01%     0.01%  res_pjsip_session.so    [.] handle_incoming_sdp
     6.71%    8.46%     0.00%     0.00%  res_pjsip_sdp_rtp.so    [.] negotiate_incoming_sdp_stream
     6.62%    6.06%     0.07%     0.05%  asterisk                [.] pbx_builtin_setvar_helper
     6.49%    4.81%     0.00%     0.00%  asterisk                [.] do_devstate_changes
     6.22%    4.59%     0.00%     0.00%  asterisk                [.] do_state_change
     6.20%    7.94%     0.01%     0.02%  res_rtp_asterisk.so     [.] rtp_add_candidates_to_ice
     6.13%    4.52%     0.01%     0.01%  asterisk                [.] _ast_device_state
     6.06%    4.46%     0.06%     0.04%  chan_pjsip.so           [.] chan_pjsip_devicestate
     5.94%    4.94%     0.00%     0.00%  chan_pjsip.so           [.] hangup
     
```

What you're seeing is a list of asterisk functions and what percentage of the total
CPU instructions and wall clock time they're responsible for.  The percentages won't
add up to 100 because of the recursive nature of function calls.  The top dozen or
so are wrapper functions which basically run everything but things get interesting
after that.

If you want to see the results without recussion, add the `--no-children` option to
`perf report`:

```shell
$ sudo perf report -i perf.out --call-graph=none -c asterisk --percentage relative --no-children > report-no-children.txt
```

```
# To display the perf.data header info, please use --header/--header-only options.
#
# comm: asterisk
#
# Total Lost Samples: 0
#
# Samples: 33K of event 'instructions'
# Event count (approx.): 6561076235
#
# Overhead   Latency  Shared Object                          Symbol
# ........  ........  .....................................  ..........................................
#
     4.81%     4.70%  asterisk                               [.] __ao2_ref
     2.57%     4.30%  asterisk                               [.] hash_ao2_find_next
     1.96%     1.65%  libc.so.6                              [.] __printf_buffer
     1.77%     1.48%  libc.so.6                              [.] _int_free_chunk
     1.63%     1.62%  libc.so.6                              [.] _int_malloc
     1.54%     1.40%  libc.so.6                              [.] pthread_mutex_lock@@GLIBC_2.2.5
     1.54%     1.49%  libc.so.6                              [.] __GI___pthread_mutex_unlock_usercnt
     1.53%     1.59%  libc.so.6                              [.] __strcmp_avx2_rtm
     1.32%     1.56%  [kernel.kallsyms]                      [k] perf_iterate_ctx
     1.30%     1.14%  asterisk                               [.] __ao2_lock
     1.21%     1.48%  libc.so.6                              [.] __random_r
     1.13%     1.45%  [kernel.kallsyms]                      [k] __snmp6_fill_stats64.constprop.0
     1.12%     1.09%  asterisk                               [.] hash_ao2_find_first
     1.05%     0.98%  libc.so.6                              [.] __memmove_avx_unaligned_erms_rtm
     0.91%     0.80%  libc.so.6                              [.] tolower
     0.91%     0.89%  libc.so.6                              [.] __libc_calloc
     0.91%     0.97%  [kernel.kallsyms]                      [k] memset_orig
     0.88%     0.74%  libc.so.6                              [.] __strlen_avx2_rtm
     0.85%     0.72%  libc.so.6                              [.] __printf_buffer_write
     0.83%     0.74%  asterisk                               [.] __ao2_unlock
     0.79%     0.63%  asterisk                               [.] ast_str_case_hash
     0.79%     0.68%  libc.so.6                              [.] cfree@GLIBC_2.2.5
     0.75%     0.71%  asterisk                               [.] internal_ao2_traverse
     0.70%     0.54%  asterisk                               [.] ast_event_iterator_next
     0.70%     0.76%  [kernel.kallsyms]                      [k] psi_group_change
     0.68%     0.59%  asterisk                               [.] utf8_check_first
     0.60%     0.72%  libasteriskpj.so.2                     [.] pj_pool_alloc_from_block

```

Now the report shows only the instructions directly executed by the function.
