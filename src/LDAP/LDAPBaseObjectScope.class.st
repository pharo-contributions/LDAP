"
Only the entry whose DN is provided in the baseObject element of the request will be considered.

None of its subordinates will be examined.
"
Class {
	#name : #LDAPBaseObjectScope,
	#superclass : #LDAPSearchScope,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPBaseObjectScope >> initialize [ 
	super initialize.
	value := 0. "base object"
]

{ #category : #accessing }
LDAPBaseObjectScope >> name [
	^ 'baseObject'
]

{ #category : #accessing }
LDAPBaseObjectScope >> value: anInteger [
	^ self shouldNotImplement 
]
