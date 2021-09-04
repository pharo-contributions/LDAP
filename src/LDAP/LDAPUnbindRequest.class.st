"
LDAPUnbindRequest is the process to disconnect the client of the LDAP directory.
"
Class {
	#name : #LDAPUnbindRequest,
	#superclass : #BERNull,
	#traits : 'TLDAPReturnResult',
	#classTraits : 'TLDAPReturnResult classTrait',
	#category : #'LDAP-Requests'
}

{ #category : #accessing }
LDAPUnbindRequest class >> tagValue [
	^ 16r42 "Application 2"
]
