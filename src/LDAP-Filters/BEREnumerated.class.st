Class {
	#name : #BEREnumerated,
	#superclass : #BERInteger,
	#category : #'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BEREnumerated class >> tagValue [
	^ 10
]

{ #category : #'as yet unclassified' }
BEREnumerated >> decode: aStream [
	super decode: aStream.

]
