"
Helper trait to compose filters more easily
"
Trait {
	#name : #TLDAPComposeFilter,
	#traits : 'TEmpty',
	#classTraits : 'TEmpty classTrait',
	#category : #'LDAP-Filters'
}

{ #category : #'logical operations' }
TLDAPComposeFilter >> & aFilter [
	| set |
	set := LDAPFilterAnd new.
	set addAll: self asAndElements.
	set addAll: aFilter asAndElements.
	^ set

]

{ #category : #converting }
TLDAPComposeFilter >> asAndElements [
	^ { self }
]

{ #category : #converting }
TLDAPComposeFilter >> asOrElements [
	^ { self }
]

{ #category : #'logical operations' }
TLDAPComposeFilter >> not [ 
	^ LDAPFilterNot filter: self
]

{ #category : #'logical operations' }
TLDAPComposeFilter >> | aFilter [
	| set |
	set := LDAPFilterOr new.
	set addAll: self asOrElements.
	set addAll: aFilter asOrElements.
	^ set

]
