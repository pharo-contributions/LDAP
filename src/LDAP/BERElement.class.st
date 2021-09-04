"
A BERElement is a datatype in the BER encoding (Basic Encoding Rules)
"
Class {
	#name : #BERElement,
	#superclass : #Object,
	#category : #'LDAP-BER'
}

{ #category : #'instance creation' }
BERElement class >> createContextElement: aTagValue at: anIndex [
"Create a BER context element. Override for creating correct context elements."
	LDAPException new messageText: 'invalid tag -- no context elements defined for that class'; signal.
	^ nil

]

{ #category : #testing }
BERElement class >> isApplication [ 
	^ BERDecoder isApplication: self tagValue
]

{ #category : #testing }
BERElement class >> isContext [ 
	^ BERDecoder isContext: self tagValue
]

{ #category : #testing }
BERElement class >> isPrivate [ 
	^ BERDecoder isPrivate: self tagValue
]

{ #category : #testing }
BERElement class >> isUniversal [ 
	^ BERDecoder isUniversal: self tagValue
]

{ #category : #utilities }
BERElement class >> lengthLength: anInteger [
	| octets |
	
	"short definite length"
	anInteger < 128 ifTrue: [ ^ 1 ].
		
	"long definite length"
	octets := anInteger bytesCount.
	
	"number of bytes plus the length in one byte"
	^ octets + 1
]

{ #category : #accessing }
BERElement class >> tagValue [
	self subclassResponsibility
]

{ #category : #writing }
BERElement class >> writeLength: aLength on: aStream [
	| lengthLength octets remainderValue |
	lengthLength := self lengthLength: aLength.
	
	lengthLength == 1 ifTrue: [ aStream nextPut: aLength asCharacter. ^ self ].

	octets := ByteArray new: lengthLength.
	octets at: 1 put: ((lengthLength - 1) bitOr: 16r80).
	remainderValue := aLength.
	lengthLength to: 2 by: -1 do: [ :octetsIndex |
		octets at: octetsIndex  put: (remainderValue bitAnd: 16rFF).
		remainderValue := remainderValue bitShift: -8.
	].

	aStream nextPutAll: octets asString.
]

{ #category : #'instance creation' }
BERElement >> createContextElement: aTagValue at: anIndex with: aDecoder [
"Default implementation. No context class elements exist at this level."
"Calls decoder for universal and application type elements."
	^ aDecoder createElement: aTagValue

]

{ #category : #encoding }
BERElement >> decode: aStream length: anInteger with: aDecoder [
	self subclassResponsibility
]

{ #category : #accessing }
BERElement >> length [
	^ self subclassResponsibility
]

{ #category : #printing }
BERElement >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	self value printOn: aStream.
	aStream nextPutAll: ')'.

]

{ #category : #accessing }
BERElement >> tagValue [ 
	^ self class tagValue
]

{ #category : #accessing }
BERElement >> totalLength [
	| tagLength bodyLength lengthLength |
	tagLength := 1.
	bodyLength := self length.
	lengthLength := self class lengthLength: bodyLength.
	^ tagLength + lengthLength + bodyLength
]

{ #category : #accessing }
BERElement >> value [
	^ self subclassResponsibility
]

{ #category : #writing }
BERElement >> writeBodyOn: aStream [
	self subclassResponsibility
]

{ #category : #writing }
BERElement >> writeOn: aStream [
	aStream nextPut: self tagValue asCharacter.
	self class writeLength: self length on: aStream.
	self writeBodyOn: aStream

]
