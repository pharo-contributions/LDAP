"
LDAPRequest is an operation request that the LDAP server must execute.
"
Class {
	#name : #LDAPRequest,
	#superclass : #Object,
	#instVars : [
		'worker',
		'messageId',
		'isDone',
		'abandoned',
		'doneSemaphore',
		'iterator',
		'query',
		'responses',
		'newResponseSemaphore'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPRequest >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	abandoned ifNotNil: [ ^ abandoned ].

	abandoned := LDAPRequest new initializeWith: worker request: (LDAPAbandonRequest new abandonId: messageId).
	worker delTargetFor: messageId.
	
	^ abandoned
	
]

{ #category : #'error handing' }
LDAPRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	responses do: #checkForExceptions.
]

{ #category : #defaults }
LDAPRequest >> defaultTimeout [
	"Answer the default timout for LDAP queries"
	^30 "seconds"
]

{ #category : #testing }
LDAPRequest >> hasResult [
	^ isDone
]

{ #category : #initialization }
LDAPRequest >> initializeWith: anLDAPWorker request: aRequest [
	| message |
	worker := anLDAPWorker.
	messageId := worker nextMessageId.
	doneSemaphore := Semaphore new.
	query := aRequest.
	responses := OrderedCollection new.
	abandoned := nil.
	isDone := false.
	
	"partial search results"
	newResponseSemaphore := Semaphore new.
	iterator := 0.

	worker addTarget: self for: messageId.
	message := LDAPMessage new id: messageId; operation: aRequest.
	worker send: message encoded.

]

{ #category : #testing }
LDAPRequest >> isDone [
	^ isDone
]

{ #category : #accessing }
LDAPRequest >> next [
	^ self nextTimeout: self defaultTimeout.


]

{ #category : #accessing }
LDAPRequest >> nextTimeout: seconds [
	isDone ifFalse:[
		"As long as the request isn't done, synchronously wait for more results"
		newResponseSemaphore waitTimeoutSeconds: seconds.
		(responses size = iterator and:[isDone not]) ifTrue:[^self error: 'LDAP timeout'].
	].
	^ responses size > iterator
		ifTrue:[ responses at: (iterator := iterator + 1)]
		ifFalse:[ nil ]
]

{ #category : #accessing }
LDAPRequest >> processResponse: aMessage [
	responses addLast: aMessage. 
	aMessage isEndMarker ifTrue:[
		isDone := true. 
		doneSemaphore signal.
	].
	newResponseSemaphore signal.

]

{ #category : #accessing }
LDAPRequest >> responses [ 
	self wait.
	^ responses
]

{ #category : #accessing }
LDAPRequest >> result [
	self wait.
	^ query processResult: responses
]

{ #category : #accessing }
LDAPRequest >> wait [
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : #accessing }
LDAPRequest >> waitTimeoutMSecs: msecs [
	responses ifEmpty: [ doneSemaphore waitTimeoutMSecs: msecs ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> waitTimeoutSeconds: seconds [
	responses ifEmpty: [ doneSemaphore waitTimeoutSeconds: seconds ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
