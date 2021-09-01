"
I am a string used to look anywhere in another string.
"
Class {
	#name : #LDAPAnySubstring,
	#superclass : #LDAPSubstring,
	#category : #'LDAP-ContextElements'
}

{ #category : #accessing }
LDAPAnySubstring class >> tagValue [
	^ 16r81 "Context 1"
]
