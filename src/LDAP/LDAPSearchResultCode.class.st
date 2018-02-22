"
Search result code
"
Class {
	#name : #LDAPSearchResultCode,
	#superclass : #LDAPResult,
	#category : #'LDAP-Core'
}

{ #category : #testing }
LDAPSearchResultCode class >> isEndMarker [
	^ true
]

{ #category : #accessing }
LDAPSearchResultCode class >> tagValue [
	^ 16r65
]
