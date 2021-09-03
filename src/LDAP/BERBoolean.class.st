"
BERBoolean is a boolean encoded in BER.
"
Class {
	#name : #BERBoolean,
	#superclass : #BERPrimitive,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERBoolean class >> tagValue [
	^ 1
]

{ #category : #encoding }
BERBoolean >> decode: aStream length: anInteger with: aDecoder [
	self value: aStream next.

]

{ #category : #accessing }
BERBoolean >> length [
	^ 1
]

{ #category : #accessing }
BERBoolean >> value [ 
	^ value ifNil: [ false ]
]

{ #category : #accessing }
BERBoolean >> value: anObject [
"Convert object to a boolean"
	anObject == true ifTrue: [ value := true. ^ self ].
	anObject == false ifTrue: [ value := false. ^ self ].
	value := anObject isNumber
		ifTrue: [ anObject isZero not ]
		ifFalse: [ false ].

]

{ #category : #writing }
BERBoolean >> writeBodyOn: aStream [
	self value
		ifFalse: [aStream nextPut: (0 asCharacter)]
		ifTrue: [aStream nextPut: (255 asCharacter)].

]
