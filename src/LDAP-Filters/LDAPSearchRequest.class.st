Class {
	#name : #LDAPSearchRequest,
	#superclass : #LDAPRequest,
	#instVars : [
		'partialResults',
		'iterator',
		'gotNewResultSemaphore',
		'searchResult',
		'resultCount'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	searchResult resultCode = 32 ifFalse:[
		"Do not raise object not found since it is implicit in the response"
		searchResult checkForExceptions.
	].
]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> initializeWith: anLDAPWorker base: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly [
	| encoded |
	partialResults := OrderedCollection new.
	iterator :=  0.
	resultCount := 0.
	gotNewResultSemaphore := Semaphore new.
	self initializeWith: anLDAPWorker.
	encoded := LDAPEncoder searchRequest: messageId  base: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly.
	anLDAPWorker send: encoded.

]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> next [
	^self nextTimeout: self defaultTimeout.
]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> nextTimeout: seconds [
	isDone ifFalse:[
		"As long as the request isn't done, synchronously wait for more results"
		gotNewResultSemaphore waitTimeoutSeconds: seconds.
		(resultCount = iterator and:[isDone not]) ifTrue:[^self error: 'LDAP timeout'].
	].
	resultCount > iterator
		ifTrue:[^partialResults at: (iterator := iterator + 1)]
		ifFalse:[^nil]
]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> processResponse: aSearchResultEntry [
	aSearchResultEntry class isEndMarker ifTrue:[
		searchResult := aSearchResultEntry.
		isDone := true. 
		result := partialResults. 
		waitingSemaphore signal.
	] ifFalse:[
		partialResults addLast: aSearchResultEntry.
		resultCount := resultCount + 1.
	].
	gotNewResultSemaphore signal.

]
