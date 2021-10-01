"
Request to create a new user.

Request DN is the user DN.
"
Class {
	#name : #ADCreateUserRequest,
	#superclass : #LDAPAddRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #accessing }
ADCreateUserRequest >> accountName: accountName [
	self at: 'sAMAccountName' put: accountName.
]

{ #category : #accessing }
ADCreateUserRequest >> givenName: aString [
	self at: 'givenName' put: aString.
	self updateFullName.
]

{ #category : #initialization }
ADCreateUserRequest >> initialize [ 

	super initialize.
	self reset.
]

{ #category : #initialization }
ADCreateUserRequest >> reset [
	self removeAll.
	self at: 'objectClass' put: #('top' 'person' 'organizationalPerson' 'user').
	self at: 'pwdLastSet' put: '0'.
]

{ #category : #accessing }
ADCreateUserRequest >> surName: aString [
	self at: 'sn' put: aString.
	self updateFullName.
]

{ #category : #private }
ADCreateUserRequest >> updateFullName [
	| fullName attrs givenName surName |
	attrs := elements second values.
	givenName := self at: 'givenName' ifPresent: [ :pa | pa values first ] ifAbsent: [ '' ].
	surName := self at: 'sn' ifPresent: [ :pa | pa values first ] ifAbsent: [ '' ].
	fullName := '<1s> <2s>' expandMacrosWith: givenName with: surName.
	self at: 'displayName' put: fullName.
	self at: 'name' put: fullName.

]

{ #category : #accessing }
ADCreateUserRequest >> userPrincipalName: userPrincipalName [
	self at: 'userPrincipalName' put: userPrincipalName.
]
