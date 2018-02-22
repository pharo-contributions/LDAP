"
Substrings as filter
"
Class {
	#name : #LDAPFilterSubstrings,
	#superclass : #LDAPFilterWithSubstring,
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 1

]

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atEndOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 2

]

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atStartOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 0

]

{ #category : #accessing }
LDAPFilterSubstrings class >> tagValue [
	^ 4
]
