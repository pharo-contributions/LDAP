Class {
	#name : #LDAPAddRequestTest,
	#superclass : #TestCase,
	#category : #'LDAP-Tests'
}

{ #category : #removing }
LDAPAddRequestTest >> testAddAttribute [
	| req |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.
	req addAttribute: LDAPPartialAttribute new.
	self deny: req attrs isEmpty.
	self assert: req attrs size equals: 1.

	req addAttribute: LDAPPartialAttribute new.
	self assert: req attrs size equals: 2.

]

{ #category : #removing }
LDAPAddRequestTest >> testAtPut [
	| req |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.
	
	req at: 'objectclass' put: 'top'.
	self assert: req attrs size equals: 1.

	req at: 'objectclass' put: 	#( 'top' 'domain' ).
	self assert: req attrs size equals: 1.

	req at: 'cn' put: 'foo'.
	self assert: req attrs size equals: 2.

	req at: 'cn' put: 'bar'.
	self assert: req attrs size equals: 2.

]

{ #category : #tests }
LDAPAddRequestTest >> testAttrs [
	| req attrs |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.

	attrs := Dictionary new
			at: 'objectClass' put: #( 'top' 'person');
			at: 'cn' put: 'name';
			at: 'sn' put: 'name';
			yourself.

	req attrs: attrs.
	self assert: req attrs size equals: 3.
			

]

{ #category : #removing }
LDAPAddRequestTest >> testRemoveAll [
	| req |
	req := LDAPAddRequest new.
	req addAttribute: LDAPPartialAttribute new.
	self deny: req attrs isEmpty.
	
	req removeAll.
	self assert: req attrs isEmpty.
]
