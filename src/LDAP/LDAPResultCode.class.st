Class {
	#name : #LDAPResultCode,
	#superclass : #BEREnumerated,
	#classVars : [
		'CodeNames'
	],
	#category : #'LDAP-Results'
}

{ #category : #constants }
LDAPResultCode class >> errorCodes [
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
LDAPResultCode class >> initialize [ 
"Register error names"

	CodeNames := Dictionary new.
	self errorCodes pairsDo: [ :code :value | CodeNames at: code put: value ].
]

{ #category : #converting }
LDAPResultCode class >> stringFor: anInteger [
	^ CodeNames at: anInteger ifAbsent: [ 'unknown' ]
]

{ #category : #printing }
LDAPResultCode >> printOn: aStream [
	| code |
	code := self value.
	aStream 
		nextPutAll: (self class stringFor: code);
		nextPutAll: ' ('.
	code printOn: aStream.
	aStream	nextPutAll: ')'.
]
