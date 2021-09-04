"
BEROctetString is a string encoded in BER.
"
Class {
	#name : #BEROctetString,
	#superclass : #BERElement,
	#instVars : [
		'string'
	],
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : #encoding }
BEROctetString >> decode: aStream length: aLength [
	string := (aStream next: aLength) asByteArray
]

{ #category : #accessing }
BEROctetString >> length [ 
	^ string size
]

{ #category : #accessing }
BEROctetString >> value [ 
	^ string ifNil: [ String new ] ifNotNil: [ :s | s utf8Decoded ]
]

{ #category : #accessing }
BEROctetString >> value: anObject [
	"Value is stored as an UTF-8 encoded byte array"
	string := anObject asString utf8Encoded
]

{ #category : #writing }
BEROctetString >> writeBodyOn: aStream [
	aStream nextPutAll: string asString.

]
