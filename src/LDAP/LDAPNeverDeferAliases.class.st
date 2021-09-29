"
The server should not dereference any aliases that it may encounter when processing the search operation.
"
Class {
	#name : #LDAPNeverDeferAliases,
	#superclass : #LDAPSearchDerefAliases,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPNeverDeferAliases >> initialize [ 
	super initialize.
	value := 0. "never"
]

{ #category : #accessing }
LDAPNeverDeferAliases >> name [
	^ 'neverDerefAliases'
]

{ #category : #accessing }
LDAPNeverDeferAliases >> value: anInteger [
	^ self shouldNotImplement 
]
