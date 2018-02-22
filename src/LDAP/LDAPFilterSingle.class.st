"
A single filter
"
Class {
	#name : #LDAPFilterSingle,
	#superclass : #Object,
	#category : #'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterSingle class >> tagValue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
LDAPFilterSingle >> asBERElement [
	self subclassResponsibility
]
