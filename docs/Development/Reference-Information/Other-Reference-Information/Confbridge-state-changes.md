---
title: Confbridge state changes
pageid: 21463456
---

!!! note 
    This page discusses confbridge state information for internal development use. This is unrelated to the device, extension or presence state concepts at the user level.

[//]: # (end-note)

Intro
=====

The behavior of a conference bridge is defined by 6 states (EMPTY, INACTIVE, SINGLE_UNMARKED, SINGLE_MARKED, MULTI_UNMARKED, MULTI_MARKED), and 6 events (JOIN_UNMARKED, JOIN_WAITMARKED, JOIN_MARKED, LEAVE_UNMARKED, LEAVE_WAITMARKED, LEAVE_MARKED), and by the total number of ACTIVE, WAITING, and MARKED users currently in the conference.

Types of users
==============

### UNMARKED

Unmarked users are the "standard" user of a conference bridge. When they join, they are immediately active in the conference.

### WAITMARKED

Waitmarked users do not actually join the conference until a marked user joins. They start out mute and unable to speak and aren't counted in any conference user counts. When a marked user joins, they become active participants in the conference. When the last marked user leaves, they go back to their waiting state.

### MARKED

Marked users are just like "standard" unmarked users, except that waitmarked users become active when the first marked user joins and become inactive when the last marked user leaves.

States
======

### EMPTY

##### Description

The EMPTY state is the starting state of the conference. EMPTY is defined as no active nor waiting users in the conference.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unmarked | \* | SINGLE | Play the "only person" prompt unless configured not to. |
| JOIN:waitmarked | \* | INACTIVE |   |
| JOIN:marked | \* | SINGLE_MARKED | Play the "placed into the conference" prompt unless configured not to. |
| LEAVE:unmarked | \* | INVALID | You can't have someone leave an empty conference. |
| LEAVE:waitmarked | \* | INVALID |   |
| LEAVE:marked | \* | INVALID |   |

### INACTIVE

##### Description

The INACTIVE state is defined as having *only* inactive/WAITMARKED users.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unamrked | \* | SINGLE | Play the "only person" prompt unless configured not to. |
| JOIN:waitmarked | \* | INACTIVE |   |
| JOIN:marked | \* | MULTI_MARKED | Since there is at least one waitmarked user being made active by the joining marked user, stop MOH/unmute first user if necessary and transition to MULTI_MARKED |
| LEAVE:unmarked | \* | INVALID | There can't be a non-waitmarked user in the conference in this state. |
| LEAVE:waitmarked | waiting == 0 | EMPTY | Since only waitmarked users exist, the last user has left. |
| LEAVE:waitmarked | waiting > 0 | INACTIVE | If their are still waitmarked users, nothing changes. |
| LEAVE:marked | \* | INVALID | There can't be a non-waitmarked user in the conference in this state. |

### SINGLE

##### Description

The SINGLE state is defined as having a single active unmarked user. There can be 0 or more inactive/WAITMARKED users in the SINGLE state.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unmarked | \* | MULTI_UNMARKED | There are now at least two active users. Stop MOH/unmute first user if necessary |
| JOIN:waitmarked | \* | SINGLE | Since waitmarked users don't have an effect, just add them to the waiting list. |
| JOIN:marked | \* | MULTI_MARKED | There are now at least two active users, one of which is marked. Stop MOH/unmute first user if necessary. |
| LEAVE:unmarked | waiting == 0 | EMPTY | If there are not waiting users, the conference is now empty. |
| LEAVE:unmarked | waiting > 0 | INACTIVE | If there are waiting users, the conference now has only waiting users. |
| LEAVE:waitmarked | \* | SINGLE | Since waitmarked users don't have an effect, just remove the user from the waiting list. |
| LEAVE:marked | \* | INVALID | If the user was marked, the conference would be in the SINGLE_MARKED state. |

### SINGLE_MARKED

##### Description

The SINGLE_MARKED state is defined as having a single active marked user. It is not possible for inactive/WAITMARKED users to exist in this state as WAITMARKED users become active in the presence of a marked user and therefor the state would be MULTI_MARKED.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unmarked | \* | MULTI_MARKED | There are now at least two active users, one of which is marked. Stop MOH/unmute first user if necessary |
| JOIN:waitmarked | \* | MULTI_MARKED | Since there is a marked user, the waitmarked behavior is the same as the unmarked |
| JOIN:marked | \* | MULTI_MARKED | There are now two active marked users. Stop MOH/unmute first user if necessary. |
| LEAVE:unmarked | \* | INVALID | There can only be a single marked user in the conference in this state. |
| LEAVE:waitmarked | \* | INVALID | There can only be a single marked user in the conference in this state. |
| LEAVE:marked | \* | EMPTY | The single marked user has left so the conference is now empty. |

### MULTI_UNMARKED

##### Description

The MULTI_UNMARKED state is defined as having more than one active unmarked user and 0 marked users. There can be 0 or more inactive/WAITMARKED users in the MULTI_UNMARKED state.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unmarked | \* | MULTI_UNMARKED | No change. |
| JOIN:waitmarked | \* | MULTI_UNMARKED | No change. |
| JOIN:marked | \* | MULTI_MARKED | There are now multiple active users and a marked user. Transition to MULTI_MARKED. |
| LEAVE:unmarked | active == 1 | SINGLE | When the conference gets down to a single user, transition to SINGLE. |
| LEAVE:unmarked | active > 1 | MULTI_UNMARKED | There are still multiple unmarked users, so no change is necessary. |
| LEAVE:waitmarked | \* | MULTI_UNMARKED | No change. |
| LEAVE:marked | \* | INVALID | There can't be any marked users in this state. |

### MULTI_MARKED

##### Description

The MULTI_MARKED state is defined of having at least one marked user in addition to at least one other active user. When a marked user is present, all WAITMARKED/inactive users become active.

##### Event handling

| Event | Guard | Target state | Notes |
| --- | --- | --- | --- |
| JOIN:unmarked | \* | MULTI_MARKED | No change |
| JOIN:waitmarked | \* | MULTI_MARKED | No change |
| JOIN:marked | \* | MULTI_MARKED | No change |
| LEAVE:unmarked | active == 1 | SINGLE_MARKED | If an unmarked user leaves and there is only one user left, it must be marked. Transition to SINGLE_MARKED. |
| LEAVE:unmarked | active > 1 | MULTI_MARKED | There are still multiple users and at least one marked user. No change. |
| LEAVE:waitmarked | active == 1 | SINGLE_MARKED | Waitmarked users behave as unmarked users in the presence of a marked user. |
| LEAVE:waitmarked | active > 1 | MULTI_MARKED | Waitmarked users behave as unmarked users in the presence of a marked user. |
| LEAVE:marked |   |   | Note that if the last marked user leaves, then the "leader has left" sound plays, all waitmarked users are moved back to waiting, and users set to be kicked when the leader leaves will be kicked. This all happens before a transition decision is made. |
| LEAVE:marked | active == 0 && waiting == 0 | EMPTY | There are no users left, transition to EMPTY. |
| LEAVE:marked | active == 0 && waiting > 0 | INACTIVE | There are only waiting users left, transition to INACTIVE. |
| LEAVE:marked | active == 1 && marked == 0 | SINGLE | There is only one unmarked user left, transition to SINGLE. |
| LEAVE:marked | active == 1 && marked == 1 && waiting == 0 | SINGLE_MARKED | There is only one marked user left, transition to SINGLE_MARKED. |
| LEAVE:marked | active == 1 && marked == 1 && waiting > 0 | MULTI_MARKED | I don't think this can happen since you shouldn't be able to have marked and waiting users. But, if you could, you would be in MULTI_MARKED. |
| LEAVE:marked | active > 1 && marked == 0 | MULTI_UNMARKED | There are multiple users, but no marked users. Transition to MULTI_UNMARKED. |
| LEAVE:marked | active > 1 && marked > 0 | MULTI_MARKED | There are still multiple marked users. No change. |
