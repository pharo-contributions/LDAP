"
LDAPAddRequest is the process to add a new entry in the LDAP directory.

"
Class {
	#name : #LDAPAddRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPAddRequest class >> tagValue [
	^ 16r68 "Application 8"
]

{ #category : #accessing }
LDAPAddRequest >> attrs: aDictionary [
	| ber |
	ber := LDAPEncoder attrsAsBERElement: aDictionary.
	elements at: 2 put: ber.
]

{ #category : #accessing }
LDAPAddRequest >> dn: aDn [
	elements first value: aDn
]

{ #category : #initialization }
LDAPAddRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new).
	self addElement: (BERSequence new).

]
