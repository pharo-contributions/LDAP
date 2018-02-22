"
A combined filter
"
Class {
	#name : #LDAPFilterWithFilter,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'filter'
	],
	#category : #'LDAP-Filters'
}

{ #category : #conversion }
LDAPFilterWithFilter >> asBERElement [
	| ber |
	ber := BERSet new.
	ber addElement: (filter asBERElement) tagSetContext withTag: filter class tagValue.
	
	^ ber
]

{ #category : #accessing }
LDAPFilterWithFilter >> setFilter: aFilter [
	filter := aFilter
]
