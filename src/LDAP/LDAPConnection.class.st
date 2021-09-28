"
A LDAPConnection describes the connection of a client to a LDAP server.
"
Class {
	#name : #LDAPConnection,
	#superclass : #Object,
	#instVars : [
		'worker',
		'workerThread'
	],
	#category : #'LDAP-Core'
}

{ #category : #documentation }
LDAPConnection class >> missingRFC2251 [
	self notYetImplemented
	
"The following parts of RFC 2251 have not been implemented:

SOON 
- When Message ID is over the maximum, we should rebind to reset the counter. Although practically it would be enough to just zero the counter when it overflows, since we can reuse the IDs when we have alroady gotten a response
- When rebinding we must terminate all pending operations, as the server will get rid of them; note we will have to notify waiters.
- Distinction between binary attributes (as is <AttributeType>:binary -- do we really need something implemented?
- UTF-8 encoding
- Extended Request
EVENTUALLY
- Controls / Search constraints
- Automatic referral following
- SearchResultReference (Continuation References)
- Filter extensibleMatch and MatchingRuleAssertion
- Would be nice to have a getSchema (by using subschemaSubentry)
WONT
- SASL Bind
"
]

{ #category : #'instance creation' }
LDAPConnection class >> to: aHostname [
	^ self to: aHostname port: 389
]

{ #category : #'instance creation' }
LDAPConnection class >> to: aHostname port: aPort [
	| obj |
	obj := self new initializeWithHost: aHostname port: aPort.
	^ obj
]

{ #category : #accessing }
LDAPConnection class >> workerClass [
	^ LDAPWorker
]

{ #category : #connecting }
LDAPConnection >> disconnect [
	self unbind.
	worker disconnect.
	workerThread terminate
]

{ #category : #initialization }
LDAPConnection >> initializeWithHost: aHostname port: aPort [
	worker := self class workerClass newTo: aHostname port: aPort.
	worker connect.
	workerThread := worker start.

]

{ #category : #testing }
LDAPConnection >> isValid [
	"Answers whether the connection looks still valid"
	^worker running
]

{ #category : #'command execution' }
LDAPConnection >> request: aLDAPCommand [
	^ LDAPRequest new initializeWith: worker request: aLDAPCommand
]

{ #category : #binding }
LDAPConnection >> unbind [
	^ self request: (LDAPUnbindRequest new)
]
