"
A worker (thread)
"
Class {
	#name : #LDAPWorker,
	#superclass : #Object,
	#instVars : [
		'sockStream',
		'hostname',
		'port',
		'nextMessageId',
		'lock',
		'targets',
		'running'
	],
	#category : #'LDAP-Core'
}

{ #category : #'instance creation' }
LDAPWorker class >> newTo: aHostname port: aPort [
	^ self basicNew initialize: aHostname port: aPort
]

{ #category : #accessing }
LDAPWorker >> addTarget: aRequest for: aMessageId [
	lock critical: [
		| data |
		targets at: aMessageId ifPresent: [
			Error new;
				messageText: 'messageId already present -- shouldnt happen'; 
				signal.
		].
		data := Dictionary new.
		data	at: #request put: aRequest.
		targets at: aMessageId put: data.
	]
]

{ #category : #connecting }
LDAPWorker >> connect [
	[ sockStream := SocketStream openConnectionToHostNamed: hostname port: port ]
		on: Exception do: [:ex | sockStream := nil. self error: ex messageText].
	sockStream 
		binary;
		autoFlush: false;
		noTimeout

]

{ #category : #accessing }
LDAPWorker >> delTargetFor: aMessageId [
	lock critical: [
		targets at: aMessageId
			ifAbsent: [ ^ self ].
		 targets removeKey: aMessageId
	
	]
]

{ #category : #connecting }
LDAPWorker >> disconnect [
	self stop
	
]

{ #category : #dispatching }
LDAPWorker >> dispatchMessage: aMessage [
	| target id who |
	id := aMessage id.

	"this is an unsolicited notification -- as it is advisory, we can ignore it for now"
	id = 0 ifTrue: [ ^ self ].

	"RFC says we MUST be prepared to recieve replies to aborted requests -- so we eat it silently"
	target :=targets at: id
		ifAbsent: [ ^ self ].
	
	target ifNil: [ self delTargetFor: id. ^ self ].
	
	"extended results need some kind of handling -- RFC2251 says they are the result of a message with a control,
	which we don't have implemented, so there's no real need yet"
	
	who := target at: #request.
	who processResponse: aMessage response.
	
	who wantsMoreResponses
		ifFalse: [ self delTargetFor: id ]


]

{ #category : #initialization }
LDAPWorker >> initialize: aHostname port: aPort [
	hostname := aHostname.
	port := aPort.
	nextMessageId := 0.
	lock := Semaphore forMutualExclusion.
	"looks like if we use the WVD here we wont see exceptions thrown.. hrmmm"
	"targets := WeakValueDictionary new."
	targets := Dictionary new.
	running := false.
]

{ #category : #accessing }
LDAPWorker >> nextMessageId [
	"here we should check wether we're past the message id limit, and if so reconnect and bind"
	nextMessageId := nextMessageId + 1.
	^ nextMessageId
]

{ #category : #accessing }
LDAPWorker >> running [
	^ running
]

{ #category : #accessing }
LDAPWorker >> running: aBoolean [
	running := aBoolean
]

{ #category : #accessing }
LDAPWorker >> send: someData [
	lock critical: [
		sockStream 
			nextPutAll: someData;
			flush.
	]
]

{ #category : #running }
LDAPWorker >> start [
	| process |
	running := true.
	process := [ 
		[running] whileTrue: [
			|  element  |
			element := [LDAPMessage newFrom: sockStream] on: Error do:[:ex| 
				Transcript cr; show: ex description.
				running := false].
			"Transcript show: '********* READ ONE OF:  ', element asString; cr."
			running ifTrue:[self dispatchMessage: element].
		]
	] fork.
	^ process
	
]

{ #category : #running }
LDAPWorker >> stop [
	running := false.
]
