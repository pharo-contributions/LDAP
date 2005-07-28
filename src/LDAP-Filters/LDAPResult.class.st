Class {
	#name : #LDAPResult,
	#superclass : #LDAPMessage,
	#instVars : [
		'resultCode',
		'errorMessage',
		'matchedDN',
		'referral'
	],
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPResult class >> tagValue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
LDAPResult >> checkForExceptions [
	(resultCode = 0 or: [resultCode = 5] or: [resultCode = 6])
		ifFalse: [
			| ex |
			ex _ LDAPException newWithCode: resultCode.
			ex signal: errorMessage ]
]

{ #category : #'as yet unclassified' }
LDAPResult >> decode: aStream [
	| berResultCode berErrorMessage berMatchedDN lengthRemaining |
		
	berResultCode _ BERElement newFrom: aStream.
	berMatchedDN _ BERElement newFrom: aStream.
	berErrorMessage _ BERElement newFrom: aStream.
	
	resultCode _ berResultCode value.
	errorMessage _ berErrorMessage value.
	matchedDN _ berMatchedDN value.

	"actually its not that its not implemented, but that berReferral value is not a string but instead a sequence of them"
	lengthRemaining _ berResultCode totalLength + berMatchedDN totalLength + berErrorMessage totalLength.	
	lengthRemaining - self length ~= 0 ifTrue: [
		| berReferral |
		berReferral _ BERElement newFrom: aStream.
		referral _  berReferral value.
		self notYetImplemented. 
	  ].
	
	self checkForExceptions.

]

{ #category : #'as yet unclassified' }
LDAPResult >> referral [
	^ referral
]

{ #category : #'as yet unclassified' }
LDAPResult >> referral: aReferral [
	referral _ aReferral
]

{ #category : #'as yet unclassified' }
LDAPResult >> resultCode [
	^ resultCode
]
