---
title: Directory Application
pageid: 4817389
---

The next application we'll cover is named **Directory()**, because it presents the callers with a dial-by-name directory. It asks the caller to enter the first few digits of the person's name, and then attempts to find matching names in the specified voice mail context in **voicemail.conf**. If the matching mailboxes have a recorded name greeting, Asterisk will play that greeting. Otherwise, Asterisk will spell out the person's name letter by letter.




---

  
  


```

javascriptDirectory([voicemail\_context,[dialplan\_context,[options]]])


```



---


The **Directory()** application takes three parameters:


#### voicemail\_context


This is the context within **voicemail.conf** in which to search for a matching directory entry. If not specified , the **[docs:default]** context will be searched.


#### dialplan\_context


When the caller finds the directory entry they are looking for, Asterisk will dial the extension matching their mailbox in this context.


#### options


A set of options for controlling the dial-by-name directory. Common options include **f** for searching based on first name instead of last name and **e** to read the extension number as well as the name.




---

**Tip: Directory() Options** To see the complete list of options for the Directory() application, type **core show application Directory** at the Asterisk CLI.

  



---


Let's add a dial-by-name directory to our dialplan. Simply add this line to your **[docs:users]** context in **extensions.conf**:




---

  
  


```

javascriptexten => 6501,1,Directory(vm-demo,users,ef)


```



---


Now you should be able to dial extension **6501** to test your dial-by-name directory.

