
# LDAP Support for Pharo

Port to Pharo 9.0. Migrated from the original repository at http://smalltalkhub.com/PharoExtras/LDAP/

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
| conn bind req |
conn := (LDAPConnection to: 'ldap.domain.org' port: 389).
bind := LDAPBindRequest new username: 'cn=admin,dc=domain,dc=org'; password: 'password'.
req := conn request: bind.
req wait.
```

### Establish a connection to the LDAP server with SSL
```Smalltalk
| conn bind req |
[ conn := (LDAPSConnection to: 'sldap123.someuri.org' port: 686 ssl: true).
	bind := LDAPBindRequest new username: 'uid=myuid,ou=people,o=someuri,c=org'; password: 'password'.
	req := conn request: bind.
	req wait.
	conn isValid ] on: Error do: [ 1 halt ]
```


### Create new entry
```Smalltalk
| attrs add req |
attrs := Dictionary new
    at: 'objectClass' put: (OrderedCollection new add: 'inetOrgPerson'; yourself);
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@domain.org';
    yourself.

add := LDAPAddRequest new dn: 'cn=jdoe,cn=base'; attrs: attrs.
req := conn request: add.
req wait.
```

### Change the value of an attribute
```Smalltalk
| ops mod req |
ops := { LDAPAttrModifier set: 'sn' to: { 'Doe' } }.
mod := LDAPModifyRequest new dn: 'uid=jdoe,ou=people,dc=domain,dc=org'; ops: ops.
req := conn request: mod.
req wait.
```

### Add an attribute
```Smalltalk
| ops mod req |
ops := { LDAPAttrModifier addTo: 'loginShell' values: { '/bin/bash' } }.
mod := LDAPModifyRequest new dn: 'uid=jdoe,ou=people,dc=domain,dc=org'; ops: ops.
req := conn request: mod.
req wait.
```

### Read all entries
```Smalltalk
| req search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=domain,dc=org'; 
	scope: LDAPSearchScope wholeSubtree; 
	derefAliases: LDAPSearchDerefAliases never.
req := conn request: search.
req wait.
resultEntries := req result. "Returns a collection of LDAPSearchResultEntry instances"
```

### Select entries with filters
```Smalltalk
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
| req search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=domain,dc=org'; 
	scope: LDAPSearchScope wholeSubtree; 
	derefAliases: LDAPSearchDerefAliases never;
	filter: ((LDAPFilter with: 'cn' equalTo: 'Jos') not &
			(LDAPFilter with: 'sn' equalTo: 'Doe')).
req := conn request: search.
req wait.
resultEntries := req result.
```

### Delete an entry
```Smalltalk
| req del |
del := LDAPDelRequest new dn: 'uid=doe,ou=people,dc=domain,dc=org'.
req := conn request: del.
req wait.
```

### Disconnect the client
```Smalltalk
conn disconnect
```
