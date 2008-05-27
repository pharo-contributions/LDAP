Class {
	#name : #BERSet,
	#superclass : #BERConstruct,
	#category : #'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BERSet class >> tagValue [
	"SET + Constructed"
	^ (17 + 32)
]

{ #category : #'as yet unclassified' }
BERSet >> decode: aStream [
	^ super decode: aStream
]
