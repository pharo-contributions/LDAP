"
Request to modify a distinguished name
"
Class {
	#name : #LDAPModifyDNRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPModifyDNRequest class >> tagValue [
	^ 16r6C "Application 12"
]

{ #category : #accessing }
LDAPModifyDNRequest >> dn: aDn [
	elements first value: aDn
]

{ #category : #initialization }
LDAPModifyDNRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new). "entry"
	self addElement: (BEROctetString new). "newrdn"
	self addElement: (BERBoolean new). "deleteoldrdn"

]

{ #category : #accessing }
LDAPModifyDNRequest >> newDn: aDn [
	elements second value: aDn
]

{ #category : #accessing }
LDAPModifyDNRequest >> newRdn: aRdn [
	elements second value: aRdn
]

{ #category : #accessing }
LDAPModifyDNRequest >> underDn: aDn [
	elements size < 4 ifTrue: [ elements addElement: LDAPPrimitive0String new ].
	elements fourth value: aDn
]

{ #category : #'as yet unclassified' }
LDAPModifyDNRequest >> wantToClearAttrs: aBoolean [
	elements third value: aBoolean
]
