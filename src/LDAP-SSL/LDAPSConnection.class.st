Class {
	#name : #LDAPSConnection,
	#superclass : #LDAPConnection,
	#category : #'LDAP-SSL'
}

{ #category : #'as yet unclassified' }
LDAPSConnection class >> to: aHostname port: aPort [
	^ self to: aHostname port: aPort ssl: aPort = 636
]

{ #category : #'as yet unclassified' }
LDAPSConnection class >> to: aHostname port: aPort ssl: aBoolean [
	| obj |
	obj := self basicNew initializeWithHost: aHostname port: aPort ssl: aBoolean.
	^ obj
]

{ #category : #'as yet unclassified' }
LDAPSConnection >> initializeWithHost: aHostname port: aPort ssl: aBoolean [
	worker := LDAPSWorker newTo: aHostname port: aPort ssl: aBoolean.
	worker connect.
	workerThread := worker start
]
