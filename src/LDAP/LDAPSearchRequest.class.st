"
LDAPSearchRequest is the process to search entries from the LDAP directory.
"
Class {
	#name : #LDAPSearchRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPSearchRequest class >> tagValue [
	^ 16r63 "Application 3"
]

{ #category : #accessing }
LDAPSearchRequest >> attrs: someAttrs [
	| ber |
	ber := BERSequence new.
	someAttrs do: [ :each | ber addElement: (BEROctetString new value: each) ].
	elements at: 8 put: ber.
]

{ #category : #accessing }
LDAPSearchRequest >> base: aDn [
	elements first value: aDn
]

{ #category : #accessing }
LDAPSearchRequest >> derefAliases: anAliasingPolicy [
	elements at: 3 put: anAliasingPolicy
]

{ #category : #accessing }
LDAPSearchRequest >> filter: aFilter [
	elements at: 7 put: aFilter 
]

{ #category : #initialization }
LDAPSearchRequest >> initialize [ 
	super initialize.
	
	self
		addElement: (BEROctetString new); "dn"
		addElement: (LDAPBaseObjectScope new); "scope"
		addElement: (LDAPNeverDeferAliases new); "derefAliases"
		addElement: (BERInteger new value: 0); "sizelimit"
		addElement: (BERInteger new value: 0); "timelimit"
		addElement: (BERBoolean new); "typesOnly"
		addElement: (LDAPFilterAnd new); "filter. Absolute true filter (&)"
		addElement: (BERSequence new). "attrs"

]

{ #category : #testing }
LDAPSearchRequest >> processResult: aCollection [
"Return search entries"
	aCollection do: #checkForExceptions.
	^ aCollection select: [ :r | r isKindOf: LDAPSearchResultEntry ]

]

{ #category : #accessing }
LDAPSearchRequest >> scope: aScope [
	elements at: 2 put: aScope
]

{ #category : #accessing }
LDAPSearchRequest >> sizeLimit: anInteger [
	elements fourth value: anInteger
]

{ #category : #accessing }
LDAPSearchRequest >> timeLimit: anInteger [
	elements fifth value: anInteger
]

{ #category : #accessing }
LDAPSearchRequest >> wantAttrsOnly: aBoolean [
	elements sixth value: aBoolean
]
