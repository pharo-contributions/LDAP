Class {
	#name : #LDAPFilterWithSet,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'filters'
	],
	#category : #'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterWithSet class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
LDAPFilterWithSet >> add: aFilter [
	filters addLast: aFilter
]

{ #category : #'as yet unclassified' }
LDAPFilterWithSet >> asBERElement [
	| ber |
	ber := BERSet new.
	filters do: [ :each | ber addElement: (each asBERElement) tagSetContext withTag: each class tagValue ].
	^ ber
]

{ #category : #'as yet unclassified' }
LDAPFilterWithSet >> initialize [
	filters := OrderedCollection new
	
]
