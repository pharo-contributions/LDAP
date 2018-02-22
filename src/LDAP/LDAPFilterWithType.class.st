"
Filter with a type
"
Class {
	#name : #LDAPFilterWithType,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'type'
	],
	#category : #'LDAP-Filters'
}

{ #category : #conversion }
LDAPFilterWithType >> asBERElement [
	| ber |
	ber := BEROctetString new value: type.
	^ ber
]

{ #category : #accessing }
LDAPFilterWithType >> setType: anAttrType [
	type := anAttrType
	
]
