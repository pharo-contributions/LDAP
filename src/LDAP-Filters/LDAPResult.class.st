Class {
	#name : #LDAPResult,
	#superclass : #LDAPMessage,
	#instVars : [
		'resultCode',
		'errorMessage',
		'matchedDN',
		'referral'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPResult class >> tagValue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
LDAPResult >> checkForExceptions [
	
	(resultCode = 0 or: [ (resultCode = 5) or: [resultCode = 6]])
		ifFalse: [
			| ex |
			ex := LDAPException newWithCode: resultCode.
			ex signal: (errorMessage ifEmpty:[ex messageText]) ]
]

{ #category : #'as yet unclassified' }
LDAPResult >> decode: aStream [
	| berResultCode berErrorMessage berMatchedDN lengthRemaining |
		
	berResultCode := BERElement newFrom: aStream.
	berMatchedDN := BERElement newFrom: aStream.
	berErrorMessage := BERElement newFrom: aStream.
	
	resultCode := berResultCode value.
	errorMessage := berErrorMessage value.
	matchedDN := berMatchedDN value.

	"actually its not that its not implemented, but that berReferral value is not a string but instead a sequence of them"
	lengthRemaining := berResultCode totalLength + berMatchedDN totalLength + berErrorMessage totalLength.	
	lengthRemaining - self length ~= 0 ifTrue: [
		| berReferral |
		berReferral := BERElement newFrom: aStream.
		referral :=  berReferral value.
		self notYetImplemented. 
	  ].

"XXXX: Commented out so that we do not raise errors in the response handling of the worker but rather once the response has been passed on to the sender.	
	self checkForExceptions.
"
]

{ #category : #'as yet unclassified' }
LDAPResult >> referral [
	^ referral
]

{ #category : #'as yet unclassified' }
LDAPResult >> referral: aReferral [
	referral := aReferral
]

{ #category : #'as yet unclassified' }
LDAPResult >> resultCode [
	^ resultCode
]
