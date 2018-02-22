"
Request to abondon a request
"
Class {
	#name : #LDAPAbandonRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #initialization }
LDAPAbandonRequest >> initializeWith: anLDAPWorker abandonId: anAbandonMessageId [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder abandonRequest: messageId abandonId: anAbandonMessageId).

]
