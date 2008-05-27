Class {
	#name : #LDAPUnbindRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPUnbindRequest >> initializeWith: anLDAPWorker [ 
	| encoded |
	worker := anLDAPWorker.
	messageId := worker nextMessageId.
	encoded := LDAPEncoder unbindRequest: messageId.
	"Transcript show: encoded asHex; cr."
	worker send: encoded.

]
