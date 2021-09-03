"
Common superclass for LDAP exceptions
"
Class {
	#name : #LDAPException,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'LDAP-Exceptions'
}

{ #category : #'instance creation' }
LDAPException class >> newWithCode: aResultCode [

	| ex newClass |
	newClass := self.
	(aResultCode between: 16 and: 21) ifTrue: [ 
		newClass := LDAPAttrProblemException ].
	((aResultCode between: 32 and: 36) and: [ aResultCode ~= 35 ]) 
		ifTrue: [ newClass := LDAPNameProblemException ].
	(aResultCode between: 48 and: 50) ifTrue: [ 
		newClass := LDAPSecurityProblemException ].
	(aResultCode between: 51 and: 54) ifTrue: [ 
		newClass := LDAPServiceProblemException ].
	((aResultCode between: 64 and: 69) or: [ aResultCode = 71 ]) ifTrue: [ 
		newClass := LDAPUpdateProblemException ].

	ex := newClass new initializeWithCode: aResultCode.
	^ ex
]

{ #category : #initialization }
LDAPException >> initializeWithCode: aResultCode [
	| message |
	resultCode := aResultCode.
	message := String streamContents: [ :s | s << 'LDAP: ' << (LDAPResultCode stringFor: resultCode) ].
	self messageText: message.
]
