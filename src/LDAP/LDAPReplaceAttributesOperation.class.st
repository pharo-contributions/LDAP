"
Replaces the entire attribute in the entry.
"
Class {
	#name : #LDAPReplaceAttributesOperation,
	#superclass : #LDAPModifyOperation,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPReplaceAttributesOperation >> initialize [ 
	super initialize.
	value := 2. "Replace"
]

{ #category : #accessing }
LDAPReplaceAttributesOperation >> name [
	^ 'replace'
]

{ #category : #accessing }
LDAPReplaceAttributesOperation >> value: anInteger [
	^ self shouldNotImplement 
]
