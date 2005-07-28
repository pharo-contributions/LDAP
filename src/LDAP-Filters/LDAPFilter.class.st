Class {
	#name : #LDAPFilter,
	#superclass : #Object,
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPFilter class >> andOf: someFilters [
	| set |
	set _ LDAPFilterAnd new.
	someFilters do: [ :each | set add: each ].
	^ set

]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ LDAPFilterSubstrings containing: aSubstring atAnywhereOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atEndOf: anAttrType [
	^ LDAPFilterSubstrings containing: aSubstring atEndOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> containing: aSubstring atStartOf: anAttrType [
	^ LDAPFilterSubstrings containing: aSubstring atStartOf: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> not: aFilter [
	^ LDAPFilterNot filter: aFilter
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> orOf: someFilters [
	| set |
	set _ LDAPFilterOr new.
	someFilters do: [ :each | set add: each ].
	^ set

]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType [
	^ LDAPFilterPresent having: anAttrType
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType equalTo: anAttrValue [
	^ LDAPFilterEquality new setType: anAttrType value: anAttrValue
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType greaterOrEqualThan: anAttrValue [
	^ LDAPFilterGreaterOrEqual new setType: anAttrType value: anAttrValue
	
]

{ #category : #'as yet unclassified' }
LDAPFilter class >> with: anAttrType lessOrEqualThan: anAttrValue [
	^ LDAPFilterLessOrEqual new setType: anAttrType value: anAttrValue
]
