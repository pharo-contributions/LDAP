"
Request to add a user DN to a group.

The request DN is the group DN.
"
Class {
	#name : #ADGroupAddUserRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #adding }
ADGroupAddUserRequest >> addUser: userDN [
	^ self addUsers: { userDN }
]

{ #category : #adding }
ADGroupAddUserRequest >> addUsers: aCollectionOfStrings [
	| op |
	op := LDAPAttrModifier addTo: 'member' values: aCollectionOfStrings.
	self ops: {op}
]
