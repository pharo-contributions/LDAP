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

{ #category : #'utilities - requests' }
LDAPEncoder class >> id: aMessageId request: aRequest [
	| stream mesg |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).
	mesg addElement: aRequest.

	mesg writeOn: stream.
	^ stream contents
]

{ #category : #'instance creation' }
LDAPEncoder class >> newFrom: aStream [
	| firstByte element elementClass |
	firstByte := aStream next.
	elementClass := self identifyIncomingElement: firstByte.
	elementClass ifNil: [
		LDAPException new messageText: 'invalid tag -- make sure class is in identifyIncomingElements'; signal ].
	element := elementClass new setTag: firstByte.
	element decode: aStream.
	^ element

]
