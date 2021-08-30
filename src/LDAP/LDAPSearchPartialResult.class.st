"
Abstract base class for partial result messages.

I override isEndMarker to notify the client that other messages will come after me.
"
Class {
	#name : #LDAPSearchPartialResult,
	#superclass : #LDAPAbstractResult,
	#category : #'LDAP-Results'
}

{ #category : #'error handling' }
LDAPSearchPartialResult >> checkForExceptions [
"No exception for those results"
	^ self
]

{ #category : #testing }
LDAPSearchPartialResult >> isEndMarker [
	^ false
]

{ #category : #accessing }
LDAPSearchPartialResult >> matchedDN [
	^ self subclassResponsibility
]
