"
I decode a stream into a BERElement instance.

I am responsible for creation of universal class elements.
I defer to my application instance variable for application class elements.
For constructed types, I query the constructed instance for context class elements.
"
Class {
	#name : #BERDecoder,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#classVars : [
		'UniversalTags'
	],
	#category : #'LDAP-BER'
}

{ #category : #initialization }
BERDecoder class >> initialize [ 
"BERElement class initialization. Populate the knownTags variable for universal elements creation."
	| classes |
	classes := { BERInteger. BEROctetString . BERSequence. BEREnumerated. BERBoolean. BERSet. BERNull. }.
	UniversalTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

{ #category : #testing }
BERDecoder class >> isApplication: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16r40
]

{ #category : #testing }
BERDecoder class >> isConstructed: aTagValue [
	^ (aTagValue bitAnd: 16r20) = 16r20
]

{ #category : #testing }
BERDecoder class >> isContext: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16r80
]

{ #category : #testing }
BERDecoder class >> isPrivate: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16rC0
]

{ #category : #testing }
BERDecoder class >> isUniversal: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 0
]

{ #category : #reading }
BERDecoder class >> readLengthFrom: aStream [
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
BERDecoder class >> universalClass: aTagValue [
"Return a BER universal class from a tag value"
	^ UniversalTags at: aTagValue ifAbsent: [ nil ]
]

{ #category : #accessing }
BERDecoder >> application: anObject [
	application := anObject
]

{ #category : #'private - creation' }
BERDecoder >> createApplicationElement: aTagValue [
"Create a BER application element from a tag value."
	| element |
	(self class isApplication: aTagValue) ifFalse: [ ^ nil ]. 
	application ifNil: [ ^ self createElementError: 'invalid application tag -- no application set' ].
	element := application createApplicationElement: aTagValue.
	^ element ifNil: [ self createElementError: 'invalid application tag' ]

]

{ #category : #'instance creation' }
BERDecoder >> createElement: aTagValue [
"Create a BER element from a tag value"
	(self createUniversalElement: aTagValue) ifNotNil: [ :element | ^ element ].
	(self createApplicationElement: aTagValue) ifNotNil: [ :element | ^ element ].
	^ self createElementError: 'invalid tag -- could not create element'

]

{ #category : #'private - creation' }
BERDecoder >> createElement: aTagValue in: aContextObject at: anIndex [
"Create a BER element from a tag value"
	aContextObject ifNil: [ ^ self createElement: aTagValue ].
	
	"Delegates to the BER element, it will call default implementation and goes to createElement: message."
	^ aContextObject createContextElement: aTagValue at: anIndex with: self 

]

{ #category : #'error handling' }
BERDecoder >> createElementError: aString [
"Create a BER unknown element and signal error."
	LDAPException new messageText: aString; signal.
	^ BERUnknownElement new

]

{ #category : #'private - creation' }
BERDecoder >> createUniversalElement: aTagValue [
"Create a BER universal element from a tag value"
	| elementClass |
	(self class isUniversal: aTagValue) ifFalse: [ ^ nil ]. 
	elementClass := self class universalClass: aTagValue.
	^ elementClass ifNil: [ self createElementError: 'invalid universal tag' ] ifNotNil: [ :c | c new ]

]

{ #category : #reading }
BERDecoder >> decode: anElement from: aStream [
"Decode an already existing element from a stream"
	| firstByte length |
	firstByte := aStream next asInteger.
	(firstByte = anElement class tagValue) ifFalse: [ self error: 'inconsitent tag value' ].
	length := self class readLengthFrom: aStream.
	anElement decode: aStream length: length with: self.
	^ anElement

]

{ #category : #'instance creation' }
BERDecoder >> elementFrom: aStream [
"Create a BER element from a stream"
	"Entry method with no context"
	^ self elementFrom: aStream in: nil at: 0

]

{ #category : #'instance creation' }
BERDecoder >> elementFrom: aStream in: aContextObject at: anIndex [
"Create a BER element from a stream"
	| firstByte element |
	firstByte := aStream peek asInteger.
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	element := self createElement: firstByte in: aContextObject at: anIndex.
	^ self decode: element from: aStream  

]
