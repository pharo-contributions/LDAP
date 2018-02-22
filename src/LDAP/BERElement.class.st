"
A BERElement is a datatype in the BER encoding (Basic Encoding Rules)
"
Class {
	#name : #BERElement,
	#superclass : #Object,
	#instVars : [
		'length',
		'lengthLength',
		'value',
		'tagHeader',
		'tagLength'
	],
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

{ #category : #'instance creation' }
BERElement class >> new [
	"this is here only to easily see who is using it down the heriarchy through the browser"
	^ self basicNew initialize
]

{ #category : #'instance creation' }
BERElement class >> newFrom: aStream [
	| firstByte element elementClass |
	firstByte := aStream next.
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	elementClass := self identifyIncomingElement: firstByte.
	elementClass ifNil: [
		LDAPException new messageText: 'invalid tag -- make sure class is in identifyIncomingElements'; signal ].
	element := elementClass new setTag: firstByte.
	"we should read the tag here, instead of just the first byte"
	element readLengthFrom: aStream.
	element decode: aStream.
	^ element

]

{ #category : #accessing }
BERElement class >> tagValue [
	self subclassResponsibility
]

{ #category : #encoding }
BERElement >> decode: aStream [
	self subclassResponsibility
]

{ #category : #initialization }
BERElement >> initialize [
	tagHeader := 0

]

{ #category : #accessing }
BERElement >> length [
	^ length
]

{ #category : #accessing }
BERElement >> lengthLength [
	^ lengthLength
]

{ #category : #reading }
BERElement >> readLengthFrom: aStream [
	| octets  firstOctet |
	
	firstOctet := aStream next asInteger.
	firstOctet < 128
		
		"short definite length"
		ifTrue: [ length := firstOctet. lengthLength := 1. ]
		
		"long definite length"
		ifFalse: [
			octets := aStream next: (firstOctet bitXor: 128).
			lengthLength := (firstOctet bitXor: 128) + 1. "the lengthlenghlength byte.. ugh."
			length := octets contents inject: 0 into: [:injectedValue :each | (injectedValue bitShift: 8) + (each asInteger)]
		].
		
	^ length			
]

{ #category : #accessing }
BERElement >> setTag: aTag [
	tagHeader := aTag.
	tagLength := 1
]

{ #category : #tagging }
BERElement >> tagLength [
	^ 1
]

{ #category : #tagging }
BERElement >> tagSetApplication [
	tagHeader := tagHeader bitOr: 16r40
]

{ #category : #tagging }
BERElement >> tagSetContext [
	tagHeader := tagHeader bitOr: 16r80
		
]

{ #category : #accessing }
BERElement >> totalLength [
	^ self length + self lengthLength + self tagLength
]

{ #category : #accessing }
BERElement >> value [
	^ value
]

{ #category : #accessing }
BERElement >> value: aValue [
	value := aValue
]

{ #category : #writing }
BERElement >> writeBodyOn: aStream [
	self subclassResponsibility
]

{ #category : #writing }
BERElement >> writeLength: aLength on: aStream [
	| octets octetsIndex remainderValue netOctets |
	
	octetsIndex := 1.
	aLength < 128
		
		"short definite length"
		ifTrue: [ aStream nextPut: aLength asCharacter ]
		
		"long definite length"
		ifFalse: [
			"why were we using value in this block, instead of aLength?"
			octets := ByteArray new: (aLength digitLength + 1).
			remainderValue := aLength.
			[remainderValue > 0] whileTrue: [
				octets at: octetsIndex  put: (remainderValue bitAnd: 16rFF).
				octetsIndex := octetsIndex + 1.
				remainderValue := remainderValue bitShift: -8 ].
			octets at: octetsIndex put: ((octetsIndex - 1) bitOr: 128).
			
			"hton"
			netOctets := ByteArray new: octetsIndex.
			(1 to: octetsIndex)
				do: [:i | netOctets at: i put: (octets at: (octetsIndex + 1) - i) ].
			
			aStream nextPutAll: (netOctets asString).
		].
		
	^ octetsIndex			
]

{ #category : #writing }
BERElement >> writeOn: aStream [
	aStream nextPut: ((self class tagValue bitOr: tagHeader) asCharacter).
	self writeBodyOn: aStream

]

{ #category : #writing }
BERElement >> writeOn: aStream withTag: aTag [
	| combinedTag |
	combinedTag := self class tagValue bitOr: tagHeader.

	"here we are supposing that if we are given a tag, we dont need the universal tag value
	 im not really sure on wether its correct or not ."
	
	"however, we are in .25 and its proved to be correct so far"			
	
	aTag ifNotNil: [
		combinedTag := ((combinedTag bitOr: 31)  bitXor: 31).
		combinedTag := combinedTag bitOr: aTag ].

	aStream nextPut: (combinedTag asCharacter).
	self writeBodyOn: aStream

]
