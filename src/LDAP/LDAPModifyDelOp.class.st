"
Modify delete operation
"
Class {
	#name : #LDAPModifyDelOp,
	#superclass : #LDAPModifyOp,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPModifyDelOp class >> tagValue [
	^ 1
]
