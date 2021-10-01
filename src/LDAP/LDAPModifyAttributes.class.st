"
Pseudo BER sequence for attributes modification operations
"
Class {
	#name : #LDAPModifyAttributes,
	#superclass : #BERSequence,
	#category : #'LDAP-Elements'
}

{ #category : #accessing }
LDAPModifyAttributes >> attr [
	^ elements second description
]

{ #category : #accessing }
LDAPModifyAttributes >> attr: aString [
	elements second description: aString
]

{ #category : #initialization }
LDAPModifyAttributes >> initialize [ 
	super initialize.
	
	self addElement: (LDAPModifyOperation new).
	self addElement: (LDAPPartialAttribute new).

]

{ #category : #'instance creation' }
LDAPModifyAttributes >> operation: anEnumeratedElement [
	elements at: 1 put: anEnumeratedElement
]

{ #category : #printing }
LDAPModifyAttributes >> operationName [ 
	^ elements first name ifNil: [ 'unknown' ]
]

{ #category : #printing }
LDAPModifyAttributes >> printOn: aStream [

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
LDAPModifyAttributes >> values [
	^ elements second values
]

{ #category : #accessing }
LDAPModifyAttributes >> values: aCollection [
	elements second values: aCollection
]
