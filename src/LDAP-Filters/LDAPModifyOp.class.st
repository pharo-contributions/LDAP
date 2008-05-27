Class {
	#name : #LDAPModifyOp,
	#superclass : #LDAPRequest,
	#instVars : [
		'attr',
		'values'
	],
	#category : #LDAP
}

{ #category : #'as yet unclassified' }
LDAPModifyOp class >> affecting: anAttr values: someValues [
	| obj |
	obj := self basicNew initializeWithAttr: anAttr values: someValues.
	^ obj
]

{ #category : #'as yet unclassified' }
LDAPModifyOp class >> tagValue [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
LDAPModifyOp >> asBERElement [
	| ber |
	ber := BERSequence new.
	ber addElement: (BEREnumerated new value: self class tagValue).
	ber addElement: (LDAPEncoder attrAsBERElement: (Association key: attr value: values)).
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPModifyOp >> initializeWithAttr: anAttr values: someValues [
	attr := anAttr.
	values := someValues
]
