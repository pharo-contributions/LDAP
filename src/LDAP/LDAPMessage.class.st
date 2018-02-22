"
An LDAP Message
"
Class {
	#name : #LDAPMessage,
	#superclass : #BERElement,
	#instVars : [
		'id'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPMessage class >> newFrom: aStream [
	| ber mesg |
	ber := BERElement newFrom: aStream.
	mesg :=( (ber elements at: 2) value).
	mesg id: ((ber elements at: 1) value value).
	^ mesg
]

{ #category : #'as yet unclassified' }
LDAPMessage >> id [
	^ id
]

{ #category : #'as yet unclassified' }
LDAPMessage >> id: aMessageId [
	id := aMessageId
]
