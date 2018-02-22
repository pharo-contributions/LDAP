"
Filter with a substring
"
Class {
	#name : #LDAPFilterWithSubstring,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'type',
		'choiceTag',
		'substring'
	],
	#category : #'LDAP-Filters'
}

{ #category : #conversion }
LDAPFilterWithSubstring >> asBERElement [
	| ber substrSeq |
	ber := BERSequence new.
	ber addElement: (BEROctetString new value: type).
	
	substrSeq := BERSequence new.
	substrSeq addElement: (BEROctetString new value: substring) tagSetContext withTag: choiceTag.
	
	ber addElement: substrSeq.
	^ ber
]

{ #category : #accessing }
LDAPFilterWithSubstring >> setSubstring: aSubstring type: anAttrType choiceTag: aChoiceTag [
	substring := aSubstring.
	type := anAttrType.
	choiceTag := aChoiceTag

]
