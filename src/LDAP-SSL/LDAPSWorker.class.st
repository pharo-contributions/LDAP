"
A secure worker (thread)
"
Class {
	#name : #LDAPSWorker,
	#superclass : #LDAPWorker,
	#instVars : [
		'ssl'
	],
	#category : #'LDAP-SSL'
}

{ #category : #'instance creation' }
LDAPSWorker class >> newTo: aHostname port: aPort [
	^ self newTo: aHostname port: aPort ssl: aPort = 636
]

{ #category : #'instance creation' }
LDAPSWorker class >> newTo: aHostname port: aPort ssl: aBoolean [
	^ self basicNew initialize: aHostname port: aPort ssl: aBoolean
]

{ #category : #connecting }
LDAPSWorker >> connect [
	[ 
	sockStream := (ssl
		ifTrue: [ ZdcSecureSocketStream ]
		ifFalse: [ ZdcSocketStream ]) openConnectionToHostNamed: hostname port: port ]
		on: Exception
		do: [ :ex | 
			sockStream := nil.
			self error: ex messageText ].
	sockStream
		binary;
		autoFlush: false;
		timeout: 30.
	ssl
		ifTrue: [ sockStream connect ]
]

{ #category : #initialization }
LDAPSWorker >> initialize: aHostname port: aPort ssl: aBoolean [
	super initialize: aHostname port: aPort.
	ssl := aBoolean
]
