"
Result of an LDAP message.
"
Class {
	#name : #LDAPResult,
	#superclass : #LDAPAbstractResult,
	#classVars : [
		'CodeNames'
	],
	#category : #'LDAP-Results'
}

{ #category : #converting }
LDAPResult class >> codeName: anInteger [
	^ CodeNames at: anInteger ifAbsent: [ 'unknown' ]
]

{ #category : #constants }
LDAPResult class >> errorCodes [
"From RFC 4511 section 4.1.9"
^ #(
	0	'success'
	1	'operationsError'
	2	'protocolError'
	3	'timeLimitExceeded'
	4	'sizeLimitExceeded'
	5	'compareFalse'
	6	'compareTrue'
	7	'authMethodNotSupported'
	8	'strongerAuthRequired'
	10	'referral'
	11	'adminLimitExceeded'
	12	'unavailableCriticalExtension'
	13	'confidentialityRequired'
	14	'saslBindInProgress'
	16	'noSuchAttribute'
	17	'undefinedAttributeType'
	18	'inappropriateMatching'
	19	'constraintViolation'
	20	'attributeOrValueExists'
	21	'invalidAttributeSyntax'
	32	'noSuchObject'
	33	'aliasProblem'
	34	'invalidDNSyntax'
	35	'isLeaf'
	36	'aliasDereferencingProblem'
	48	'inappropriateAuthentication'
	49	'invalidCredentials'
	50	'insufficientAccessRights'
	51	'busy'
	52	'unavailable'
	53	'unwillingToPerform'
	54	'loopDetect'
	64	'namingViolation'
	65	'objectClassViolation'
	66	'notAllowedOnNonLeaf'
	67	'notAllowedOnRDN'
	68	'entryAlreadyExists'
	69	'objectClassModsProhibited'
	70	'CLDLAP'
	71	'affectsMultipleDSAs'
	80	'other'
)
]

{ #category : #'class initialization' }
LDAPResult class >> initialize [ 
"Register error names"

	CodeNames := Dictionary new.
	self errorCodes pairsDo: [ :code :value | CodeNames at: code put: value ].
]

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
