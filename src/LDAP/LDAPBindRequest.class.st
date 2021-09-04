"
LDAPBindRequest is the connection process to the LDAP directory.
"
Class {
	#name : #LDAPBindRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #initialization }
LDAPBindRequest >> initializeWith: anLDAPWorker username: aUsername credentials: aPassword method: anAuthMethod [
	anAuthMethod ifNotNil: [ self notYetImplemented ].
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder bindRequest: messageId username: aUsername credentials: aPassword method: anAuthMethod).

]
