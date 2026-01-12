---
search:
  boost: 0.5
title: app_skel
---

# app_skel

This configuration documentation is for functionality provided by app_skel.

## Configuration File: app_skel.conf

### [globals]: Options that apply globally to app_skel

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [cheat](#cheat)| | | | Should the computer cheat?| |
| games| | | | The number of games a single execution of SkelGuessNumber will play| |


#### Configuration Option Descriptions

##### cheat

If enabled, the computer will ignore winning guesses.<br>


### [sounds]: Prompts for SkelGuessNumber to play

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| lose| | vm-goodbye| | The sound file to play when a player loses| |
| prompt| | please-enter-yournumberqueue-less-than| | A prompt directing the user to enter a number less than the max number| |
| right_guess| | auth-thankyou| | The sound file to play when a correct guess is made| |
| too_high| | | | The sound file to play when a guess is too high| |
| too_low| | | | The sound file to play when a guess is too low| |
| wrong_guess| | vm-pls-try-again| | The sound file to play when a wrong guess is made| |


### [level]: Defined levels for the SkelGuessNumber game

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| max_guesses| | | | The maximum number of guesses before a game is considered lost| |
| max_number| | | | The maximum in the range of numbers to guess (1 is the implied minimum)| |



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 