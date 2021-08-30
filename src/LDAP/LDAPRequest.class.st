"
LDAPRequest is an operation request that the LDAP server must execute.
"
Class {
	#name : #LDAPRequest,
	#superclass : #Object,
	#instVars : [
		'worker',
		'messageId',
		'waitingSemaphore',
		'isDone',
		'abandoned',
		'response'
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
	response checkForExceptions.
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
	worker := anLDAPWorker.
	messageId := worker nextMessageId.
	waitingSemaphore := Semaphore new.
	response := nil.
	abandoned := nil.
	isDone := false.

	worker addTarget: self for: messageId.
	worker send: (LDAPEncoder id: messageId request: aRequest).

]

{ #category : #testing }
LDAPRequest >> isDone [
	^ isDone
]

{ #category : #accessing }
LDAPRequest >> processResponse: aMessage [
	isDone := true. 
	response := aMessage.
	waitingSemaphore signal.
]

{ #category : #accessing }
LDAPRequest >> response [
	self wait.
	^ response
]

{ #category : #accessing }
LDAPRequest >> result [
	self wait.
	^ response ifNotNil: [ response processResult ]
]

{ #category : #accessing }
LDAPRequest >> wait [
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : #accessing }
LDAPRequest >> waitTimeoutMSecs: msecs [
	response ifNil: [ waitingSemaphore waitTimeoutMSecs: msecs ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> waitTimeoutSeconds: seconds [
	response ifNil: [ waitingSemaphore waitTimeoutSeconds: seconds ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
