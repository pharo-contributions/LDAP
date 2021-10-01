
# LDAP Support for Pharo

LDAP (Lightweight Directory Access Protocol) is a network protocol for remote directories. LDAP is mainly used for authentication of users into the mails servers, enterprise applications or biometric systems.

This implementation allows Pharo to communicate with such LDAP directories. It is fully written in Pharo and does not require access to native libraries.


## Loading
```Smalltalk
Metacello new
 	baseline: 'LDAP';
 	repository: 'github://{repo}/LDAP/src'; "For example 'github://pharo-contributions/LDAP/src'"
	load.
```
### Loading for Pharo 7 and older
Load the project using the configuration and the *commitish* corresponding to the legacy tag, branch or even SHA as the following:
```Smalltalk
Metacello new
 	configuration: 'LDAP';
	githubUser: 'pharo-contributions' project: 'LDAP' 
		commitish: 'd8f505b34dd2489eb29f61cf85512eb943b35e5a' 
		path: 'src';
	version: #stable;
	load.
```
At this point, no branch or tag exist, so use the most current SHA at that point: [LDAP legacy](https://github.com/pharo-contributions/LDAP/tree/d8f505b34dd2489eb29f61cf85512eb943b35e5a).
See [How to load a git project](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md#how-to-load-a-git-project-using-its-baseline) for more information.

## Example Snippets

### Establish a connection to the LDAP server
```Smalltalk
| connection bind command |
connection := (LDAPConnection to: 'ldap.domain.org' port: 389).
bind := LDAPBindRequest new username: 'cn=admin,dc=domain,dc=org'; password: 'password'.
command := connection request: bind.
command wait.
```

### Establish a connection to the LDAP server with SSL
Use a `LDAPSConnection` instance for the connection.
```Smalltalk
| connection bind command |
[ connection := (LDAPSConnection to: 'sldap123.someuri.org' port: 686).
	bind := LDAPBindRequest new username: 'uid=myuid,ou=people,o=someuri,c=org'; password: 'password'.
	command := connection request: bind.
	command wait.
	connection isValid ] on: Error do: [ 1 halt ]
```


### Create new entry
```Smalltalk
| attrs add command |
attrs := Dictionary new
    at: 'objectClass' put: (OrderedCollection new add: 'inetOrgPerson'; yourself);
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@domain.org';
    yourself.

add := LDAPAddRequest new dn: 'cn=jdoe,cn=base'; attrs: attrs.
command := connection request: add.
command wait.
```

### Change the value of an attribute
```Smalltalk
| ops mod command |
ops := { LDAPAttrModifier set: 'sn' to: { 'Doe' } }.
mod := LDAPModifyRequest new dn: 'uid=jdoe,ou=people,dc=domain,dc=org'; ops: ops.
command := connection request: mod.
command wait.
```

### Add an attribute
```Smalltalk
| ops mod command |
ops := { LDAPAttrModifier addTo: 'loginShell' values: { '/bin/bash' } }.
mod := LDAPModifyRequest new dn: 'uid=jdoe,ou=people,dc=domain,dc=org'; ops: ops.
command := connection request: mod.
command wait.
```

### Read all entries
```Smalltalk
| command search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=domain,dc=org'; 
	scope: LDAPWholeSubtreeScope new; 
	derefAliases: LDAPNeverDeferAliases new.
command := connection request: search.
resultEntries := command result. "Wait and return a collection of LDAPSearchResultEntry instances"
```

### Select entries with filters
```Smalltalk
| command search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=domain,dc=org'; 
	scope: LDAPWholeSubtreeScope new;
	filter: ((LDAPFilter with: 'cn' equalTo: 'Jos') not &
			(LDAPFilter with: 'sn' equalTo: 'Doe')).
command := connection request: search.
resultEntries := command result.
```

### Delete an entry
```Smalltalk
| command del |
del := LDAPDelRequest new dn: 'uid=doe,ou=people,dc=domain,dc=org'.
command := connection request: del.
command wait.
```

### Disconnect the client
```Smalltalk
connection disconnect
```

## History
- Migrated from the original repository at http://smalltalkhub.com/PharoExtras/LDAP/
- Port to Pharo 9.0
- New object model

