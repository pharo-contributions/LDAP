Class {
	#name : #LDAPModifyRequest,
	#superclass : #LDAPRequest,
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPModifyRequest >> initializeWith: anLDAPWorker dn: aDN ops: someModifyingOps [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder modifyRequest: messageId dn: aDN ops: someModifyingOps).

]
