"
A request to compare
"
Class {
	#name : #LDAPCompareRequest,
	#superclass : #BERSequence,
	#instVars : [
		'searchResult'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPCompareRequest class >> tagValue [
	^ 16r6E "Application 14"
]

{ #category : #accessing }
LDAPCompareRequest >> comparing: aFilter [
	elements at: 2 put: aFilter asBERElement
]

{ #category : #accessing }
LDAPCompareRequest >> dn: aString [
	elements first value: aString
]

{ #category : #initialization }
LDAPCompareRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new). "entry"
	self addElement: (LDAPFilterEquality new asBERElement). "AttributeValueAssertion"

]
