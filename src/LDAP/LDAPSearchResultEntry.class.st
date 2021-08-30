"
An entry from a search result
"
Class {
	#name : #LDAPSearchResultEntry,
	#superclass : #LDAPSearchPartialResult,
	#category : #'LDAP-Results'
}

{ #category : #accessing }
LDAPSearchResultEntry class >> tagValue [
	^ 16r64
]

{ #category : #accessing }
LDAPSearchResultEntry >> attrAt: aKey [
	"answer only the first value"
	| partialAttributeList selected |
	partialAttributeList := elements second value.
	selected := partialAttributeList detect: [ :pa | aKey = pa value first value ] ifNone: [ ^ nil ].
	^ selected value second value first value

]

{ #category : #accessing }
LDAPSearchResultEntry >> attrs [
	"I return a Dictionary with an entry per attr. Eeach attr is an collection, as there may be multiple values per attr."
	| partialAttributeList  |
	partialAttributeList := elements second value.
	^ partialAttributeList collect: [ :partialAttribute | 
		| type set |
		type := partialAttribute value first value.
		set := partialAttribute value second value.
		type -> (set collect: #value)
	] asDictionary

]

{ #category : #accessing }
LDAPSearchResultEntry >> attrsAt: aKey [
	"answer all values of the specified attribut"
	| partialAttributeList selected |
	partialAttributeList := elements second value.
	selected := partialAttributeList detect: [ :pa | aKey = pa value first value ] ifNone: [ ^ nil ].
	^ selected value second value collect: #value

]

{ #category : #testing }
LDAPSearchResultEntry >> isReference [
	^ false
]

{ #category : #accessing }
LDAPSearchResultEntry >> matchedDN [
	^ elements first value
]
