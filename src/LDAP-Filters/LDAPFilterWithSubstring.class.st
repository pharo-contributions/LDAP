Class {
	#name : #LDAPFilterWithSubstring,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'type',
		'choiceTag',
		'substring'
	],
	#category : 'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterWithSubstring >> asBERElement [
	| ber substrSeq |
	ber _ BERSequence new.
	ber addElement: (BEROctetString new value: type).
	
	substrSeq _ BERSequence new.
	substrSeq addElement: (BEROctetString new value: substring) tagSetContext withTag: choiceTag.
	
	ber addElement: substrSeq.
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPFilterWithSubstring >> setSubstring: aSubstring type: anAttrType choiceTag: aChoiceTag [
	substring _ aSubstring.
	type _ anAttrType.
	choiceTag _ aChoiceTag

]
