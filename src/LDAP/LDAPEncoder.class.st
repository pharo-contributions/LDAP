"
LDAPEncoder encodes LDAP requests in BER format.
"
Class {
	#name : #LDAPEncoder,
	#superclass : #Object,
	#category : #'LDAP-Core'
}

{ #category : #converting }
LDAPEncoder class >> attributeDescription: aString andValues: aCollectionOfStrings [
"Convert an attribute to a BERElement"
	| ber values |
	ber := BERSequence new.
	ber addElement: (BEROctetString new value: aString).
	values := BERSet new.
	aCollectionOfStrings do: [ :eachVal |
		values addElement: (BEROctetString new value: eachVal) ].
	ber addElement: values.
	^ ber
]

{ #category : #'utilities - attributes' }
LDAPEncoder class >> attrsAsBERElement: aDictionary [
	| ber |
	ber := BERSequence new.
	aDictionary associationsDo: [ :a | ber addElement: (self attributeDescription: a key andValues: a value) ].
	^ ber
]
