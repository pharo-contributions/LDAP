"
A BERConstruct can be a BERSequence or a BERSet.
"
Class {
	#name : #BERConstruct,
	#superclass : #BERElement,
	#instVars : [
		'elements'
	],
	#category : #'LDAP-BER'
}

{ #category : #'instance creation' }
BERConstruct class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
BERConstruct >> addElement: anElement [
	self addElement: anElement withTag: nil
]

{ #category : #accessing }
BERConstruct >> addElement: anElement withTag: aContextTag [
	| taggedElement |
	taggedElement := Association new;
		key: aContextTag value: anElement.
	elements addLast: taggedElement
]

{ #category : #encoding }
BERConstruct >> decode: aStream [
	| elementLen part |
	
	elementLen := self length.
	[elementLen > 0]
		whileTrue: [
			part := self class newFrom: aStream.
			elementLen := elementLen - part totalLength.
			self addElement: part ]
]

{ #category : #accessing }
BERConstruct >> elements [
	^ elements
]

{ #category : #initialization }
BERConstruct >> initialize [
	super initialize.
	elements := OrderedCollection new
]

{ #category : #writing }
BERConstruct >> writeBodyOn: aStream [
	| data dataStream |
	data := Array new.
	dataStream := WriteStream on: data.
	
	elements do: [:taggedElement |
		taggedElement value writeOn: dataStream withTag: (taggedElement key) ].
	
	"shouldnt we move this somewhere else?"
	self writeLength: (dataStream contents size) on: aStream.
	aStream nextPutAll: (dataStream contents)
]
