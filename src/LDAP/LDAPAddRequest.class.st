"
LDAPAddRequest is the process to add a new entry in the LDAP directory.

"
Class {
	#name : #LDAPAddRequest,
	#superclass : #BERSequence,
	#traits : 'TLDAPReturnResult',
	#classTraits : 'TLDAPReturnResult classTrait',
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPAddRequest class >> tagValue [
	^ 16r68 "Application 8"
]

{ #category : #adding }
LDAPAddRequest >> addAttribute: aPartialAttribute [
	elements second addElement: aPartialAttribute
]

{ #category : #accessing }
LDAPAddRequest >> at: aDescription ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self attrs
		detect: [ :pa | pa description = aDescription ] 
		ifFound: [ :pa | aPresentBlock cull: pa ] 
		ifNone: [ anAbsentBlock value ].
]

{ #category : #accessing }
LDAPAddRequest >> at: aDescription put: someValues [

	self at: aDescription 
		ifPresent: [ :pa | pa values: someValues ]
		ifAbsent: [ self addAttribute: (LDAPPartialAttribute new description: aDescription; values: someValues) ].
]

{ #category : #accessing }
LDAPAddRequest >> attrs [
	^ elements second elements
]

{ #category : #accessing }
LDAPAddRequest >> attrs: aDictionary [
	self removeAll.
	aDictionary associationsDo: [ :a | self at: a key put: a value ].

]

{ #category : #accessing }
LDAPAddRequest >> dn: aDn [
	elements first value: aDn
]

{ #category : #initialization }
LDAPAddRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new).
	self addElement: (BERSequence new).

]

{ #category : #removing }
LDAPAddRequest >> removeAll [ 
	elements at: 2 put: BERSequence new.
]
