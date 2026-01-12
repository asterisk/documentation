---
search:
  boost: 0.5
title: FILE
---

# FILE()

### Synopsis

Read or write text file.

### Description

Read and write text file in character and line mode.<br>

Examples:<br>

<br>

Read mode (byte):<br>

;reads the entire content of the file.<br>

Set(foo=$\{FILE(/tmp/test.txt)\})<br>

;reads from the 11th byte to the end of the file (i.e. skips the first 10).<br>

Set(foo=$\{FILE(/tmp/test.txt,10)\})<br>

;reads from the 11th to 20th byte in the file (i.e. skip the first 10, then read 10 bytes).<br>

Set(foo=$\{FILE(/tmp/test.txt,10,10)\})<br>

<br>

Read mode (line):<br>

; reads the 3rd line of the file.<br>

Set(foo=$\{FILE(/tmp/test.txt,3,1,l)\})<br>

; reads the 3rd and 4th lines of the file.<br>

Set(foo=$\{FILE(/tmp/test.txt,3,2,l)\})<br>

; reads from the third line to the end of the file.<br>

Set(foo=$\{FILE(/tmp/test.txt,3,,l)\})<br>

; reads the last three lines of the file.<br>

Set(foo=$\{FILE(/tmp/test.txt,-3,,l)\})<br>

; reads the 3rd line of a DOS-formatted file.<br>

Set(foo=$\{FILE(/tmp/test.txt,3,1,l,d)\})<br>

<br>

Write mode (byte):<br>

; truncate the file and write "bar"<br>

Set(FILE(/tmp/test.txt)=bar)<br>

; Append "bar"<br>

Set(FILE(/tmp/test.txt,,,a)=bar)<br>

; Replace the first byte with "bar" (replaces 1 character with 3)<br>

Set(FILE(/tmp/test.txt,0,1)=bar)<br>

; Replace 10 bytes beginning at the 21st byte of the file with "bar"<br>

Set(FILE(/tmp/test.txt,20,10)=bar)<br>

; Replace all bytes from the 21st with "bar"<br>

Set(FILE(/tmp/test.txt,20)=bar)<br>

; Insert "bar" after the 4th character<br>

Set(FILE(/tmp/test.txt,4,0)=bar)<br>

<br>

Write mode (line):<br>

; Replace the first line of the file with "bar"<br>

Set(FILE(/tmp/foo.txt,0,1,l)=bar)<br>

; Replace the last line of the file with "bar"<br>

Set(FILE(/tmp/foo.txt,-1,,l)=bar)<br>

; Append "bar" to the file with a newline<br>

Set(FILE(/tmp/foo.txt,,,al)=bar)<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

FILE(filename,offset,length,options,format)
```
##### Arguments


* `filename`

* `offset` - Maybe specified as any number. If negative, _offset_ specifies the number of bytes back from the end of the file.<br>

* `length` - If specified, will limit the length of the data read to that size. If negative, trims _length_ bytes from the end of the file.<br>

* `options`

    * `l` - Line mode: offset and length are assumed to be measured in lines, instead of byte offsets.<br>


    * `a` - In write mode only, the append option is used to append to the end of the file, instead of overwriting the existing file.<br>


    * `d` - In write mode and line mode only, this option does not automatically append a newline string to the end of a value. This is useful for deleting lines, instead of setting them to blank.<br>


* `format` - The _format_ parameter may be used to delimit the type of line terminators in line mode.<br>

    * `u` - Unix newline format.<br>


    * `d` - DOS newline format.<br>


    * `m` - Macintosh newline format.<br>


### See Also

* [Dialplan Functions FILE_COUNT_LINE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/FILE_COUNT_LINE)
* [Dialplan Functions FILE_FORMAT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/FILE_FORMAT)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 