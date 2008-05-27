Class {
	#name : #LDAPSearchRequest,
	#superclass : #LDAPRequest,
	#instVars : [
		'partialResults',
		'iterator',
		'gotNewResultSemaphore'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> hasMoreEntries [
	 (self isIteratorAtEnd and: [isDone])
		ifTrue: [ ^ false ].
	partialResults size = iterator
		 ifTrue: [ gotNewResultSemaphore wait ].

	^ ( ( self isIteratorAtEnd and: [isDone]) not ) .
	
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
LDAPSearchRequest >> isIteratorAtEnd [
	^ ((partialResults isNil) or: [partialResults size = iterator])  

]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> next [
	self hasMoreEntries
		ifTrue: [
			iterator := iterator + 1.
			^ (partialResults at: iterator) ].
	^ nil

]

{ #category : #'as yet unclassified' }
LDAPSearchRequest >> processResponse: aSearchResultEntry [
	aSearchResultEntry class isEndMarker
		ifTrue: [ isDone := true. result := partialResults. waitingSemaphore signal. ]
		ifFalse: [ partialResults addLast: aSearchResultEntry ].
		
	gotNewResultSemaphore signal
]
