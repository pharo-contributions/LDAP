"
An entry from a search result
"
Class {
	#name : #LDAPSearchResultEntry,
	#superclass : #BERSequence,
	#instVars : [
		'dn',
		'attrs'
	],
	#category : #'LDAP-Core'
}

{ #category : #testing }
LDAPSearchResultEntry class >> isEndMarker [
	^ false
]

{ #category : #accessing }
LDAPSearchResultEntry class >> tagValue [
	^ 16r64
]

{ #category : #accessing }
LDAPSearchResultEntry >> attrAt: aKey [
	| selected |
	"answer only the first value"
	selected := attrs at: aKey ifAbsent: [ ^ nil ].
	^ selected first asString.

]

{ #category : #accessing }
LDAPSearchResultEntry >> attrs [
	"I return a Dictionary with an entry per attr. Eeach attr is an OrderedCollection, as there may be multiple values per attr."
	^ attrs
]

{ #category : #accessing }
LDAPSearchResultEntry >> attrsAt: aKey [
	| selected |
	"answer all values of the specified attribut"
	selected := attrs at: aKey ifAbsent: [ ^ nil ].
	^ selected

]

{ #category : #encoding }
LDAPSearchResultEntry >> decode: aStream [
	| berDN berAttrs |

	berDN := BERElement newFrom: aStream.
	berAttrs := BERElement newFrom: aStream.

	attrs := Dictionary new.
	berAttrs elements do: [ :eachBerAttr | | values |
		
		values := OrderedCollection new.
		((eachBerAttr value) elements at: 2) value elements do: [ :eachBerValue |	
			values add: (eachBerValue value value) utf8Decoded asString ].
		
		attrs
			at: (((eachBerAttr value) elements at: 1) value value) asString
			put: values ].

	dn := berDN value asString.

]

{ #category : #accessing }
LDAPSearchResultEntry >> dn [
	^ dn
]

{ #category : #testing }
LDAPSearchResultEntry >> isReference [
	^ false
]
