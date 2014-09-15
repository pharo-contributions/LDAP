Class {
	#name : #LDAPFilterNot,
	#superclass : #LDAPFilterWithFilter,
	#category : #'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterNot class >> filter: aFilter [
	^ self new setFilter: aFilter
]

{ #category : #'as yet unclassified' }
LDAPFilterNot class >> tagValue [
	^ 2
]
