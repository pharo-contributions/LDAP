Class {
	#name : #LDAPSearchResultEntry,
	#superclass : #LDAPMessage,
	#instVars : [
		'dn',
		'attrs'
	],
	#category : #LDAP
}

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry class >> isEndMarker [
	^ false
]

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry class >> tagValue [
	^ 16r64
]

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry >> attrAt: aKey [
	| selected |
	selected := attrs at: (aKey asByteArray) ifAbsent: [ ^ nil ].
	^ selected first asString.

]

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry >> attrs [
	"I return a Dictionary with an entry per attr. Eeach attr is an OrderedCollection, as there may be multiple values per attr."
	^ attrs
]

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry >> decode: aStream [
	| berDN berAttrs |

	berDN := BERElement newFrom: aStream.
	berAttrs := BERElement newFrom: aStream.

	attrs := Dictionary new.
	berAttrs elements do: [ :eachBerAttr | | values |
		
		values := OrderedCollection new.
		((eachBerAttr value) elements at: 2) value elements do: [ :eachBerValue |	
			values add: (eachBerValue value value) ].
		
		attrs
			at: (((eachBerAttr value) elements at: 1) value value)
			put: values ].

	dn := berDN value.

]

{ #category : #'as yet unclassified' }
LDAPSearchResultEntry >> dn [
	^ dn
]
