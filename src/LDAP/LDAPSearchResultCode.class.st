"
Search result code
"
Class {
	#name : #LDAPSearchResultCode,
	#superclass : #LDAPResult,
	#category : #'LDAP-Results'
}

{ #category : #accessing }
LDAPSearchResultCode class >> tagValue [
	^ 16r65
]

{ #category : #'error handling' }
LDAPSearchResultCode >> checkForExceptions [
	| code |
	code := self resultCode.	
	
	"noSuchObject"
	"Do not raise object not found since it is implicit in the response"
	code = 32 ifTrue: [ ^ self ].

	^ super checkForExceptions.

]
