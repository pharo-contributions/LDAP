"
Common superclass for modifying operations
"
Class {
	#name : #LDAPModifyOp,
	#superclass : #BERSequence,
	#instVars : [
		'attr',
		'values'
	],
	#category : #'LDAP-Core'
}

{ #category : #'private - instance creation' }
LDAPModifyOp class >> affecting: anAttr values: someValues [
	| obj |
	obj := self basicNew initializeWithAttr: anAttr values: someValues.
	^ obj
]

{ #category : #accessing }
LDAPModifyOp class >> tagValue [
	^ self subclassResponsibility
]

{ #category : #conversion }
LDAPModifyOp >> asBERElement [
	| ber |
	ber := BERSequence new.
	ber addElement: (BEREnumerated new value: self class tagValue).
	ber addElement: (LDAPEncoder attributeDescription: attr andValues: values).
	^ ber
]

{ #category : #initialization }
LDAPModifyOp >> initializeWithAttr: anAttr values: someValues [
	attr := anAttr.
	values := someValues
]

{ #category : #printing }
LDAPModifyOp >> printOn: aStream [
	aStream nextPutAll: self class name, '(', attr, ': ', values asArray, ')'. 
]
