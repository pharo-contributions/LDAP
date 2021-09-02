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

{ #category : #adding }
BERConstruct >> addAll: aCollection [
	elements addAllLast: aCollection.
]

{ #category : #accessing }
BERConstruct >> addElement: anElement [
	elements addLast: anElement
]

{ #category : #encoding }
BERConstruct >> decode: aStream length: aLength with: aDecoder [
	| index elementLen part |
	elements removeAll.
	index := 1.
	elementLen := aLength.
	[elementLen > 0]
		whileTrue: [
			part := aDecoder elementFrom: aStream in: self at: index.
			elementLen := elementLen - part totalLength.
			self addElement: part.
			index := index + 1.
		].
]

{ #category : #initialization }
BERConstruct >> initialize [
	super initialize.
	elements := OrderedCollection new
]

{ #category : #inspecting }
BERConstruct >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 
	
	^ elements inspectionItems: aBuilder
]

{ #category : #accessing }
BERConstruct >> length [
	^ elements inject: 0 into: [ :sum :each | sum + each totalLength ]
]

{ #category : #printing }
BERConstruct >> printOn: aStream [
	aStream << 'a ' << self class name << ' '.
	elements printElementsOn: aStream.
]

{ #category : #accessing }
BERConstruct >> value [
	^ elements
]

{ #category : #writing }
BERConstruct >> writeBodyOn: aStream [
	elements do: [ :element | element writeOn: aStream  ].

]
