"
Filter with assertions about values
"
Class {
	#name : #LDAPFilterWithValueAssertion,
	#superclass : #BERSequence,
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterWithValueAssertion >> assertionValue [ 
	^ elements second value
]

{ #category : #accessing }
LDAPFilterWithValueAssertion >> assertionValue: aString [
	elements second value: aString
]

{ #category : #accessing }
LDAPFilterWithValueAssertion >> description [ 
	^ elements first value
]

{ #category : #accessing }
LDAPFilterWithValueAssertion >> description: aString [
	elements first value: aString
]

{ #category : #conversion }
LDAPFilterWithValueAssertion >> initialize [ 
	super initialize.

	self
		addElement: (BEROctetString new);
		addElement: (BEROctetString new).

]
