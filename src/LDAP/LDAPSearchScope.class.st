"
In a LDAP search, this element specifies the set of entries, relative to the entry specified as the baseObject, that may be returned.
"
Class {
	#name : #LDAPSearchScope,
	#superclass : #Object,
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
