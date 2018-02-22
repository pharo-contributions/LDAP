"
BEROctetString is a string encoded in BER.
"
Class {
	#name : #BEROctetString,
	#superclass : #BERElement,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : #encoding }
BEROctetString >> decode: aStream [
	value := (aStream next: length)
]

{ #category : #writing }
BEROctetString >> writeBodyOn: aStream [
	self writeLength: (value size) on: aStream.
	aStream nextPutAll: value.
	"theorically we should convert it to UTF8"
	^ value size
]
