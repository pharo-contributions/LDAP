"
Do not be surprised if any of the tests fails, their state is rather crude, mostly due to the heavy volatility of the API.
"
Class {
	#name : #LDAPTest,
	#superclass : #TestCase,
	#category : 'LDAP-Tests'
}

{ #category : #'as yet unclassified' }
LDAPTest class >> baseDN [
	^ 'dc=linalco,dc=test'
]

{ #category : #'as yet unclassified' }
LDAPTest class >> bindDN [
	^ 'cn=admin, ',self baseDN
]

{ #category : #'as yet unclassified' }
LDAPTest class >> hostname [
"	^ '10.2.0.12'"
	^ '127.0.0.1'
]

{ #category : #'as yet unclassified' }
LDAPTest class >> newSuite [
	| obj |
	obj _ TestSuite named: 'LDAP'.
	obj addTest: (LDAPTest selector: #testSearch).
	^ obj
	
]

{ #category : #'as yet unclassified' }
LDAPTest class >> password [
	^ 'secret'
]

{ #category : #'as yet unclassified' }
LDAPTest class >> port [
	^ 12000
]

{ #category : #'as yet unclassified' }
LDAPTest class >> testAll [
	"This test expects a single entry in the tree:
		dn: dc=linalco, dc=test
		dc: linalco
		objectClass: dcObject
		objectClass: organization
		o: linalco"

	| l |
	l _ LDAPTest new.

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

{ #category : #'as yet unclassified' }
LDAPTest >> checkSearchResults: aResult expecting: expectedRDNs [
	aResult size  = expectedRDNs size
		ifFalse: [ ^ false ].
	
	expectedRDNs do: [:eachExpected | | qualified isPresent |
		eachExpected
			ifNil: [ qualified _ self class baseDN ]
			ifNotNil: [ qualified _ eachExpected, ',', self class baseDN ].
		isPresent _ false.
		aResult do: [ :eachResult |
			eachResult dn = qualified
				ifTrue: [ isPresent _ true ]  ].
		isPresent ifFalse: [^ false].
	].
	^ true
]

{ #category : #'as yet unclassified' }
LDAPTest >> connect [
	| req conn |
	conn _ LDAPConnection to: self class hostname port: self class port.
	req _ conn bindAs: self class bindDN credentials: self class password.
	req wait.
	^ conn


]

{ #category : #'as yet unclassified' }
LDAPTest >> testAddWithCollectionValues [
	| conn req attrs |
	conn _ self connect.
	
	(1 to: 5) do: [ :each | |name|
		name _ 'test', each asString.
	
		attrs _ Dictionary new
			at: 'objectClass' put: (OrderedCollection new add: 'person'; yourself);
			at: 'cn' put: (OrderedCollection new add: name; yourself);
			at: 'sn' put: (OrderedCollection new add: name; yourself);
			yourself.
		
		req _ conn addEntry: 'cn=',name,',', self class baseDN attrs: attrs.
		req wait.
	]
]

{ #category : #'as yet unclassified' }
LDAPTest >> testAddWithStringValues [
	| conn req attrs |
	conn _ self connect.
	
	(1 to: 5) do: [ :each | |name|
		name _ 'test', each asString.
	
		attrs _ Dictionary new
			at: 'objectClass' put: 'person';
			at: 'cn' put: name;
			at: 'sn' put: name;
			yourself.
		
		req _ conn addEntry: 'cn=',name,',', self class baseDN attrs: attrs.
		req wait.
	]
]

{ #category : #'as yet unclassified' }
LDAPTest >> testBind [
	| conn |
	conn _ self connect.
	conn disconnect.
]

{ #category : #'as yet unclassified' }
LDAPTest >> testCompare [
	| conn req |
	conn _ self connect.

	req _conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new setType: 'cn' value: 'test1').
	req wait.
	self assert: (req result).

	req _conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new setType: 'cn' value: 'test2').
	req wait.
	self deny: (req result).

	conn disconnect.
]

{ #category : #'as yet unclassified' }
LDAPTest >> testDel [
	| conn req |
	conn _ self connect.
	
	(1 to: 5) do: [ :each | |name|
		name _ 'test', each asString.
		req _ conn delEntry: 'cn=',name,',', self class baseDN.
		req wait.
	].

	conn disconnect
]

{ #category : #'as yet unclassified' }
LDAPTest >> testDoubleBind [
	| conn req |
	conn _ self connect.
	req _ conn bindAs: self class bindDN credentials: self class password.
	req wait.
	conn disconnect.
]

{ #category : #'as yet unclassified' }
LDAPTest >> testModify [
	| conn req rr ops |
	conn _ self connect.
	
	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'cn' equalTo: 'test1') attrs: nil wantAttrsOnly: false.
	req wait.
	rr _ req result at: 1.
	
	ops _  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.

	req _ conn modify: (rr dn) with: ops.
	req wait.
	
	req _conn compare: 'cn=test1,', self class baseDN using: (LDAPFilterEquality new setType: 'sn' value: 'test5sn').
	req wait.
	self assert: (req result).
	
	conn disconnect.	
]

{ #category : #'as yet unclassified' }
LDAPTest >> testSearch [
	| conn req rr |
	conn _ self connect.
	
	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: nil attrs: nil wantAttrsOnly: false.
	rr _ req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' } ).
	
	conn disconnect.	
]

{ #category : #'as yet unclassified' }
LDAPTest >> testSearchWithFilters [
	| conn req rr |
	conn _ self connect.
	
	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'objectclass') attrs: nil wantAttrsOnly: false.
	rr _ req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: 'cn' equalTo: 'test1') attrs: nil wantAttrsOnly: false.
	rr _ req result.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1'))  attrs: nil wantAttrsOnly: false.
	rr _ req result.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter:
	(LDAPFilter andOf: (OrderedCollection new
						add: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')); 
						add: (LDAPFilter not: (LDAPFilter with: 'sn' equalTo: 'test2'));
						yourself ))
					  attrs: nil wantAttrsOnly: false.
	rr _ req result.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	conn disconnect.	
]

{ #category : #'as yet unclassified' }
LDAPTest >> testSearchWithNext [
	| conn req rr |
	conn _ self connect.
	
	req _ conn newSearch: (self class baseDN) scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: nil attrs: nil wantAttrsOnly: false.
	rr _ OrderedCollection new.
	[req hasMoreEntries] whileTrue: [
		| r |
		 r _ req next.
		rr add: r ].
	
	conn disconnect.	
]
