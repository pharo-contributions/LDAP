Extension { #name : #LDAPConnection }

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adActivateUser: userDN [
	"NORMAL_ACCOUNT 0x200 + DONT_EXPIRE_PASSWORD 0x10000"

	^ self modify: userDN with: {(LDAPAttrModifier set: 'userAccountControl' to: {(16r10200 asString)})}
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adAddUser: userDN toGroup: groupDN [
	^ self modify: groupDN with: {(LDAPAttrModifier addTo: 'member' values: {userDN})}
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adCreateUser: userDN userPrincipalName: userPrincipalName accountName: accountName givenName: givenName surName: surName [
	| fullName attrs |
	fullName := '<1s> <2s>' expandMacrosWith: givenName with: surName.
	attrs := Dictionary new
		at: 'objectClass' put: #('top' 'person' 'organizationalPerson' 'user');
		at: 'displayName' put: fullName;
		at: 'givenName' put: givenName;
		at: 'name' put: fullName;
		at: 'sn' put: surName;
		at: 'sAMAccountName' put: accountName;
		at: 'userPrincipalName' put: userPrincipalName;
		at: 'pwdLastSet' put: '0';
		yourself.
	^ self addEntry: userDN attrs: attrs
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adDeActivateUser: userDN [
	"ACCOUNTDISABLE 0x0002 + NORMAL_ACCOUNT 0x200"

	^ self modify: userDN with: {(LDAPAttrModifier set: 'userAccountControl' to: {(16r202 asString)})}
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adDeleteUser: dn [
	^ self delEntry: dn
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adExists: dn [
	^ (self
		newSearch: dn
		scope: LDAPSearchScope wholeSubtree
		deref: LDAPSearchDerefAliases never
		filter: nil
		attrs: nil
		wantAttrsOnly: false) result notEmpty
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adSetPassword: userDN to: aString [
	| ops |
	ops := {(LDAPAttrModifier set: 'unicodePwd' to: {(aString asActiveDirectoryUnicodePassword)})}.
	^ self modify: userDN with: ops
]

{ #category : #'*ldap-activedirectory' }
LDAPConnection >> adUpdateUser: userDN givenName: givenName surName: surName email: emailAddress fullName: fullName [
	| ops |
	ops := {(LDAPAttrModifier set: 'displayName' to: {fullName}).
	(LDAPAttrModifier set: 'givenName' to: {givenName}).
	(LDAPAttrModifier set: 'sn' to: {surName}).
	(LDAPAttrModifier set: 'mail' to: {emailAddress})}.
	^ self modify: userDN with: ops
]
