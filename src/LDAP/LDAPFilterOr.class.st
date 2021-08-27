"
OR filter
"
Class {
	#name : #LDAPFilterOr,
	#superclass : #LDAPFilterWithSet,
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterOr class >> tagValue [
	^ 16rA1 "Context 1"
]

{ #category : #converting }
LDAPFilterOr >> asOrElements [ 
	^ elements
]
