"
BERBoolean is a boolean encoded in BER.
"
Class {
	#name : #BERBoolean,
	#superclass : #BERElement,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERBoolean class >> tagValue [
	^ 1
]

{ #category : #encoding }
BERBoolean >> decode: aStream [
	value := aStream next.
	value := value > 0.

]

{ #category : #writing }
BERBoolean >> writeBodyOn: aStream [
	self writeLength: 1 on: aStream.
	(value = 0 or: [value = false])
		ifTrue: [aStream nextPut: (0 asCharacter)]
		ifFalse: [aStream nextPut: (255 asCharacter)].

]
