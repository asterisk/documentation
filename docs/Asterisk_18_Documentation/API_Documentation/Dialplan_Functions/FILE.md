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

Read mode (byte):<br>

``` title="Example: Reads the entire content of the file"

same => n,Set(foo=${FILE(/tmp/test.txt)})


```
``` title="Example: Reads from the 11th byte to the end of the file (i.e. skips the first 10)"

same => n,Set(foo=${FILE(/tmp/test.txt,10)})


```
``` title="Example: Reads from the 11th to 20th byte in the file (i.e. skip the first 10, then read 10 bytes)"

same => n,Set(foo=${FILE(/tmp/test.txt,10,10)})


```
Read mode (line):<br>

``` title="Example: Reads the 3rd line of the file"

same => n,Set(foo=${FILE(/tmp/test.txt,3,1,l)})


```
``` title="Example: Reads the 3rd and 4th lines of the file"

same => n,Set(foo=${FILE(/tmp/test.txt,3,2,l)})


```
``` title="Example: Reads from the third line to the end of the file"

same => n,Set(foo=${FILE(/tmp/test.txt,3,,l)})


```
``` title="Example: Reads the last three lines of the file"

same => n,Set(foo=${FILE(/tmp/test.txt,-3,,l)})


```
``` title="Example: Reads the 3rd line of a DOS-formatted file"

same => n,Set(foo=${FILE(/tmp/test.txt,3,1,l,d)})


```
Write mode (byte):<br>

``` title="Example: Truncate the file and write bar"

same => n,Set(FILE(/tmp/test.txt)=bar)


```
``` title="Example: Append bar"

same => n,Set(FILE(/tmp/test.txt,,,a)=bar)


```
``` title="Example: Replace the first byte with bar (replaces 1 character with 3)"

same => n,Set(FILE(/tmp/test.txt,0,1)=bar)


```
``` title="Example: Replace 10 bytes beginning at the 21st byte of the file with bar"

same => n,Set(FILE(/tmp/test.txt,20,10)=bar)


```
``` title="Example: Replace all bytes from the 21st with bar"

same => n,Set(FILE(/tmp/test.txt,20)=bar)


```
``` title="Example: Insert bar after the 4th character"

same => n,Set(FILE(/tmp/test.txt,4,0)=bar)


```
Write mode (line):<br>

``` title="Example: Replace the first line of the file with bar"

same => n,Set(FILE(/tmp/foo.txt,0,1,l)=bar)


```
``` title="Example: Replace the last line of the file with bar"

same => n,Set(FILE(/tmp/foo.txt,-1,,l)=bar)


```
``` title="Example: Append bar to the file with a newline"

same => n,Set(FILE(/tmp/foo.txt,,,al)=bar)


```

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

* [Dialplan Functions FILE_COUNT_LINE](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/FILE_COUNT_LINE)
* [Dialplan Functions FILE_FORMAT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/FILE_FORMAT)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 