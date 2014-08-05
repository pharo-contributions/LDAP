Class {
	#name : #LDAPSWorker,
	#superclass : #LDAPWorker,
	#instVars : [
		'ssl'
	],
	#category : #'LDAP-SSL'
}

{ #category : #'as yet unclassified' }
LDAPSWorker class >> newTo: aHostname port: aPort [
	^ self newTo: aHostname port: aPort ssl: aPort = 636
]

{ #category : #'as yet unclassified' }
LDAPSWorker class >> newTo: aHostname port: aPort ssl: aBoolean [
	^ self basicNew initialize: aHostname port: aPort ssl: aBoolean
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
LDAPSWorker >> initialize: aHostname port: aPort ssl: aBoolean [
	super initialize: aHostname port: aPort.
	ssl := aBoolean
]
