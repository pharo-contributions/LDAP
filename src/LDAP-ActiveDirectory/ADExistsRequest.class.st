"
Request to check the existence of a DN.

```language=Pharo
	| exists |
	exists := ADExistsRequest dn: 'cn=bla,dc=example,dc=com' in: aLDAPConnection.
```

"
Class {
	#name : #ADExistsRequest,
	#superclass : #LDAPSearchRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #testing }
ADExistsRequest class >> dn: dn in: aConnection [
	| search request |
	search := self new dn: dn.
	request := aConnection request: search.
	^ request result notEmpty

]

{ #category : #accessing }
ADExistsRequest >> dn: aString [
	self base: aString.
]

{ #category : #initialization }
ADExistsRequest >> initialize [ 

	super initialize.
	self reset.
]

{ #category : #initialization }
ADExistsRequest >> reset [
	self scope: LDAPWholeSubtreeScope new.
	self derefAliases: LDAPNeverDeferAliases new.
	self filter: (LDAPFilter with: 'objectclass').
]
