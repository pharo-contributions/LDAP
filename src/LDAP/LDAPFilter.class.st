"
A LDAPFilter is used to select a set of data from the LDAP server. Filters can be associated.
"
Class {
	#name : #LDAPFilter,
	#superclass : #Object,
	#category : #'LDAP-Core'
}

{ #category : #'as yet unclassified' }
LDAPFilter class >> andOf: someFilters [
	| set |
	set := LDAPFilterAnd new.
	someFilters do: [ :each | set add: each ].
	^ set

]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atAnywhereOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atEndOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atEndOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atStartOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atStartOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> not: aFilter [
	^ LDAPFilterNot filter: aFilter
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> orOf: someFilters [
	| set |
	set := LDAPFilterOr new.
	someFilters do: [ :each | set add: each ].
	^ set

]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType [
	^ LDAPFilterPresent having: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType equalTo: anAttrValue [
	^ LDAPFilterEquality new setType: anAttrType value: (anAttrValue utf8Encoded asString)
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType greaterOrEqualThan: anAttrValue [
	^ LDAPFilterGreaterOrEqual new setType: anAttrType value: (anAttrValue utf8Encoded asString)
	
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType lessOrEqualThan: anAttrValue [
	^ LDAPFilterLessOrEqual new setType: anAttrType value: (anAttrValue utf8Encoded asString)
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType notEqualTo: anAttrValue [
	^self not: (self with: anAttrType equalTo: (anAttrValue utf8Encoded asString))
]
