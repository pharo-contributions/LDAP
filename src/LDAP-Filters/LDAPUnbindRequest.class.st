Class {
	#name : #LDAPUnbindRequest,
	#superclass : #LDAPRequest,
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPUnbindRequest >> initializeWith: anLDAPWorker [ 
	| encoded |
	worker _ anLDAPWorker.
	messageId _ worker nextMessageId.
	encoded _ LDAPEncoder unbindRequest: messageId.
	Transcript show: encoded asHex; cr.
	worker send: encoded.

]
