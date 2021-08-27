"
A request to modify
"
Class {
	#name : #LDAPModifyRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPModifyRequest class >> tagValue [
	^ 16r66 "Application 6"
]

{ #category : #adding }
LDAPModifyRequest >> addOperation: anOp [
	elements second addElement: anOp
]

{ #category : #accessing }
LDAPModifyRequest >> dn: aDn [
	elements first value: aDn
]

{ #category : #initialization }
LDAPModifyRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new).
	self addElement: (BERSequence new).

]

{ #category : #accessing }
LDAPModifyRequest >> ops: someModifyingOps [
	| ops |
	ops := BERSequence new.
	someModifyingOps do: [ :each | ops addElement: each asBERElement ].
	elements at: 2 put: ops.

]
