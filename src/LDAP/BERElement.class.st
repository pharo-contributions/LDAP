"
A BERElement is a datatype in the BER encoding (Basic Encoding Rules)
"
Class {
	#name : #BERElement,
	#superclass : #Object,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERElement class >> elementClasses [
	^ {
		BERInteger. BEROctetString . BERSequence. BEREnumerated. BERBoolean. BERSet. BERNull.

		"this has to go here for now"
		LDAPAddResult. LDAPBindResult. LDAPCompareResult. LDAPDelResult. LDAPExtendedResult.
		LDAPModifyResult. LDAPModifyDNResult. LDAPSearchResultEntry. LDAPSearchResultCode. LDAPSearchResultReference 
	}.
	
]

{ #category : #utilities }
BERElement class >> identifyIncomingElement: firstByte [
	| type |
	"so why are we doing this in a comparision here, instead of asking the class wether it handles the element?"
	type := self elementClasses detect: [ :each | each tagValue = firstByte asInteger ] ifNone: [nil].
	^ type
	
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

{ #category : #'instance creation' }
BERElement class >> newFrom: aStream [
	| firstByte element elementClass |
	firstByte := aStream peek.
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	elementClass := self identifyIncomingElement: firstByte.
	elementClass ifNil: [
		LDAPException new messageText: 'invalid tag -- make sure class is in identifyIncomingElements'; signal ].
	element := elementClass new.
	"we should read the tag here, instead of just the first byte"
	element readFrom: aStream.
	^ element

]

{ #category : #reading }
BERElement class >> readLengthFrom: aStream [
	| length octets firstOctet |
	
	firstOctet := aStream next asInteger.
	
	"short definite length"
	firstOctet < 128 ifTrue: [ ^ firstOctet ].
		
	"long definite length"
	octets := aStream next: (firstOctet bitAnd: 16r7F).
	length := octets contents inject: 0 into: [:injectedValue :each | (injectedValue bitShift: 8) + (each asInteger)].
		
	^ length			
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

{ #category : #encoding }
BERElement >> decode: aStream length: anInteger [
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

{ #category : #'instance creation' }
BERElement >> readFrom: aStream [
	| firstByte length |
	firstByte := aStream next. "Maybe assert class type"
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	length := self class readLengthFrom: aStream.
	self decode: aStream length: length.

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
