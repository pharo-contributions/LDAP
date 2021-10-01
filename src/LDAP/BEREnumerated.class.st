"
BEREnumerated is for a choice within a bounded set of possible values
"
Class {
	#name : #BEREnumerated,
	#superclass : #BERInteger,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEREnumerated class >> tagValue [
	^ 10
]

{ #category : #accessing }
BEREnumerated >> name [
	^ nil
]

{ #category : #printing }
BEREnumerated >> printOn: aStream [
	| name |
	name := self name ifNil: [ ^ super printOn: aStream ].
	aStream nextPutAll: name.
	aStream nextPutAll: ' ('.
	self value printOn: aStream.
	aStream nextPutAll: ')'.

]
