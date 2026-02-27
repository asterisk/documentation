# XML Documentation

Since XML documentation is done in the source tree, some of the files can become quite large. Because of this, the XML should be separated from the C files to remove clutter. When submitting a PR that requires documentation, it should be added to its corresponding XML file (or create a new one if one does not already exist). For example, chan_websocket has its own XML file (channels/chan_websocket_doc.xml). These existing files can be referred to when creating your own.

Here are the requirements for the doc file:
* The filename has to have the "\_doc.xml" suffix
* The file must begin with:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE docs SYSTEM "appdocsxml.dtd">
<docs xmlns:xi="http://www.w3.org/2001/XInclude">
```
* To enclose the above, the file must end with:
```xml
</docs>
```
