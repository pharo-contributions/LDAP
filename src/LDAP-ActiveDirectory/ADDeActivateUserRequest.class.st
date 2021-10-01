"
Request to deactivate an user.

The request DN is the user DN.
"
Class {
	#name : #ADDeActivateUserRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #initialization }
ADDeActivateUserRequest >> initialize [ 

	super initialize.
	self reset.
]

{ #category : #initialization }
ADDeActivateUserRequest >> reset [
	| op |
	"ACCOUNTDISABLE 0x0002 + NORMAL_ACCOUNT 0x200"
	op := LDAPAttrModifier set: 'userAccountControl' to: {(16r202 asString)}.
	self ops: {op}.
]
