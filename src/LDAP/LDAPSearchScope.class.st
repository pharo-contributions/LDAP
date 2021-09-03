"
In a LDAP search, this element specifies the set of entries, relative to the entry specified as the baseObject, that may be returned.
"
Class {
	#name : #LDAPSearchScope,
	#superclass : #BEREnumerated,
	#category : #'LDAP-Enumerated'
}

{ #category : #'search scope constants' }
LDAPSearchScope class >> baseObject [ 
	^ 0
]

{ #category : #'search scope constants' }
LDAPSearchScope class >> singleLevel [  
	^ 1
]

{ #category : #'search scope constants' }
LDAPSearchScope class >> wholeSubtree [   
	^ 2
]

{ #category : #printing }
LDAPSearchScope >> printOn: aStream [
	self value = 0 ifTrue: [ ^ aStream nextPutAll: 'baseObject (0)' ].
	self value = 1 ifTrue: [ ^ aStream nextPutAll: 'singleLevel (1)' ].
	self value = 2 ifTrue: [ ^ aStream nextPutAll: 'wholeSubtree (2)' ].
	^ super printOn: aStream	
]
