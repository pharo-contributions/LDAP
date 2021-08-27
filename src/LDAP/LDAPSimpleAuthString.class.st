Class {
	#name : #LDAPSimpleAuthString,
	#superclass : #BEROctetString,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPSimpleAuthString class >> tagValue [
	^ 16r80 "Context 0"
]
