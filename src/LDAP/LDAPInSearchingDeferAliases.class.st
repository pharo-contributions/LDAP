"
The server should dereference any aliases that it encounters within the scope of the search, except for the base entry itself.
"
Class {
	#name : #LDAPInSearchingDeferAliases,
	#superclass : #LDAPSearchDerefAliases,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPInSearchingDeferAliases >> initialize [ 
	super initialize.
	value := 1. "in searching"
]

{ #category : #accessing }
LDAPInSearchingDeferAliases >> name [
	^ 'derefInSearching'
]

{ #category : #accessing }
LDAPInSearchingDeferAliases >> value: anInteger [
	^ self shouldNotImplement 
]
