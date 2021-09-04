"
An optional sequence element that, if present, will contain one or more URIs that the client may use to re-try processing the operation somewhere else.
"
Class {
	#name : #LDAPReferral,
	#superclass : #BERSequence,
	#category : #'LDAP-ContextElements'
}

{ #category : #accessing }
LDAPReferral class >> tagValue [
	^ 16rA3 "Context constructed 3"
]
