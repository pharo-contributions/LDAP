"
I implement the message processResult: on LDAP requests types.


"
Trait {
	#name : #TLDAPReturnResult,
	#category : #'LDAP-Requests'
}

{ #category : #testing }
TLDAPReturnResult >> processResult: aCollection [
"For basi requests, there is only one response."
	| result |
	result := aCollection last.
	result checkForExceptions.
	^ result success
]
