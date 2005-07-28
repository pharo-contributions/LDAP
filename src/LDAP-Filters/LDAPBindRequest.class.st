Class {
	#name : #LDAPBindRequest,
	#superclass : #LDAPRequest,
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPBindRequest >> initializeWith: anLDAPWorker username: aUsername credentials: aPassword method: anAuthMethod [
	anAuthMethod ifNotNil: [ self notYetImplemented ].
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder bindRequest: messageId username: aUsername credentials: aPassword method: anAuthMethod).

]
