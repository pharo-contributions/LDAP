"
Filter with assertions about values
"
Class {
	#name : #LDAPFilterWithValueAssertion,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'type',
		'value'
	],
	#category : #'LDAP-Filters'
}

{ #category : #conversion }
LDAPFilterWithValueAssertion >> asBERElement [
	| ber |
	ber := BERSequence new.
	ber
		addElement: (BEROctetString new value: type);
		addElement: (BEROctetString new value: value).
	^ ber
]

{ #category : #accessing }
LDAPFilterWithValueAssertion >> setType: anAttrType value: anAttrValue [
	type := anAttrType.
	value := anAttrValue	
]
