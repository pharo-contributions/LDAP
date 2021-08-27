"
Do not be surprised if any of the tests fails, their state is rather crude, mostly due to the heavy volatility of the API.
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
	^ 'cn=admin, ',self baseDN
]

{ #category : #'accessing - defaults' }
LDAPTest class >> hostname [
	^ '127.0.0.1'
]

{ #category : #'accessing - defaults' }
LDAPTest class >> newSuite [
	| obj |
	obj := TestSuite named: 'LDAP'.
	obj addTest: (LDAPTest selector: #testSearch).
	^ obj
	
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
LDAPTest class >> testAll [
	"This test expects a single entry in the tree:
		dn: dc=linalco, dc=test
		dc: linalco
		objectClass: dcObject
		objectClass: organization
		o: linalco"

	| l |
	l := LDAPTest new.

	l 
		testDoubleBind;
		testAddWithCollectionValues;
		testSearch;
		testSearchWithNext;
		testSearchWithFilters;
		testDel;
		testAddWithStringValues;
		testSearch;
		testCompare;
		testModify;
		testSearch;
		testDel.
]

{ #category : #utilities }
LDAPTest >> checkSearchResults: aResult expecting: expectedRDNs [
	aResult size  < expectedRDNs size
		ifTrue: [ ^ false ].
	
	expectedRDNs do: [:eachExpected | | qualified isPresent |
		eachExpected
			ifNil: [ qualified := self class baseDN ]
			ifNotNil: [ qualified := eachExpected, ',', self class baseDN ].
		isPresent := false.
		aResult do: [ :eachResult |
			eachResult dn = qualified
				ifTrue: [ isPresent := true ]  ].
		isPresent ifFalse: [^ false].
	].
	^ true
]

{ #category : #connecting }
LDAPTest >> connect [
	| req conn |
	conn := LDAPConnection to: self class hostname port: self class port.
	req := conn bindAs: self class bindDN credentials: self class password.
	req wait.
	^ conn


]

{ #category : #tests }
LDAPTest >> testAddWithCollectionValues [
	| conn req attrs |
	conn := self connect.
	
	(1 to: 5) do: [ :each | |name|
		name := 'test', each asString.
	
		attrs := Dictionary new
			at: 'objectClass' put: (OrderedCollection new add: 'person'; yourself);
			at: 'cn' put: (OrderedCollection new add: name; yourself);
			at: 'sn' put: (OrderedCollection new add: name; yourself);
			yourself.
		
		req := conn addEntry: 'cn=',name,',', self class baseDN attrs: attrs.
		req wait.
	]
]

{ #category : #tests }
LDAPTest >> testAddWithStringValues [
	| conn req attrs |
	conn := self connect.
	
	(1 to: 5) do: [ :each | |name|
		name := 'test', each asString.
	
		attrs := Dictionary new
			at: 'objectClass' put: 'person';
			at: 'cn' put: name;
			at: 'sn' put: name;
			yourself.
		
		req := conn addEntry: 'cn=',name,',', self class baseDN attrs: attrs.
		req wait.
	]
]

{ #category : #tests }
LDAPTest >> testBind [
	| conn |
	conn := self connect.
	conn disconnect.
]

{ #category : #tests }
LDAPTest >> testCompare [
	| conn req |
	conn := self connect.

	req :=conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new description: 'cn'; value: 'test1').
	req wait.
	self assert: (req result).

	req :=conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new description: 'cn'; value: 'test2').
	req wait.
	self deny: (req result).

	conn disconnect.
]

{ #category : #tests }
LDAPTest >> testDel [
	| conn req |
	conn := self connect.
	
	(1 to: 5) do: [ :each | |name|
		name := 'test', each asString.
		req := conn delEntry: 'cn=',name,',', self class baseDN.
		req wait.
	].

	conn disconnect
]

{ #category : #tests }
LDAPTest >> testDoubleBind [
	| conn req |
	conn := self connect.
	req := conn bindAs: self class bindDN credentials: self class password.
	req wait.
	conn disconnect.
]

{ #category : #tests }
LDAPTest >> testModify [
	| conn req rr ops |
	conn := self connect.
	
	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'cn' equalTo: 'test1') attrs: nil wantAttrsOnly: false.
	req wait.
	rr := req result at: 1.
	
	ops :=  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.

	req := conn modify: (rr dn) with: ops.
	req wait.
	
	req :=conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new description: 'sn'; value: 'test5sn').
	req wait.
	self assert: (req result).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> testSearch [
	| conn req rr |
	conn := self connect.
	
	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: nil attrs: nil wantAttrsOnly: false.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' } ).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> testSearchWithFilters [
	| conn req rr |
	conn := self connect.
	
	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'objectclass') attrs: nil wantAttrsOnly: false.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'cn' equalTo: 'test1') attrs: nil wantAttrsOnly: false.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1'))  attrs: nil wantAttrsOnly: false.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter:
	(LDAPFilter andOf: (OrderedCollection new
						add: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')); 
						add: (LDAPFilter not: (LDAPFilter with: 'sn' equalTo: 'test2'));
						yourself ))
					  attrs: nil wantAttrsOnly: false.
	rr := req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	conn disconnect.	
]

{ #category : #tests }
LDAPTest >> testSearchWithNext [
	| conn req rr r |
	conn := self connect.
	
	req := conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: nil attrs: nil wantAttrsOnly: false.
	rr := OrderedCollection new.
	[(r := req next) == nil] whileFalse: [rr add: r ].
	
	conn disconnect.	
]
