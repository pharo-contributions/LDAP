Class {
	#name : #BEROctetString,
	#superclass : #BERElement,
	#category : 'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : #'as yet unclassified' }
BEROctetString >> decode: aStream [
	value _ (aStream next: length)
]

{ #category : #'as yet unclassified' }
BEROctetString >> writeBodyOn: aStream [
	self writeLength: (value size) on: aStream.
	aStream nextPutAll: value.
	"theorically we should convert it to UTF8"
	^ value size
]
