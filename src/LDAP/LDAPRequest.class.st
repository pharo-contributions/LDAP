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
		'result',
		'abandoned'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPRequest >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	isAbandoned ifFalse: [
		LDAPAbandonRequest new initializeWith: worker abandonId: messageId.
		worker delTargetFor: messageId.
		isAbandoned := true ]
	
]

{ #category : #'error handing' }
LDAPRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	result checkForExceptions.
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
	result := aMessage.
	waitingSemaphore signal.
]

{ #category : #accessing }
LDAPRequest >> result [
	self wait.
	^ result
]

{ #category : #accessing }
LDAPRequest >> wait [
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : #accessing }
LDAPRequest >> waitTimeoutMSecs: msecs [
	result ifNil: [ waitingSemaphore waitTimeoutMSecs: msecs ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> waitTimeoutSeconds: seconds [
	result ifNil: [ waitingSemaphore waitTimeoutSeconds: seconds ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
