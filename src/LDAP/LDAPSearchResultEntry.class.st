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
LDAPSearchResultEntry >> attributes [
"Return the attributes as a collection of BER elements (most probably LDAP partial attributes)"
	^ elements second elements asArray
]

{ #category : #accessing }
LDAPSearchResultEntry >> attrsAsDictionary [
	"I return a Dictionary with an entry per attr. Eeach attr is an collection, as there may be multiple values per attr."
	| partialAttributeList associations |
	partialAttributeList := self attributes.
	associations := partialAttributeList collect: [ :partialAttribute | 
		| type set |
		type := partialAttribute elements first value.
		set := partialAttribute elements second elements.
		type -> (set collect: #value)
	].
	^ associations asDictionary

]

{ #category : #testing }
LDAPSearchResultEntry >> isReference [
	^ false
]

{ #category : #accessing }
LDAPSearchResultEntry >> matchedDN [
	^ elements first value
]
