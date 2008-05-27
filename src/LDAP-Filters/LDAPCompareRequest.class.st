Class {
	#name : #LDAPCompareRequest,
	#superclass : #LDAPRequest,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPCompareRequest >> initializeWith: anLDAPWorker dn: aDN comparing: anEqualityFilter [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder compareRequest: messageId dn: aDN comparing: anEqualityFilter).

]

{ #category : #'as yet unclassified' }
LDAPCompareRequest >> processResponse: aMessage [
	aMessage resultCode = 5 ifTrue: [ result := false ].
	aMessage resultCode = 6 ifTrue: [ result := true ].
	"we save nil for execptions"
	waitingSemaphore signal.
]
