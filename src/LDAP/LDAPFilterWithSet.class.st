"
Filter with a set of filters
"
Class {
	#name : #LDAPFilterWithSet,
	#superclass : #LDAPFilterSingle,
	#instVars : [
		'filters'
	],
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterWithSet class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
LDAPFilterWithSet >> add: aFilter [
	filters addLast: aFilter
]

{ #category : #conversion }
LDAPFilterWithSet >> asBERElement [
	| ber |
	ber := BERSet new.
	filters do: [ :each | ber addElement: (each asBERElement) tagSetContext withTag: each class tagValue ].
	^ ber
]

{ #category : #initialization }
LDAPFilterWithSet >> initialize [
	filters := OrderedCollection new
	
]
