Class {
	#name : #LDAPRequest,
	#superclass : #Object,
	#instVars : [
		'worker',
		'messageId',
		'waitingSemaphore',
		'isDone',
		'result',
		'isAbandoned'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPRequest >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	isAbandoned ifFalse: [
		LDAPAbandonRequest new initializeWith: worker abandonId: messageId.
		worker delTargetFor: messageId.
		isAbandoned := true ]
	
]

{ #category : #'as yet unclassified' }
LDAPRequest >> hasResult [
	^ isDone
]

{ #category : #'as yet unclassified' }
LDAPRequest >> initializeWith: anLDAPWorker [
	worker := anLDAPWorker.
	messageId := worker nextMessageId.
	waitingSemaphore := Semaphore new.
	isAbandoned := false.
	isDone := false.

	worker addTarget: self for: messageId.

	
]

{ #category : #'as yet unclassified' }
LDAPRequest >> isDone [
	^ isDone
]

{ #category : #'as yet unclassified' }
LDAPRequest >> processResponse: aMessage [
	isDone := true. 
	result := aMessage.
	waitingSemaphore signal.
]

{ #category : #'as yet unclassified' }
LDAPRequest >> result [
	self wait.
	^ result
]

{ #category : #'as yet unclassified' }
LDAPRequest >> wait [
	result ifNil: [
		waitingSemaphore wait ]
]

{ #category : #'as yet unclassified' }
LDAPRequest >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
