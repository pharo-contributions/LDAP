Class {
	#name : #BERTest,
	#superclass : #TestCase,
	#category : #'LDAP-Tests'
}

{ #category : #'as yet unclassified' }
BERTest class >> createLauncher [
	| b |
	b := SimpleButtonMorph new.
	b target: BERTest.
	b actionSelector: #testAll.
	b position: (World bounds bottomRight - (40 @ 40)).
	b label: 'Test'.
	b openInWorld.
]

{ #category : #'as yet unclassified' }
BERTest class >> getBooleanTestSet [
	^  {		{ 0 . '010100' }.
			{ 1 . '0101FF' }.
			{ 255 . '0101FF' }.
			{ 1000 . '0101FF' }.
			{ false . '010100' }.
			{ true . '0101FF' }.
		}.

]

{ #category : #'as yet unclassified' }
BERTest class >> getIntegerTestSet [
	^  {		{27066 .  '020269BA'}. 
			{-27066 .  '02029646'}.
			{72 .  '020148' }.
			{127  . '02017F'}.
			{-128. '020180'}.
			{128  . '02020080'}.
			{ 0 . '020100' }.
			{ 256  .  '02020100'}.
			{4294967290  . '020500FFFFFFFA'}.
			{ 1  . '020101'}.
			{-1 . '0201FF'}.
			{ -129  . '0202FF7F'}.
		}.

]

{ #category : #'as yet unclassified' }
BERTest class >> isAbstract [
	^ false
]

{ #category : #'as yet unclassified' }
BERTest class >> testAll [
	| b |
	b := BERTest new.
	
	b 
		testIntegerEncoding;
		testOctetStringEncoding;
		testSequenceEncoding;
		testBooleanEncoding;
		testIntegerDecoding;
		testAddRequest;
		testBindRequest;
		testDelRequest;
		testModifyRequest;
		testSearchRequest
]

{ #category : #'as yet unclassified' }
BERTest >> testAddRequest [
	| encoded attrs |
	attrs := Dictionary new.
	attrs at: 'objectClass' put: (OrderedCollection new addLast: 'person'; yourself).
	attrs at: 'cn' put: (OrderedCollection new addLast: 'test2'; yourself).
	attrs at: 'sn' put: (OrderedCollection new addLast: 'test2'; yourself).

	encoded := LDAPEncoder addRequest: 1 dn: 'cn=test2,dc=linalco,dc=test' attrs: attrs.
	encoded := encoded asString asHex.

	Transcript show: 'testAddRequest got: ', encoded; cr; show: '-'; cr.
	self assert: (encoded = '305B0201016856041B636E3D74657374322C64633D6C696E616C636F2C64633D7465737430373017040B6F626A656374436C61737331080406706572736F6E300D0402636E310704057465737432300D0402736E310704057465737432')

]

{ #category : #'as yet unclassified' }
BERTest >> testBindRequest [
	| encoded |
	encoded := LDAPEncoder bindRequest: 1 username: 'cn=admin,dc=linalco,dc=test' credentials: 'secret' method: nil.
	encoded := encoded asString asHex.

	Transcript show: 'testBindRequest got: ', encoded; cr.
	self assert: (encoded = '302D0201016028020103041B636E3D61646D696E2C64633D6C696E616C636F2C64633D746573748006736563726574')

]

{ #category : #'as yet unclassified' }
BERTest >> testBooleanEncoding [
	|ber stream tests output |
	ber := BERBoolean new.
	stream := ReadWriteStream on: (String new).

	tests :=  self class getBooleanTestSet.
	tests do: [:test | 
		stream resetToStart.
		ber value: (test at: 1).	
		ber writeOn: stream.
		output :=  stream contents asString asHex.
		Transcript show: 'Expected: ', (test at: 2), ' Got: ', output; cr.
		self assert: (output = (test at: 2)) ]
	
	
]

{ #category : #'as yet unclassified' }
BERTest >> testDelRequest [
	| encoded |
	encoded := LDAPEncoder delRequest: 1 dn: 'cn=test2,dc=linalco,dc=test'.
	encoded := encoded asString asHex.

	Transcript show: 'testDelRequest got: ', encoded; cr; show: '-'; cr.
	self assert: (encoded = '30200201014A1B636E3D74657374322C64633D6C696E616C636F2C64633D74657374')

]

{ #category : #'as yet unclassified' }
BERTest >> testIntegerDecoding [
	|ber stream tests value valueStream byte |
	stream := ReadWriteStream on: (String new).

	tests :=  self class getIntegerTestSet.
	tests do: [:test | 
		valueStream := ReadStream on: (test at: 2).
		value := test at: 1.
		stream resetToStart.
		
		[valueStream atEnd] whileFalse: [
			byte := (valueStream next digitValue * 16).
			byte := byte + valueStream next digitValue.
			stream nextPut: (byte asCharacter) ].
		
		stream reset.
		ber := BERInteger newFrom: stream.
		self assert: (ber class = BERInteger).
		
		Transcript show: 'Expected: ', (value asString), ' Got: ', (ber value asString); cr.
		self assert: (ber value = value ) 
	]

]

{ #category : #'as yet unclassified' }
BERTest >> testIntegerEncoding [
	|ber stream tests output |
	ber := BERInteger new.
	stream := ReadWriteStream on: (String new).

	tests :=  self class getIntegerTestSet.
	tests do: [:test | 
		stream resetToStart.
		ber value: (test at: 1).	
		ber writeOn: stream.
		output :=  stream contents asString asHex.
		Transcript show: 'Expected: ', (test at: 2), ' Got: ', output; cr.
		self assert: (output = (test at: 2)) ]
	
	
]

{ #category : #'as yet unclassified' }
BERTest >> testModifyRequest [
	| encoded ops |
	ops :=  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.
									
	encoded := LDAPEncoder modifyRequest: 1 dn: 'cn=test5,dc=linalco,dc=test' ops: ops.
	encoded := encoded asString asHex.

	Transcript show: 'testModifyRequest got: ', encoded; cr."
	self assert: (encoded = '3062020101665D041B636E3D74657374352C64633D6C696E616C636F2C64633D74657374303E301E0A010230190402736E311304077465737435736E0403666F6F0403626172301C0A01003017040B6465736372697074696F6E3108040672636875656F')
"
]

{ #category : #'as yet unclassified' }
BERTest >> testOctetStringEncoding [
	|ber stream tests|
	ber := BEROctetString new.
	stream := ReadWriteStream on: (String new).

	tests := {	{ 'hello' . 5 . '040568656C6C6F' } }.

	tests do: [:test | 
		stream resetToStart.
		ber value: (test at: 1).	
		ber writeOn: stream.
		self assert: (stream contents asString asHex = (test at: 3)) ]
	
	
]

{ #category : #'as yet unclassified' }
BERTest >> testSearchRequest [
	| encoded |
	encoded := LDAPEncoder searchRequest: 1 base: 'dc=linalco, dc=test' scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'objectclass' ) attrs: (OrderedCollection new) wantAttrsOnly: false.
	encoded := encoded asString asHex.

	Transcript show: 'testSearchRequest got: ', encoded; cr.
	self assert: (encoded = '30380201016333041364633D6C696E616C636F2C2064633D746573740A01020A0100020100020100010100870B6F626A656374636C6173733000')

]

{ #category : #'as yet unclassified' }
BERTest >> testSequenceEncoding [
	|ber0 ber1 ber2 stream|
	ber0 := BERSequence new.
	ber1 := BERInteger new value: 17.
	ber2 := BERInteger new value: 170.
	
	ber0 addElement: ber1.
	ber0 addElement: ber2.
	stream := ReadWriteStream on: (String new).

	ber0 writeOn: stream.
	self assert: (stream contents asString asHex = '3007020111020200AA') 


]
