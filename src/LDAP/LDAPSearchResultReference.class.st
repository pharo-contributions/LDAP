"
A reference from a search result
"
Class {
	#name : #LDAPSearchResultReference,
	#superclass : #LDAPSearchPartialResult,
	#category : #'LDAP-Results'
}

{ #category : #accessing }
LDAPSearchResultReference class >> tagValue [
	^ 16r73
]

{ #category : #testing }
LDAPSearchResultReference >> isReference [
	^ true
]

{ #category : #accessing }
LDAPSearchResultReference >> url [
	^ elements first value
]

{ #category : #accessing }
LDAPSearchResultReference >> urls [
	^ elements collect: #value

]
