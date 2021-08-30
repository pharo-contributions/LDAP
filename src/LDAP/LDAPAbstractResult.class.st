"
Abstract class for all LDAP result messages.

It defines the interface which should include:
- checkForException
- isEndMarker
 
"
Class {
	#name : #LDAPAbstractResult,
	#superclass : #BERSequence,
	#category : #'LDAP-Results'
}

{ #category : #'error handling' }
LDAPAbstractResult >> checkForExceptions [
	^ self subclassResponsibility
]

{ #category : #testing }
LDAPAbstractResult >> isEndMarker [
	^ self subclassResponsibility 
]

{ #category : #accessing }
LDAPAbstractResult >> matchedDN [
	^ self subclassResponsibility
]
