Class {
	#name : #LDAPSearchRequest,
	#superclass : #LDAPRequest,
	#instVars : [
		'partialResults',
		'iterator',
		'gotNewResultSemaphore',
		'searchResult'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'Incomplete request (timeout?)'].
	searchResult resultCode = 32 ifFalse:[
		"Do not raise object not found since it is implicit in the response"
		searchResult checkForExceptions.
	].
]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> hasMoreEntries [
	"Answer true if we have more entries to process, false otherwise.
	Wait if necessary to determine whether more data becomes available."
	[partialResults size = iterator and:[isDone not]] 
		whileTrue:[gotNewResultSemaphore wait].
	isDone ifTrue:[self checkForExceptions].
	^partialResults size > iterator
]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> initializeWith: anLDAPWorker base: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly [
	| encoded |
	partialResults := OrderedCollection new.
	iterator :=  0.
	gotNewResultSemaphore := Semaphore new.
	self initializeWith: anLDAPWorker.
	encoded := LDAPEncoder searchRequest: messageId  base: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly.
	anLDAPWorker send: encoded.

]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> next [
	self hasMoreEntries ifTrue:[
		^(partialResults at: (iterator := iterator + 1)).
	].
	^ nil

]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> processResponse: aSearchResultEntry [
	aSearchResultEntry class isEndMarker
		ifTrue: [ 
			searchResult := aSearchResultEntry.
			isDone := true. 
			result := partialResults. 
			waitingSemaphore signal. ]
		ifFalse: [ partialResults addLast: aSearchResultEntry ].
		
	gotNewResultSemaphore signal
]
