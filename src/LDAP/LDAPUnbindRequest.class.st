"
LDAPUnbindRequest is the process to disconnect the client of the LDAP directory.
"
Class {
	#name : #LDAPUnbindRequest,
	#superclass : #BERNull,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPUnbindRequest class >> tagValue [
	^ 16r42 "Application 2"
]
