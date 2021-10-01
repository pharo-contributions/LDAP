"
Filter for Approximation
"
Class {
	#name : #LDAPFilterApprox,
	#superclass : #LDAPFilterWithValueAssertion,
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterApprox class >> tagValue [
	^ 16rA8 "Context 8"
]
