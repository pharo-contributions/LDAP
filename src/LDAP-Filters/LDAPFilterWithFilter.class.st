Class {
	#name : #LDAPFilterWithFilter,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'filter'
	],
	#category : 'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterWithFilter >> asBERElement [
	| ber |
	ber _ BERSet new.
	ber addElement: (filter asBERElement) tagSetContext withTag: filter class tagValue.
	
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPFilterWithFilter >> setFilter: aFilter [
	filter _ aFilter
]
