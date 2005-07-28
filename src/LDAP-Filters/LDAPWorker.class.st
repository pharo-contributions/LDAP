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
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPWorker class >> newTo: aHostname port: aPort [
	^ self basicNew initialize: aHostname port: aPort
]

{ #category : #'as yet unclassified' }
LDAPWorker >> addTarget: aRequest for: aMessageId [
	lock critical: [
		| data |
		targets at: aMessageId ifPresent: [
			Error new;
				messageText: 'messageId already present -- shouldnt happen'; 
				signal.
		].
		data _ Dictionary new.
		data	at: #request put: aRequest.
		targets at: aMessageId put: data.
	]
]

{ #category : #'as yet unclassified' }
LDAPWorker >> connect [
	[ sockStream _ SocketStream openConnectionToHostNamed: hostname port: port ]
		on: Exception do: [:ex | sockStream _ nil. self error: ex messageText].
	sockStream 
		binary;
		autoFlush: false;
		noTimeout

]

{ #category : #'as yet unclassified' }
LDAPWorker >> delTargetFor: aMessageId [
	lock critical: [
		targets at: aMessageId
			ifAbsent: [ ^ self ].
		 targets removeKey: aMessageId
	
	]
]

{ #category : #'as yet unclassified' }
LDAPWorker >> disconnect [
	self stop
	
]

{ #category : #'as yet unclassified' }
LDAPWorker >> dispatchMessage: aMessage [
	| target id who |
	id _ aMessage id.

	"this is an unsolicited notification -- as it is advisory, we can ignore it for now"
	id = 0 ifTrue: [ ^ self ].

	"RFC says we MUST be prepared to recieve replies to aborted requests -- so we eat it silently"
	target _targets at: id
		ifAbsent: [ ^ self ].
	
	target ifNil: [ self delTargetFor: id. ^ self ].
	
	"extended results need some kind of handling -- RFC2251 says they are the result of a message with a control,
	which we don't have implemented, so there's no real need yet"
	
	who _ target at: #request.
	who processResponse: aMessage.
	
	who wantsMoreResponses
		ifFalse: [ self delTargetFor: id ]


]

{ #category : #'as yet unclassified' }
LDAPWorker >> initialize: aHostname port: aPort [
	hostname _ aHostname.
	port _ aPort.
	nextMessageId _ 0.
	lock _ Semaphore forMutualExclusion.
	"looks like if we use the WVD here we wont see exceptions thrown.. hrmmm"
	"targets _ WeakValueDictionary new."
	targets _ Dictionary new.
	running _ false.
]

{ #category : #'as yet unclassified' }
LDAPWorker >> nextMessageId [
	"here we should check wether we're past the message id limit, and if so reconnect and bind"
	nextMessageId _ nextMessageId + 1.
	^ nextMessageId
]

{ #category : #'as yet unclassified' }
LDAPWorker >> running [
	^ running
]

{ #category : #'as yet unclassified' }
LDAPWorker >> running: aBoolean [
	running _ aBoolean
]

{ #category : #'as yet unclassified' }
LDAPWorker >> send: someData [
	lock critical: [
		sockStream 
			nextPutAll: someData;
			flush.
	]
]

{ #category : #'as yet unclassified' }
LDAPWorker >> start [
	| process |
	running _ true.
	process _ [ 
		[running] whileTrue: [
			|  element  |
			element _ LDAPMessage newFrom: sockStream.
			Transcript show: '********* READ ONE OF:  ', element asString; cr.
			self dispatchMessage: element.
		]
	] fork.
	^ process
	
]

{ #category : #'as yet unclassified' }
LDAPWorker >> stop [
	running _ false.
]
