"
A request to compare
"
Class {
	#name : #LDAPCompareRequest,
	#superclass : #BERSequence,
	#instVars : [
		'searchResult'
	],
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPCompareRequest class >> tagValue [
	^ 16r6E "Application 14"
]

{ #category : #accessing }
LDAPCompareRequest >> comparing: aFilter [
	elements at: 2 put: aFilter
]

{ #category : #accessing }
LDAPCompareRequest >> dn: aString [
	elements first value: aString
]

{ #category : #initialization }
LDAPCompareRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new). "entry"
	self addElement: (LDAPFilterEquality new). "AttributeValueAssertion"

]

{ #category : #testing }
LDAPCompareRequest >> processResult: aCollection [
	| result code |
	result := aCollection last.
	^ result processResult ifNil: [ result checkForExceptions ]

]
