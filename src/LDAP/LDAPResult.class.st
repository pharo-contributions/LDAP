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
	| ex |
	self success ifTrue: [ ^ self ].

	ex := LDAPException newWithCode: self resultCode.
	ex signal: (self errorMessage ifEmpty:[ex messageText ]).
]

{ #category : #'instance creation' }
LDAPResult >> createContextElement: aTagValue at: anIndex with: aDecoder [
"Used for controls"
	(aTagValue = LDAPReferral tagValue) ifTrue: [ ^ LDAPReferral new ].
	(anIndex = 1) ifTrue: [ ^ LDAPResultCode new ].
	
	^ super createContextElement: aTagValue at: anIndex with: aDecoder
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

{ #category : #testing }
LDAPResult >> success [ 
	^ self resultCode isZero 
]
