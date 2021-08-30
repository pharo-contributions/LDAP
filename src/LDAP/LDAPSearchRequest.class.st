"
LDAPSearchRequest is the process to search entries from the LDAP directory.
"
Class {
	#name : #LDAPSearchRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPSearchRequest class >> tagValue [
	^ 16r63 "Application 3"
]

{ #category : #accessing }
LDAPSearchRequest >> attrs: someAttrs [
	| ber |
	ber := BERSequence new.
	someAttrs do: [ :each | ber addElement: (BEROctetString new value: each) ].
	elements at: 8 put: ber.
]

{ #category : #accessing }
LDAPSearchRequest >> base: aDn [
	elements first value: aDn
]

{ #category : #'error handling' }
LDAPSearchRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	searchResult resultCode = 32 ifFalse:[
		"Do not raise object not found since it is implicit in the response"
		searchResult checkForExceptions.
	].
]

{ #category : #accessing }
LDAPSearchRequest >> derefAliases: anEnumeratedValue [
	elements third value: anEnumeratedValue
]

{ #category : #accessing }
LDAPSearchRequest >> filter: aFilter [
	elements at: 7 put: aFilter 
]

{ #category : #initialization }
LDAPSearchRequest >> initialize [ 
	super initialize.
	
	self
		addElement: (BEROctetString new); "dn"
		addElement: (BEREnumerated new); "scope"
		addElement: (BEREnumerated new); "derefAliases"
		addElement: (BERInteger new value: 0); "sizelimit"
		addElement: (BERInteger new value: 0); "timelimit"
		addElement: (BERBoolean new); "typesOnly"
		addElement: (LDAPFilterOr new); "filter. Absolute false filter (|)"
		addElement: (BERSequence new). "attrs"

]

{ #category : #accessing }
LDAPSearchRequest >> next [
	^self nextTimeout: self defaultTimeout.
]

{ #category : #accessing }
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

{ #category : #accessing }
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

{ #category : #accessing }
LDAPSearchRequest >> scope: aScope [
	elements second value: aScope
]

{ #category : #accessing }
LDAPSearchRequest >> sizeLimit: anInteger [
	elements fourth value: anInteger
]

{ #category : #accessing }
LDAPSearchRequest >> timeLimit: anInteger [
	elements fifth value: anInteger
]

{ #category : #accessing }
LDAPSearchRequest >> wantAttrsOnly: aBoolean [
	elements sixth value: aBoolean
]
