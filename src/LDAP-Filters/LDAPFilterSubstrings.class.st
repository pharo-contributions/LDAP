Class {
	#name : #LDAPFilterSubstrings,
	#superclass : #LDAPFilterWithSubstring,
	#category : 'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterSubstrings class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 1

]

{ #category : #'as yet unclassified' }
LDAPFilterSubstrings class >> containing: aSubstring atEndOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 2

]

{ #category : #'as yet unclassified' }
LDAPFilterSubstrings class >> containing: aSubstring atStartOf: anAttrType [
	^ self new setSubstring: aSubstring type: anAttrType choiceTag: 0

]

{ #category : #'as yet unclassified' }
LDAPFilterSubstrings class >> tagValue [
	^ 4
]
