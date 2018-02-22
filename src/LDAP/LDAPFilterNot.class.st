"
NOT filter
"
Class {
	#name : #LDAPFilterNot,
	#superclass : #LDAPFilterWithFilter,
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterNot class >> filter: aFilter [
	^ self new setFilter: aFilter
]

{ #category : #accessing }
LDAPFilterNot class >> tagValue [
	^ 2
]
