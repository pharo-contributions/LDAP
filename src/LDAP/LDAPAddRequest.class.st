"
LDAPAddRequest is the process to add a new entry in the LDAP directory.

"
Class {
	#name : #LDAPAddRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #initialization }
LDAPAddRequest >> initializeWith: anLDAPWorker dn: aDN attrs: someAttrs [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder addRequest: messageId dn: aDN attrs: someAttrs).

]
