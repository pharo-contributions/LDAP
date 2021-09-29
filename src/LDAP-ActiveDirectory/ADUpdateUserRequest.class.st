"
Request to update an user.

The request DN is the user DN.
"
Class {
	#name : #ADUpdateUserRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #accessing }
ADUpdateUserRequest >> email: aString [
	self addOperation: (LDAPAttrModifier set: 'mail' to: aString).

]

{ #category : #accessing }
ADUpdateUserRequest >> fullName: aString [
	self addOperation: (LDAPAttrModifier set: 'displayName' to: aString).

]

{ #category : #accessing }
ADUpdateUserRequest >> givenName: aString [
	self addOperation: (LDAPAttrModifier set: 'givenName' to: aString).

]

{ #category : #accessing }
ADUpdateUserRequest >> surName: aString [
	self addOperation: (LDAPAttrModifier set: 'sn' to: aString).

]
