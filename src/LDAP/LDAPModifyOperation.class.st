Class {
	#name : #LDAPModifyOperation,
	#superclass : #BEREnumerated,
	#category : #'LDAP-Enumerated'
}

{ #category : #printing }
LDAPModifyOperation >> printOn: aStream [
	self value = 0 ifTrue: [ ^ aStream nextPutAll: 'add (0)' ].
	self value = 1 ifTrue: [ ^ aStream nextPutAll: 'delete (1)' ].
	self value = 2 ifTrue: [ ^ aStream nextPutAll: 'replace (2)' ].
	^ super printOn: aStream	
]
