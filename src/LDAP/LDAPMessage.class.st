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

{ #category : #'instance creation' }
LDAPMessage class >> newFrom: aStream [
	| ber mesg |
	ber := BERElement newFrom: aStream.
	mesg :=( (ber elements at: 2) value).
	mesg id: ((ber elements at: 1) value value).
	^ mesg
]

{ #category : #accessing }
LDAPMessage >> id [
	^ id
]

{ #category : #accessing }
LDAPMessage >> id: aMessageId [
	id := aMessageId
]
