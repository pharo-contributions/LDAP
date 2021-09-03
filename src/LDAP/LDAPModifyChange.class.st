"
Pseudo BER sequence for modification operations
"
Class {
	#name : #LDAPModifyChange,
	#superclass : #BERSequence,
	#category : #'LDAP-Elements'
}

{ #category : #accessing }
LDAPModifyChange >> attr [
	^ elements second description
]

{ #category : #accessing }
LDAPModifyChange >> attr: aString [
	elements second description: aString
]

{ #category : #initialization }
LDAPModifyChange >> initialize [ 
	super initialize.
	
	self addElement: (LDAPModifyOperation new).
	self addElement: (LDAPPartialAttribute new).

]

{ #category : #'instance creation' }
LDAPModifyChange >> operation: anInteger [
	elements first value: anInteger 
]

{ #category : #printing }
LDAPModifyChange >> operationName [ 
	| operation |
	operation := elements first value.
	operation = 0 ifTrue: [ ^ 'add' ].
	operation = 1 ifTrue: [ ^ 'delete' ].
	operation = 2 ifTrue: [ ^ 'replace' ].
	^ 'unknown'.
]

{ #category : #printing }
LDAPModifyChange >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: ' ';
		nextPutAll: self operationName;
		nextPutAll: '(';
		nextPutAll: self attr;
		nextPutAll: ': '.
	self values printElementsOn: aStream.
	aStream	nextPutAll: ')'
]

{ #category : #accessing }
LDAPModifyChange >> values [
	^ elements second values
]

{ #category : #accessing }
LDAPModifyChange >> values: aCollection [
	elements second values: aCollection
]
