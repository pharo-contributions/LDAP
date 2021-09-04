"
A reference from a search result
"
Class {
	#name : #LDAPSearchResultReference,
	#superclass : #BERSequence,
	#instVars : [
		'url'
	],
	#category : #'LDAP-Core'
}

{ #category : #testing }
LDAPSearchResultReference class >> isEndMarker [
	^ false
]

{ #category : #accessing }
LDAPSearchResultReference class >> tagValue [
	^ 16r73
]

{ #category : #encoding }
LDAPSearchResultReference >> decode: aStream [
	url := (BERElement newFrom: aStream) value asString
]

{ #category : #testing }
LDAPSearchResultReference >> isReference [
	^ true
]

{ #category : #accessing }
LDAPSearchResultReference >> url [
	^ url
]
