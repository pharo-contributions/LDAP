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

{ #category : #'utilities - requests' }
LDAPEncoder class >> modifyDNRequest: aMessageId dn: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs [ 
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new.
	req 
		addElement: (BEROctetString new value: aDN);
		addElement: (BEROctetString new value: aRDN);
		addElement: (BERBoolean new value: aWantsToClearAttrs).
	aUnderDN ifNotNil: [
		req addElement: (BEROctetString new value: aUnderDN) withTag: 0 ].
	
	mesg addElement: (req tagSetApplication) withTag: 12.
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

{ #category : #'utilities - requests' }
LDAPEncoder class >> searchRequest: aMessageId base: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly [
	| stream mesg req attrsSeq |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new tagSetApplication.
	
	req
		addElement: (BEROctetString new value: aBase);
		addElement: (BEREnumerated new value: aSearchScope);
		addElement: (BEREnumerated new value: aDerefBehaviour);
		addElement: (BERInteger new value: 0); "sizelimit"
		addElement: (BERInteger new value: 0); "timelimit"
		addElement: (BERBoolean new value: wantsAttrsOnly);
		addElement: 
			(aFilter asBERElement) tagSetContext withTag: (aFilter class tagValue).

	attrsSeq := BERSequence new.
	someAttrs do: [ :each |
		attrsSeq addElement: (BEROctetString new value: each) ].
	req addElement: attrsSeq.

	mesg addElement: req withTag: 3.
	mesg writeOn: stream.

	^ stream contents
	
]
