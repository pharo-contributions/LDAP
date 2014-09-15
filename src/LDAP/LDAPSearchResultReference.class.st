Class {
	#name : #LDAPSearchResultReference,
	#superclass : #LDAPMessage,
	#instVars : [
		'url'
	],
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPSearchResultReference class >> isEndMarker [
	^ false
]

{ #category : #'as yet unclassified' }
LDAPSearchResultReference class >> tagValue [
	^ 16r73
]

{ #category : #'as yet unclassified' }
LDAPSearchResultReference >> decode: aStream [
	url := (BERElement newFrom: aStream) value asString
]

{ #category : #'as yet unclassified' }
LDAPSearchResultReference >> isReference [
	^ true
]

{ #category : #'as yet unclassified' }
LDAPSearchResultReference >> url [
	^ url
]
