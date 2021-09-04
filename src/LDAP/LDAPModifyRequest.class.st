"
A request to modify
"
Class {
	#name : #LDAPModifyRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #initialization }
LDAPModifyRequest >> initializeWith: anLDAPWorker dn: aDN ops: someModifyingOps [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder modifyRequest: messageId dn: aDN ops: someModifyingOps).

]
