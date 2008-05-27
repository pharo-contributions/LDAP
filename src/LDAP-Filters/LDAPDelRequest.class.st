Class {
	#name : #LDAPDelRequest,
	#superclass : #LDAPRequest,
	#category : #LDAP
}

{ #category : #'as yet unclassified' }
LDAPDelRequest >> initializeWith: anLDAPWorker dn: aDN [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder delRequest: messageId dn: aDN).

]
