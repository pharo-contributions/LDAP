"
Result for compare
"
Class {
	#name : #LDAPCompareResult,
	#superclass : #LDAPResult,
	#category : #'LDAP-Results'
}

{ #category : #accessing }
LDAPCompareResult class >> tagValue [
	^ 16r6F
	
]

{ #category : #'error handling' }
LDAPCompareResult >> checkForExceptions [
	| code |
	code := self resultCode.	
	(#( 0 5 6 ) includes: code) ifTrue: [ ^ self ].

	^ super checkForExceptions
]

{ #category : #testing }
LDAPCompareResult >> processResult [
	self resultCode = 5 ifTrue: [ ^ false ].
	self resultCode = 6 ifTrue: [ ^ true ].
	"we save nil for execptions"
	^ nil

]
