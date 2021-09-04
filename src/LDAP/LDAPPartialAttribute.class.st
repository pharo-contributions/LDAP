"
I am a pseudo BERElement representing an attribute and its values.

I am not a real BER element because I don't have a specific tag and cannot be created from a stream. I am here to help encoding LDAP messages.
My name implies I can be empty.

From RFC4511:
 Attributes and partial attributes consist of an attribute description
   and attribute values.  A PartialAttribute allows zero values, while
   Attribute requires at least one value.
"
Class {
	#name : #LDAPPartialAttribute,
	#superclass : #BERSequence,
	#category : #'LDAP-Elements'
}

{ #category : #adding }
LDAPPartialAttribute >> addValue: aString [
	elements second addElement: (BEROctetString new value: aString).
]

{ #category : #accessing }
LDAPPartialAttribute >> description [
	^ elements first value
]

{ #category : #accessing }
LDAPPartialAttribute >> description: aString [ 
	elements first value: aString
]

{ #category : #initialization }
LDAPPartialAttribute >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new). "type"
	self addElement: (BERSet new). "vals"

]

{ #category : #accessing }
LDAPPartialAttribute >> values [
	| berStrings |
	berStrings := elements second value.
	^ berStrings collect: #value

]

{ #category : #accessing }
LDAPPartialAttribute >> values: aCollectionOfStrings [
	elements at: 2 put: BERSet new.
	aCollectionOfStrings isString 
		ifTrue: [ self addValue: aCollectionOfStrings ] 
		ifFalse: [ aCollectionOfStrings do: [ :eachVal | self addValue: eachVal ] ].

]
