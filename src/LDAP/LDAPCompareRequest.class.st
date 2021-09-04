"
A request to compare
"
Class {
	#name : #LDAPCompareRequest,
	#superclass : #BERSequence,
	#instVars : [
		'searchResult'
	],
	#category : #'LDAP-Core'
}

{ #category : #'error handling' }
LDAPCompareRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	searchResult checkForExceptions.
]

{ #category : #initialization }
LDAPCompareRequest >> initializeWith: anLDAPWorker dn: aDN comparing: anEqualityFilter [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder compareRequest: messageId dn: aDN comparing: anEqualityFilter).

]

{ #category : #accessing }
LDAPCompareRequest >> processResponse: aMessage [
	isDone := true.
	searchResult := aMessage.
	aMessage resultCode = 5 ifTrue: [ result := false ].
	aMessage resultCode = 6 ifTrue: [ result := true ].
	"we save nil for execptions"
	waitingSemaphore signal.
]
