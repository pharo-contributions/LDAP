"
Enumerated value to represent the change for a modify attributes request.

The change types defined in RFC 4511 (in the operation enumerated element of a change sequence) are:
- add
- delete
- replace
"
Class {
	#name : #LDAPModifyOperation,
	#superclass : #BEREnumerated,
	#category : #'LDAP-Enumerated'
}

{ #category : #accessing }
LDAPModifyOperation >> name [
	^ nil
]

{ #category : #printing }
LDAPModifyOperation >> printOn: aStream [
	| name |
	name := self name ifNil: [ ^ super printOn: aStream ].
	aStream
		nextPutAll: name;
		nextPutAll: ' (';
		nextPutAll: self value asString;
		nextPutAll: ')'.

]
