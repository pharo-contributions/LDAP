"
Request to activate an user.

The request DN is the user DN.
"
Class {
	#name : #ADActivateUserRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #initialization }
ADActivateUserRequest >> initialize [ 

	super initialize.
	self reset.
]

{ #category : #initialization }
ADActivateUserRequest >> reset [
	| op |
	"NORMAL_ACCOUNT 0x200 + DONT_EXPIRE_PASSWORD 0x10000"
	op := LDAPAttrModifier set: 'userAccountControl' to: {(16r10200 asString)}.
	self ops: {op}.
]
