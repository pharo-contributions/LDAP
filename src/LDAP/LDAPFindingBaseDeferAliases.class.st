"
The server should only dereference the entry specified by the baseObject element of the request.
"
Class {
	#name : #LDAPFindingBaseDeferAliases,
	#superclass : #LDAPSearchDerefAliases,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPFindingBaseDeferAliases >> initialize [ 
	super initialize.
	value := 2. "finding base object"
]

{ #category : #accessing }
LDAPFindingBaseDeferAliases >> name [
	^ 'derefFindingBaseObj'
]

{ #category : #accessing }
LDAPFindingBaseDeferAliases >> value: anInteger [
	^ self shouldNotImplement 
]
