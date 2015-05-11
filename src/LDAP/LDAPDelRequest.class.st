"
LDAPDelRequest is the process to delete an entry in the LDAP directory.
"
Class {
	#name : #LDAPDelRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPDelRequest >> initializeWith: anLDAPWorker dn: aDN [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder delRequest: messageId dn: aDN).

]
