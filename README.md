# LDAP Support for Pharo

Port to Pharo 9.0. Migrated from the original repository at http://smalltalkhub.com/PharoExtras/LDAP/

LDAP (Lightweight Directory Access Protocol) is a network protocol for remote directories. LDAP is mainly used for authentication of users into the mails servers, enterprise applications or biometric systems.

This implementation allows Pharo to communicate with LDAP directories. It is fully written in Pharo and does not requires access to native libraries.


## Loading
```
Metacello new
 	baseline: 'LDAP';
 	repository: 'github://{repo}/LDAP/src'; "For example 'github://pharo-contributions/LDAP/src'"
	load.
```


## Example Snippets

### SSL
```
| conn req |
[ conn := (LDAPSConnection to: 'sldap123.someuri.org' port: 686 ssl: true).
	req := conn bindAs: 'uid=myuid,ou=people,o=someuri,c=org' credentials: '123'.
	req wait.
	conn isValid ] on: Error do: [ 1 halt ]
```

### Establish a connection to the LDAP server (no ssl)
```
conn := (LDAPConnection to: 'ldap.domain.org' port: 389).
req := conn bindAs: 'cn=admin,dc=domain,dc=org' credentials: 'password'.
req wait.
```

### Create new entry
```
attrs := Dictionary new
    at: 'objectClass' put: (OrderedCollection new add: 'inetOrgPerson'; yourself);
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@domain.org';
    yourself.

req := conn addEntry: 'jdoe' attrs: attrs.
req wait.
```

### Change the value of an attribute
```
ops := { LDAPAttrModifier set: 'sn' to: { 'Doe' } }.
req := conn modify: 'uid=jdoe,ou=people,dc=domain,dc=org' with: ops.
req wait.
```

### Add an attribute
```
ops := { LDAPAttrModifier addTo: 'loginShell' values: { '/bin/bash' } }.
req := conn modify: 'uid=jdoe,ou=people,dc=domain,dc=org' with: ops.
req wait.
```

### Read all entries
```
req := conn 
    newSearch: 'ou=people,dc=domain,dc=org' 
    scope: (LDAPConnection wholeSubtree) 
    deref: (LDAPConnection derefNever) 
    filter: nil 
    attrs: nil 
    wantAttrsOnly: false.
```

### Select entries with filters
```
req := conn
    newSearch: 'ou=people,dc=domain,dc=org'
    scope: LDAPConnection wholeSubtree
    deref: LDAPConnection derefNever
    filter: (LDAPFilter andOf: (OrderedCollection new 
            add: (LDAPFilter with: 'sn' equalTo: 'Doe'); 
            yourself))
    attrs: {'sn'}
    wantAttrsOnly: false.
req wait.
```

### Delete an entry
```
req := connection delEntry: 'uid=doe,ou=people,dc=domain,dc=org'.
req wait.
```

### Disconnect the client
```
conn disconnect
```
