"
Removes one or more attribute values from an entry. 
"
Class {
	#name : #LDAPDeleteAttributesOperation,
	#superclass : #LDAPModifyOperation,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPDeleteAttributesOperation >> initialize [ 
	super initialize.
	value := 1. "Delete"
]

{ #category : #accessing }
LDAPDeleteAttributesOperation >> name [
	^ 'delete'
]

{ #category : #accessing }
LDAPDeleteAttributesOperation >> value: anInteger [
	^ self shouldNotImplement 
]
