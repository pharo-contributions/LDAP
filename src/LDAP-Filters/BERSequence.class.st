Class {
	#name : #BERSequence,
	#superclass : #BERConstruct,
	#category : #'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BERSequence class >> tagValue [
	"SEQUENCE + Constructed"
	^ (16 + 32)
]

{ #category : #'as yet unclassified' }
BERSequence >> decode: aStream [
	^ super decode: aStream
]
