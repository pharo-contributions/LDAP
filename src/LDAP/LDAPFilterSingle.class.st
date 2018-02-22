"
A single filter
"
Class {
	#name : #LDAPFilterSingle,
	#superclass : #Object,
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterSingle class >> tagValue [
	self subclassResponsibility
]

{ #category : #conversion }
LDAPFilterSingle >> asBERElement [
	self subclassResponsibility
]
