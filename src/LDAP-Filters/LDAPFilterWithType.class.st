Class {
	#name : #LDAPFilterWithType,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'type'
	],
	#category : 'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterWithType >> asBERElement [
	| ber |
	ber _ BEROctetString new value: type.
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPFilterWithType >> setType: anAttrType [
	type _ anAttrType
	
]
