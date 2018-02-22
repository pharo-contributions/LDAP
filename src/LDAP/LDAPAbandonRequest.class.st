"
Request to abondon a request
"
Class {
	#name : #LDAPAbandonRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPAbandonRequest >> initializeWith: anLDAPWorker abandonId: anAbandonMessageId [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder abandonRequest: messageId abandonId: anAbandonMessageId).

]
