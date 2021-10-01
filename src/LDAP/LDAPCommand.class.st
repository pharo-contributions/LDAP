"
LDAPCommand is an asynchronous command.

It contains a request that the LDAP server must execute.
"
Class {
	#name : #LDAPCommand,
	#superclass : #Object,
	#instVars : [
		'connection',
		'message',
		'isDone',
		'abandoned',
		'doneSemaphore',
		'iterator',
		'responses',
		'newResponseSemaphore'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPCommand >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	abandoned ifNotNil: [ ^ abandoned ].

	abandoned := connection abandon: message.
	^ abandoned
	
]

{ #category : #'error handing' }
LDAPCommand >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	responses do: #checkForExceptions.
]

{ #category : #defaults }
LDAPCommand >> defaultTimeout [
	"Answer the default timout for LDAP queries"
	^30 "seconds"
]

{ #category : #testing }
LDAPCommand >> hasResult [
	^ isDone
]

{ #category : #initialization }
LDAPCommand >> initializeWith: aConnection message: aMessage [
	connection := aConnection.
	message := aMessage.

	doneSemaphore := Semaphore new.
	responses := OrderedCollection new.
	abandoned := nil.
	isDone := false.
	
	"partial search results"
	newResponseSemaphore := Semaphore new.
	iterator := 0.
]

{ #category : #testing }
LDAPCommand >> isDone [
	^ isDone
]

{ #category : #accessing }
LDAPCommand >> next [
	^ self nextTimeout: self defaultTimeout.


]

{ #category : #accessing }
LDAPCommand >> nextTimeout: seconds [
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
LDAPCommand >> processResponse: aResponse [
	responses addLast: aResponse. 
	newResponseSemaphore signal.

	aResponse isEndMarker ifFalse: [ ^ self ].
	
	isDone := true. 
	doneSemaphore signal.

]

{ #category : #accessing }
LDAPCommand >> responses [ 
	self wait.
	^ responses
]

{ #category : #accessing }
LDAPCommand >> result [
	^ message operation processResult: self responses
]

{ #category : #accessing }
LDAPCommand >> wait [
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : #accessing }
LDAPCommand >> waitTimeoutMSecs: msecs [
	responses ifEmpty: [ doneSemaphore waitTimeoutMSecs: msecs ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPCommand >> waitTimeoutSeconds: seconds [
	responses ifEmpty: [ doneSemaphore waitTimeoutSeconds: seconds ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPCommand >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
