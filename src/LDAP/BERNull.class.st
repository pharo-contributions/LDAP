"
BERNull is a NULL value encoded in BER.
"
Class {
	#name : #BERNull,
	#superclass : #BERElement,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERNull class >> tagValue [
	^ 5
]

{ #category : #'as yet unclassified' }
BERNull >> decode: aStream [
	"not sure about this.. should it be 0?"
	"length := 1."
	value := nil
]

{ #category : #'as yet unclassified' }
BERNull >> writeBodyOn: aStream [
	self writeLength: 0 on: aStream
]
