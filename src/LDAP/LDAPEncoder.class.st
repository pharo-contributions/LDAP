"
LDAPEncoder encodes LDAP requests in BER format.
"
Class {
	#name : #LDAPEncoder,
	#superclass : #Object,
	#category : #'LDAP-Core'
}

{ #category : #'utilities - requests' }
LDAPEncoder class >> abandonRequest: aMessageId abandonId: abandonId [
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERInteger new value: abandonId.
	
	mesg addElement: (req tagSetApplication) withTag: 16.
	mesg writeOn: stream.
		
	^ stream contents
]

{ #category : #'utilities - requests' }
LDAPEncoder class >> addRequest: aMessageId dn: aDN attrs: someAttrs [
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new.
	req addElement: (BEROctetString new value: aDN).
	req addElement: (self attrsAsBERElement: someAttrs).
	
	mesg addElement: (req tagSetApplication) withTag: 8.
	mesg writeOn: stream.
		
	^ stream contents
]

{ #category : #'utilities - attributes' }
LDAPEncoder class >> attrAsBERElement: anAttrAsAssociation [
	| ber berAttrVals key |
	ber := BERSequence new.
	key := anAttrAsAssociation key.
	ber addElement: (BEROctetString new value: key).
	berAttrVals := BERSet new.
	(anAttrAsAssociation value) do: [ :eachVal |
		berAttrVals addElement: (BEROctetString new value: (eachVal utf8Encoded asString)) ].
	ber addElement: berAttrVals.
	^ ber
]

{ #category : #'utilities - attributes' }
LDAPEncoder class >> attrsAsBERElement: someAttrs [
	| ber |
	ber := BERSequence new.
	someAttrs associationsDo: [ :eachAttr |
		ber addElement: (self attrAsBERElement: eachAttr) ].
	^ ber
	
]

{ #category : #'utilities - requests' }
LDAPEncoder class >> bindRequest: aMessageId username: aUsername credentials: aPassword method: anAuthMethod [
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new tagSetApplication.
	req addElement: (BERInteger new value: 3).
	req addElement: (BEROctetString new value: aUsername).
	req addElement: (BEROctetString new tagSetContext;  value: aPassword) withTag: 0.

	mesg addElement: req withTag: 0.
	mesg writeOn: stream.
		
	^ stream contents
]

{ #category : #'utilities - requests' }
LDAPEncoder class >> compareRequest: aMessageId dn: aDN comparing: anEqualityFilter [
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new.
	req 
		addElement: (BEROctetString new value: aDN);
		addElement: (anEqualityFilter asBERElement).
	
	mesg addElement: (req tagSetApplication) withTag: 14.
	mesg writeOn: stream.
		
	^ stream contents
]

{ #category : #'utilities - requests' }
LDAPEncoder class >> delRequest: aMessageId dn: aDN [
	| stream mesg req |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BEROctetString new value: aDN.
	
	mesg addElement: (req tagSetApplication) withTag: 10.
	mesg writeOn: stream.
		
	^ stream contents
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

{ #category : #'utilities - requests' }
LDAPEncoder class >> modifyRequest: aMessageId dn: aDN ops: someModifyingOps [
	| stream mesg req ops |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	req := BERSequence new.
	req addElement: (BEROctetString new value: aDN).
	ops := BERSequence new.
	someModifyingOps do: [ :each | ops addElement: each asBERElement ].
	req addElement: ops.
	
	mesg addElement: (req tagSetApplication) withTag: 6.
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

{ #category : #'utilities - requests' }
LDAPEncoder class >> unbindRequest: aMessageId [
	| stream mesg |
	stream := ReadWriteStream on: (String new).

	mesg := BERSequence new.
	mesg addElement: (BERInteger new value: aMessageId).

	mesg addElement: (BERNull new tagSetApplication) withTag: 2.

	mesg writeOn: stream.
		
	^ stream contents
]
