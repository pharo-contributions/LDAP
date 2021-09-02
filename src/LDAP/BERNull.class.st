"
BERNull is a NULL value encoded in BER.
"
Class {
	#name : #BERNull,
	#superclass : #BERElement,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERNull class >> tagValue [
	^ 5
]

{ #category : #encoding }
BERNull >> decode: aStream length: anInteger with: aDecoder [
"Nothing to do"
]

{ #category : #accessing }
BERNull >> length [
	^ 0
]

{ #category : #printing }
BERNull >> printOn: aStream [
	aStream << self class name.
]

{ #category : #accessing }
BERNull >> value [
	^ nil
]

{ #category : #writing }
BERNull >> writeBodyOn: aStream [
"Nothing to do"
]
