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

{ #category : #'as yet unclassified' }
LDAPFilterWithValueAssertion >> asBERElement [
	| ber |
	ber := BERSequence new.
	ber
		addElement: (BEROctetString new value: type);
		addElement: (BEROctetString new value: value).
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPFilterWithValueAssertion >> setType: anAttrType value: anAttrValue [
	type := anAttrType.
	value := anAttrValue	
]
