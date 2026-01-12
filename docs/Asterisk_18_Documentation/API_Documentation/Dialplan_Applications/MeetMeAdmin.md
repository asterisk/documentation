---
search:
  boost: 0.5
title: MeetMeAdmin
---

# MeetMeAdmin()

### Synopsis

MeetMe conference administration.

### Description

Run admin _command_ for conference _confno_.<br>

Will additionally set the variable **MEETMEADMINSTATUS** with one of the following values:<br>


* `MEETMEADMINSTATUS`

    * `NOPARSE` - Invalid arguments.

    * `NOTFOUND` - User specified was not found.

    * `FAILED` - Another failure occurred.

    * `OK` - The operation was completed successfully.

### Syntax


```

MeetMeAdmin(confno,command,[user])
```
##### Arguments


* `confno`

* `command`

    * `e` - Eject last user that joined.<br>


    * `E` - Extend conference end time, if scheduled.<br>


    * `k` - Kick one user out of conference.<br>


    * `K` - Kick all users out of conference.<br>


    * `l` - Unlock conference.<br>


    * `L` - Lock conference.<br>


    * `m` - Unmute one user.<br>


    * `M` - Mute one user.<br>


    * `n` - Unmute all users in the conference.<br>


    * `N` - Mute all non-admin users in the conference.<br>


    * `r` - Reset one user's volume settings.<br>


    * `R` - Reset all users volume settings.<br>


    * `s` - Lower entire conference speaking volume.<br>


    * `S` - Raise entire conference speaking volume.<br>


    * `t` - Lower one user's talk volume.<br>


    * `T` - Raise one user's talk volume.<br>


    * `u` - Lower one user's listen volume.<br>


    * `U` - Raise one user's listen volume.<br>


    * `v` - Lower entire conference listening volume.<br>


    * `V` - Raise entire conference listening volume.<br>


* `user`

### See Also

* [Dialplan Applications MeetMe](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMe)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 