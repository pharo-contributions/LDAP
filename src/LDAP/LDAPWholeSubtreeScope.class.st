"
The baseObject entry will be considered, as well as all of its subordinates to any depth.
"
Class {
	#name : #LDAPWholeSubtreeScope,
	#superclass : #LDAPSearchScope,
	#category : #'LDAP-Enumerated'
}

{ #category : #initialization }
LDAPWholeSubtreeScope >> initialize [ 
	super initialize.
	value := 2. "whole subtree"
]

{ #category : #accessing }
LDAPWholeSubtreeScope >> name [
	^ 'wholeSubtree'
]

{ #category : #accessing }
LDAPWholeSubtreeScope >> value: anInteger [
	^ self shouldNotImplement 
]
