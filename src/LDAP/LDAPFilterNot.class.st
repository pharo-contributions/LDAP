"
NOT filter
"
Class {
	#name : #LDAPFilterNot,
	#superclass : #BERSet,
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterNot class >> filter: aFilter [
	^ self new filter: aFilter
]

{ #category : #accessing }
LDAPFilterNot class >> tagValue [
	^ 16rA2 "Context 2"
]

{ #category : #accessing }
LDAPFilterNot >> filter: aFilter [
	elements at: 1 put: aFilter
]

{ #category : #initialization }
LDAPFilterNot >> initialize [ 
	super initialize.
	
	self addElement: (LDAPFilterAnd new).
]

{ #category : #'logical operations' }
LDAPFilterNot >> not [
	^ elements first
]
