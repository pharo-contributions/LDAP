"
Result of an LDAP message.
"
Class {
	#name : #LDAPResult,
	#superclass : #BERSequence,
	#instVars : [
		'resultCode',
		'errorMessage',
		'matchedDN',
		'referral'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPResult class >> tagValue [
	self subclassResponsibility
]

{ #category : #'error handling' }
LDAPResult >> checkForExceptions [
	
	(resultCode = 0 or: [ (resultCode = 5) or: [resultCode = 6]])
		ifFalse: [
			| ex |
			ex := LDAPException newWithCode: resultCode.
			ex signal: (errorMessage utf8Decoded ifEmpty:[ex messageText ]) ]
]

{ #category : #encoding }
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

{ #category : #accessing }
LDAPResult >> referral [
	^ referral
]

{ #category : #accessing }
LDAPResult >> referral: aReferral [
	referral := aReferral
]

{ #category : #accessing }
LDAPResult >> resultCode [
	^ resultCode
]
