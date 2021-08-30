"
Result of an LDAP message.
"
Class {
	#name : #LDAPResult,
	#superclass : #LDAPAbstractResult,
	#category : #'LDAP-Results'
}

{ #category : #accessing }
LDAPResult class >> tagValue [
	self subclassResponsibility
]

{ #category : #'error handling' }
LDAPResult >> checkForExceptions [
	| code ex |
	code := self resultCode.	
	(#( 0 5 6 ) includes: code) ifTrue: [ ^ self ].

	ex := LDAPException newWithCode: code.
	ex signal: (self errorMessage ifEmpty:[ex messageText ]).
]

{ #category : #accessing }
LDAPResult >> errorMessage [
	^ elements third value
]

{ #category : #testing }
LDAPResult >> isEndMarker [
	^ true
]

{ #category : #accessing }
LDAPResult >> matchedDN [
	^ elements second value
]

{ #category : #accessing }
LDAPResult >> referral [
	^ elements fourth
]

{ #category : #accessing }
LDAPResult >> resultCode [
	^ elements first value
]
