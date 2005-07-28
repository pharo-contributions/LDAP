Class {
	#name : #BERConstruct,
	#superclass : #BERElement,
	#instVars : [
		'elements'
	],
	#category : 'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BERConstruct class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
BERConstruct >> addElement: anElement [
	self addElement: anElement withTag: nil
]

{ #category : #'as yet unclassified' }
BERConstruct >> addElement: anElement withTag: aContextTag [
	| taggedElement |
	taggedElement _ Association new;
		key: aContextTag value: anElement.
	elements addLast: taggedElement
]

{ #category : #'as yet unclassified' }
BERConstruct >> decode: aStream [
	| elementLen part |
	
	elementLen _ self length.
	[elementLen > 0]
		whileTrue: [
			part _ self class newFrom: aStream.
			elementLen _ elementLen - part totalLength.
			self addElement: part ]
]

{ #category : #'as yet unclassified' }
BERConstruct >> elements [
	^ elements
]

{ #category : #'as yet unclassified' }
BERConstruct >> initialize [
	super initialize.
	elements _ OrderedCollection new
]

{ #category : #'as yet unclassified' }
BERConstruct >> writeBodyOn: aStream [
	| data dataStream |
	data _ Array new.
	dataStream _ WriteStream on: data.
	
	elements do: [:taggedElement |
		taggedElement value writeOn: dataStream withTag: (taggedElement key) ].
	
	"shouldnt we move this somewhere else?"
	self writeLength: (dataStream contents size) on: aStream.
	aStream nextPutAll: (dataStream contents)
]
