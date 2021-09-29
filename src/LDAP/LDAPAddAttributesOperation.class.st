"
Adds one or more attribute values to an entry.
"
Class {
	#name : #LDAPAddAttributesOperation,
	#superclass : #LDAPModifyOperation,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPAddAttributesOperation >> initialize [ 
	super initialize.
	value := 0. "Add"
]

{ #category : #accessing }
LDAPAddAttributesOperation >> name [
	^ 'add'
]

{ #category : #accessing }
LDAPAddAttributesOperation >> value: anInteger [
	^ self shouldNotImplement 
]
