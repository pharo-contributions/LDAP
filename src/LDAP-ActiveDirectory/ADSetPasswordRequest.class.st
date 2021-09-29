"
Request to reset a password.

The request DN is the user DN.
"
Class {
	#name : #ADSetPasswordRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #accessing }
ADSetPasswordRequest >> password: aString [
	| op |
	op := LDAPAttrModifier set: 'unicodePwd' to: {(aString asActiveDirectoryUnicodePassword)}.
	self ops: {op}.

]
