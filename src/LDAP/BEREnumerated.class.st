"
BEREnumerated is for a choice within a bounded set of possible values
"
Class {
	#name : #BEREnumerated,
	#superclass : #BERInteger,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEREnumerated class >> tagValue [
	^ 10
]

{ #category : #encoding }
BEREnumerated >> decode: aStream [
	super decode: aStream.

]
