"
Do not be surprised if any of the tests fails, their state is rather crude, mostly due to the heavy volatility of the API.

This test expects a single entry in the tree:
```language=ldif
		dn: dc=linalco, dc=test
		dc: linalco
		objectClass: dcObject
		objectClass: organization
		o: linalco
```

"
Class {
	#name : #LDAPTest,
	#superclass : #TestCase,
	#category : #'LDAP-Tests'
}

{ #category : #'accessing - defaults' }
LDAPTest class >> baseDN [
	^ 'dc=linalco,dc=test'
]

{ #category : #'accessing - defaults' }
LDAPTest class >> bindDN [
	^ self cn: 'admin'
]

{ #category : #'accessing - defaults' }
LDAPTest class >> cn: aString [
	^ String streamContents: [ :s | s << 'cn=' << aString << ',' << self baseDN ]
]

{ #category : #'accessing - defaults' }
LDAPTest class >> hostname [
	^ '127.0.0.1'
]

{ #category : #'accessing - defaults' }
LDAPTest class >> password [
	^ 'secret'
]

{ #category : #'accessing - defaults' }
LDAPTest class >> port [
	^ 389
]

{ #category : #tests }
LDAPTest class >> testCns [
	^ (1 to: 5) collect:[ :i | String streamContents: [ :s | s << 'test' << i asString ] ]
]

{ #category : #utilities }
LDAPTest >> checkSearchResults: aResult expecting: expectedRDNs [
	aResult size  < expectedRDNs size
		ifTrue: [ ^ false ].
	
	^ expectedRDNs allSatisfy: [:eachExpected | | qualified |
		qualified := eachExpected
			ifNil: [ self class baseDN ]
			ifNotNil: [ eachExpected, ',', self class baseDN ].
		aResult anySatisfy: [ :eachResult | eachResult matchedDN = qualified ]
	]
]

{ #category : #connecting }
LDAPTest >> connect [
	| req conn |
	conn := LDAPConnection to: self class hostname port: self class port.
	req := conn request: (LDAPBindRequest new username: self class bindDN; password: self class password).
	req wait.
	^ conn


]

{ #category : #tests }
LDAPTest >> test00_Bind [
	| conn |
	conn := self connect.
	conn disconnect.
]

{ #category : #tests }
LDAPTest >> test01_AddWithStringValues [
	| conn req attrs |
	conn := self connect.
	
	self class testCns do: [ :name|
		attrs := Dictionary new
			at: 'objectClass' put: 'person';
			at: 'cn' put: name;
			at: 'sn' put: name;
			yourself.
		
		req := conn request: (LDAPAddRequest new dn: (self class cn: name); attrs: attrs).
		req wait.
	]
]

{ #category : #tests }
LDAPTest >> test02_Search [
	| conn search req rr |
	conn := self connect.
	
	search := LDAPSearchRequest new 
		base: self class baseDN; 
		scope: LDAPSearchScope wholeSubtree; 
		derefAliases: LDAPSearchDerefAliases never.
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' } ).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> test03_SearchWithNext [
	| conn req rr r search |
	conn := self connect.
	
	search := LDAPSearchRequest new 
		base: self class baseDN; 
		scope: LDAPSearchScope wholeSubtree; 
		derefAliases: LDAPSearchDerefAliases never.
	req := conn request: search.
	rr := OrderedCollection new.
	[(r := req next) isNil ] whileFalse: [rr add: r ].
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> test04_SearchWithFilters [
	| conn req rr search |
	conn := self connect.
	
	search := LDAPSearchRequest new 
		base: self class baseDN; 
		scope: LDAPSearchScope wholeSubtree; 
		derefAliases: LDAPSearchDerefAliases never;
		filter: (LDAPFilter with: 'objectclass').
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	search filter: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')).
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter andOf: (OrderedCollection new
						add: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')); 
						add: (LDAPFilter not: (LDAPFilter with: 'sn' equalTo: 'test2'));
						yourself )).
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> test04bis_SearchWithFilters [
	| conn req rr search |
	conn := self connect.
	
	search := LDAPSearchRequest new 
		base: self class baseDN; 
		scope: LDAPSearchScope wholeSubtree; 
		derefAliases: LDAPSearchDerefAliases never;
		filter: (LDAPFilter with: 'objectclass').
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1') not.
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: ((LDAPFilter with: 'cn' equalTo: 'test1') not &
						(LDAPFilter with: 'sn' equalTo: 'test2') not).
	req := conn request: search.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> test05_Delete [
	| conn req |
	conn := self connect.
	
	self class testCns do: [ :name| | del |
		del := LDAPDelRequest new dn: (self class cn: name).
		req := conn request: del.
		req wait.
	].

	conn disconnect
]

{ #category : #tests }
LDAPTest >> test06_DoubleBind [
	| conn req bind |
	conn := self connect.
	bind := LDAPBindRequest new username: self class bindDN; password: self class password.
	req := conn request: bind.
	req wait.
	conn disconnect.
]

{ #category : #tests }
LDAPTest >> test07_AddWithCollectionValues [
	| conn req attrs |
	conn := self connect.
	
	self class testCns do: [ :name| | add |
		attrs := Dictionary new
			at: 'objectClass' put: (OrderedCollection new add: 'person'; yourself);
			at: 'cn' put: (OrderedCollection new add: name; yourself);
			at: 'sn' put: (OrderedCollection new add: name; yourself);
			yourself.
		
		add := LDAPAddRequest new dn: (self class cn: name); attrs: attrs.
		req := conn request: add.
		req wait.
	]
]

{ #category : #tests }
LDAPTest >> test08_Compare [
	| conn req compare |
	conn := self connect.

	compare := LDAPCompareRequest new 
		dn: (self class cn: 'test1'); 
		comparing: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: compare.
	req wait.
	self assert: (req result).

	compare := LDAPCompareRequest new 
		dn: (self class cn: 'test1'); 
		comparing: (LDAPFilter with: 'cn' equalTo: 'test2').
	req := conn request: compare.
	req wait.
	self deny: (req result).

	conn disconnect.
]

{ #category : #tests }
LDAPTest >> test09_Modify [
	| conn req rr ops search mod |
	conn := self connect.
	
	search := LDAPSearchRequest new 
		base: self class baseDN; 
		scope: LDAPSearchScope wholeSubtree; 
		derefAliases: LDAPSearchDerefAliases never;
		filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	req wait.
	rr := req responses first.
	
	ops :=  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.

	mod := LDAPModifyRequest new dn: (rr matchedDN); ops: ops.
	req := conn request: mod.
	req wait.
	
	req := conn request: (LDAPCompareRequest new dn: (self class cn: 'test1'); comparing: (LDAPFilter with: 'sn' equalTo: 'test5sn')).
	req wait.
	self assert: (req result).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> test10_Delete [
	| conn req |
	conn := self connect.
	
	self class testCns do: [ :name| | del |
		del := LDAPDelRequest new dn: (self class cn: name).
		req := conn request: del.
		req wait.
	].

	conn disconnect
]

{ #category : #tests }
LDAPTest >> testMessage [
	| message id dn code result seq encoded |
	seq := BERSequence new.
	id := BERInteger new value: 2.
	seq addElement: id.
	result := LDAPBindResult new.
	code := BEREnumerated new value: 0.
	result addElement: code.
	dn := BEROctetString new value: self class bindDN.
	result addElement: dn.
	seq addElement: result.
	encoded := ByteString streamContents: [ :s | seq writeOn: s ].
	
	message := LDAPMessage newFrom: encoded readStream.
	self assert: message id equals: 2.
	self assert: message response resultCode equals: 0.
	self assert: message response matchedDN equals: self class bindDN.
]
