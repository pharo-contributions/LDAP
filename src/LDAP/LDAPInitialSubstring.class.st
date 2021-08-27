Class {
	#name : #LDAPInitialSubstring,
	#superclass : #LDAPSubstring,
	#category : #'LDAP-Substrings'
}

{ #category : #accessing }
LDAPInitialSubstring class >> tagValue [
	^ 16r80 "Context 0"
]
