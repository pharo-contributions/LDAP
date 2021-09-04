"
An LDAP Message
"
Class {
	#name : #LDAPMessage,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #'instance creation' }
LDAPMessage class >> newFrom: aStream [
	| mesg |
	mesg := self new.
	mesg readFrom: aStream.
	^ mesg
]

{ #category : #accessing }
LDAPMessage >> id [
	^ elements first value
]

{ #category : #accessing }
LDAPMessage >> response [
	^ elements second
]
