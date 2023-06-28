---
title: LDAP Realtime Driver
pageid: 4260014
---

Asterisk Realtime Lightweight Directory Access Protocol (LDAP) Driver
=====================================================================

With this driver Asterisk, using the [Realtime Database Configuration](/Realtime-Database-Configuration), can access and update information in an LDAP directory. Asterisk can configure SIP/IAX2 users, extensions, queues, queue members, and entire configuration files. This guide assumes you have a working knowledge of LDAP and have an LDAP server with authentication already setup. Asterisk requires read and write permissions to update the directory.

See [configs/res_ldap.conf.sample](https://raw.githubusercontent.com/asterisk/asterisk/master/configs/samples/res_ldap.conf.sample) for a configuration file sample.  
 See contrib/scripts for the LDAP [schema](https://raw.githubusercontent.com/asterisk/asterisk/master/contrib/scripts/asterisk.ldap-schema) and [ldif](https://raw.githubusercontent.com/asterisk/asterisk/master/contrib/scripts/asterisk.ldif) files needed for the LDAP server.




!!! note 
    To use static realtime with certain core configuration files the realtime backend you wish to use must be preloaded in `modules.conf`.

      
[//]: # (end-note)



From within your Asterisk source directory:




---

  
  


```

cd contrib/scripts
sudo cp asterisk.ldap-schema /etc/ldap/schema/
sudo service slapd restart
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ./asterisk.ldif


```


Let's edit the extconfig.conf file to specify LDAP as our realtime storage engine and where Asterisk will look for data.




---

  
  


```

sippeers = ldap,"ou=sip,dc=example,dc=domain",sip
sipusers = ldap,"ou=sip,dc=example,dc=domain",sip
extensions = ldap,"ou=extensions,dc=example,dc=domain",extensions


```




!!! note 
    You'll want to reference the Asterisk res_ldap.conf file which holds the LDAP mapping configuration when building your own record schema.

      
[//]: # (end-note)



**Basic** sip users record layout which will need to be saved to a file (we'll use 'createduser.ldif' here as an example). This example record is for sip user '1000'. This example record is for sip user '1000'.




---

  
  


```

dn: cn=1000,ou=sip,dc=digium,dc=internal
objectClass: AsteriskAccount
objectClass: AsteriskExtension
objectClass: AsteriskSIPUser
objectClass: top
AstAccountName: sip user
cn: 1000
AstAccountDefaultUser: 0
AstAccountExpirationTimestamp: 0
AstAccountFullContact: 0
AstAccountHost: dynamic
AstAccountIPAddress: 0
AstAccountLastQualifyMilliseconds: 0
AstAccountPort: 0
AstAccountRegistrationServer: 0
AstAccountType: 0
AstAccountUserAgent: 0
AstExtension: 1000


```


Let's add the record to the LDAP server:




---

  
  


```

sudo ldapadd -D "cn=admin,dc=example,dc=domain" -x -W -f createduser.ldif


```


When creating your own record schema, you'll obviously want to incorporate authentication. Asterisk + LDAP requires that the user secrets be stored as an MD5 hash. MD5 hashes can be created using 'md5sum'.

For AstAccountRealmedPassword authentication use this.




---

  
  


```

printf "<secret composed of username, realm, and password goes here>" | md5sum


```


For AstMD5secret authentication use this.




---

  
  


```

printf "password" | md5sum


```


