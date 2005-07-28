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
	#category : 'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BERElement class >> elementClasses [
	^ {
		BERInteger. BEROctetString . BERSequence. BEREnumerated. BERBoolean. BERSet. BERNull.

		"this has to go here for now"
		LDAPAddResult. LDAPBindResult. LDAPCompareResult. LDAPDelResult. LDAPExtendedResult.
		LDAPModifyResult. LDAPModifyDNResult. LDAPSearchResultEntry. LDAPSearchResultCode.
	}.
	
]

{ #category : #'as yet unclassified' }
BERElement class >> identifyIncomingElement: firstByte [
	| type |
	"so why are we doing this in a comparision here, instead of asking the class wether it handles the element?"
	type _ self elementClasses detect: [ :each | each tagValue = firstByte asInteger ] ifNone: [nil].
	^ type
	
]

{ #category : #'as yet unclassified' }
BERElement class >> new [
	"this is here only to easily see who is using it down the heriarchy through the browser"
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
BERElement class >> newFrom: aStream [
	| firstByte element elementClass |
	firstByte _ aStream next.
	Transcript show: '*** Next byte is: ', firstByte asString; cr.
	elementClass _ self identifyIncomingElement: firstByte.
	elementClass ifNil: [
		LDAPException new messageText: 'invalid tag -- make sure class is in identifyIncomingElements'; signal ].
	element _ elementClass new setTag: firstByte.
	"we should read the tag here, instead of just the first byte"
	element readLengthFrom: aStream.
	element decode: aStream.
	^ element

]

{ #category : #'as yet unclassified' }
BERElement class >> tagValue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BERElement >> decode: aStream [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BERElement >> initialize [
	tagHeader _ 0

]

{ #category : #'as yet unclassified' }
BERElement >> length [
	^ length
]

{ #category : #'as yet unclassified' }
BERElement >> lengthLength [
	^ lengthLength
]

{ #category : #'as yet unclassified' }
BERElement >> readLengthFrom: aStream [
	| octets  firstOctet |
	
	firstOctet _ aStream next asInteger.
	firstOctet < 128
		
		"short definite length"
		ifTrue: [ length _ firstOctet. lengthLength _ 1. ]
		
		"long definite length"
		ifFalse: [
			octets _ aStream next: (firstOctet bitXor: 128).
			lengthLength _ (firstOctet bitXor: 128) + 1. "the lengthlenghlength byte.. ugh."
			length _ octets contents inject: 0 into: [:injectedValue :each | (injectedValue bitShift: 8) + (each asInteger)]
		].
		
	^ length			
]

{ #category : #'as yet unclassified' }
BERElement >> setTag: aTag [
	tagHeader _ aTag.
	tagLength _ 1
]

{ #category : #'as yet unclassified' }
BERElement >> tagLength [
	^ 1
]

{ #category : #'as yet unclassified' }
BERElement >> tagSetApplication [
	tagHeader _ tagHeader bitOr: 16r40
]

{ #category : #'as yet unclassified' }
BERElement >> tagSetContext [
	tagHeader _ tagHeader bitOr: 16r80
		
]

{ #category : #'as yet unclassified' }
BERElement >> totalLength [
	^ self length + self lengthLength + self tagLength
]

{ #category : #'as yet unclassified' }
BERElement >> value [
	^ value
]

{ #category : #'as yet unclassified' }
BERElement >> value: aValue [
	value _ aValue
]

{ #category : #'as yet unclassified' }
BERElement >> writeBodyOn: aStream [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BERElement >> writeLength: aLength on: aStream [
	| octets octetsIndex remainderValue netOctets |
	
	octetsIndex _ 1.
	aLength < 128
		
		"short definite length"
		ifTrue: [ aStream nextPut: aLength asCharacter ]
		
		"long definite length"
		ifFalse: [
			"why were we using value in this block, instead of aLength?"
			octets _ ByteArray new: (aLength digitLength + 1).
			remainderValue _ aLength.
			[remainderValue > 0] whileTrue: [
				octets at: octetsIndex  put: (remainderValue bitAnd: 16rFF).
				octetsIndex _ octetsIndex + 1.
				remainderValue _ remainderValue bitShift: -8 ].
			octets at: octetsIndex put: ((octetsIndex - 1) bitOr: 128).
			
			"hton"
			netOctets _ ByteArray new: octetsIndex.
			(1 to: octetsIndex)
				do: [:i | netOctets at: i put: (octets at: (octetsIndex + 1) - i) ].
			
			aStream nextPutAll: (netOctets asString).
		].
		
	^ octetsIndex			
]

{ #category : #'as yet unclassified' }
BERElement >> writeOn: aStream [
	aStream nextPut: ((self class tagValue bitOr: tagHeader) asCharacter).
	self writeBodyOn: aStream

]

{ #category : #'as yet unclassified' }
BERElement >> writeOn: aStream withTag: aTag [
	| combinedTag |
	combinedTag _ self class tagValue bitOr: tagHeader.

	"here we are supposing that if we are given a tag, we dont need the universal tag value
	 im not really sure on wether its correct or not ."
	
	"however, we are in .25 and its proved to be correct so far"			
	
	aTag ifNotNil: [
		combinedTag _ ((combinedTag bitOr: 31)  bitXor: 31).
		combinedTag _ combinedTag bitOr: aTag ].

	aStream nextPut: (combinedTag asCharacter).
	self writeBodyOn: aStream

]
