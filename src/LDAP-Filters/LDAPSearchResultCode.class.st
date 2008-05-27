Class {
	#name : #LDAPSearchResultCode,
	#superclass : #LDAPResult,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPSearchResultCode class >> isEndMarker [
	^ true
]

{ #category : #'as yet unclassified' }
LDAPSearchResultCode class >> tagValue [
	^ 16r65
]
