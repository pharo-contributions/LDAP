Class {
	#name : #LDAPAddRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPAddRequest >> initializeWith: anLDAPWorker dn: aDN attrs: someAttrs [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder addRequest: messageId dn: aDN attrs: someAttrs).

]
