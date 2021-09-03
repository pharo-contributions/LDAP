"
BEROctetString is a string encoded in BER.
"
Class {
	#name : #BEROctetString,
	#superclass : #BERPrimitive,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : #encoding }
BEROctetString >> decode: aStream length: aLength with: aDecoder [
	value := (aStream next: aLength) asByteArray
]

{ #category : #inspecting }
BEROctetString >> inspectionString [
	<inspectorPresentationOrder: -10 title: 'Octet String'>
	
	^ value asString inspectionString 
]

{ #category : #accessing }
BEROctetString >> length [ 
	^ value size
]

{ #category : #accessing }
BEROctetString >> value [ 
	^ value ifNil: [ String new ] ifNotNil: [ :s | s utf8Decoded ]
]

{ #category : #accessing }
BEROctetString >> value: anObject [
	"Value is stored as an UTF-8 encoded byte array"
	value := anObject asString utf8Encoded
]

{ #category : #writing }
BEROctetString >> writeBodyOn: aStream [
	aStream nextPutAll: value asString.

]
