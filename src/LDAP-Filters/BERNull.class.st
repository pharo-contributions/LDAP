Class {
	#name : #BERNull,
	#superclass : #BERElement,
	#category : #'LDAP-BER'
}

{ #category : #'as yet unclassified' }
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
