"
Substrings as filter
"
Class {
	#name : #LDAPFilterSubstrings,
	#superclass : #BERSequence,
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPAnySubstring new value: aSubstring); yourself

]

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atEndOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPFinalSubstring new value: aSubstring); yourself

]

{ #category : #'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atStartOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPInitialSubstring new value: aSubstring); yourself

]

{ #category : #accessing }
LDAPFilterSubstrings class >> tagValue [
	^ 16rA4 "Context 4"
]

{ #category : #adding }
LDAPFilterSubstrings >> addSubstring: aSubString [
	elements second addElement: aSubString.
]

{ #category : #initialization }
LDAPFilterSubstrings >> initialize [ 
	super initialize.

	self addElement: (BEROctetString new).
	self addElement: (BERSequence new).

]

{ #category : #accessing }
LDAPFilterSubstrings >> type: aString [
	elements first value: aString.
]
