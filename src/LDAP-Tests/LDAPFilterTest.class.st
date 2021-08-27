"
Test for LDAP filter creation
"
Class {
	#name : #LDAPFilterTest,
	#superclass : #TestCase,
	#category : #'LDAP-Tests'
}

{ #category : #tests }
LDAPFilterTest >> testAnd [
	| filter1 filter2 filter3 filter4 and and2 composed |
	filter1 := LDAPFilter with: 'cn' equalTo: 'test1'.
	filter2 := LDAPFilter with: 'sn'.
	filter3 := LDAPFilter with: 'sn' equalTo: 'test5'.
	filter4 := LDAPFilter with: 'sn' equalTo: 'test6'.
	and := filter1 & filter2.
	and2 := filter3 & filter4.
	
	self assert: and class equals: LDAPFilterAnd.
	self assert: and value size equals: 2.
	
	composed := and & filter3.
	self assert: composed class equals: LDAPFilterAnd.
	self assert: composed value size equals: 3.

	composed := filter3 & and.
	self assert: composed class equals: LDAPFilterAnd.
	self assert: composed value size equals: 3.

	composed := and & and2.
	self assert: composed class equals: LDAPFilterAnd.
	self assert: composed value size equals: 4.

]

{ #category : #tests }
LDAPFilterTest >> testMix [
	| filter1 filter2 filter3 filter4 and or composed |
	filter1 := LDAPFilter with: 'cn' equalTo: 'test1'.
	filter2 := LDAPFilter with: 'sn'.
	filter3 := LDAPFilter with: 'sn' equalTo: 'test5'.
	filter4 := LDAPFilter with: 'sn' equalTo: 'test6'.
	and := filter1 & filter2.
	or := filter3 | filter4.
	
	composed := and | or.
	self assert: composed class equals: LDAPFilterOr.
	self assert: composed value size equals: 3.

	composed := and & or.
	self assert: composed class equals: LDAPFilterAnd.
	self assert: composed value size equals: 3.
	
	composed := or | and.
	self assert: composed class equals: LDAPFilterOr.
	self assert: composed value size equals: 3.

	composed := or & and.
	self assert: composed class equals: LDAPFilterAnd.
	self assert: composed value size equals: 3.


]

{ #category : #tests }
LDAPFilterTest >> testNot [
	| filter not |
	filter := LDAPFilter with: 'cn' equalTo: 'test1'.
	not := filter not.
	
	self assert: not class equals: LDAPFilterNot.
	self assert: not not equals: filter.

]

{ #category : #tests }
LDAPFilterTest >> testOr [
	| filter1 filter2 filter3 filter4 or or2 composed |
	filter1 := LDAPFilter with: 'cn' equalTo: 'test1'.
	filter2 := LDAPFilter with: 'sn'.
	filter3 := LDAPFilter with: 'sn' equalTo: 'test5'.
	filter4 := LDAPFilter with: 'sn' equalTo: 'test6'.
	or := filter1 | filter2.
	or2 := filter3 | filter4.
	self assert: or class equals: LDAPFilterOr.
	self assert: or value size equals: 2.
	
	composed := or | filter3.
	self assert: composed class equals: LDAPFilterOr.
	self assert: composed value size equals: 3.

	composed := filter3 | or.
	self assert: composed class equals: LDAPFilterOr.
	self assert: composed value size equals: 3.

	composed := or | or2.
	self assert: composed class equals: LDAPFilterOr.
	self assert: composed value size equals: 4.

]

{ #category : #tests }
LDAPFilterTest >> testWith [
	| filter |
	filter := LDAPFilter with: 'sn'.
	
	self assert: filter class equals: LDAPFilterPresent.
	self assert: filter value equals: 'sn'.

]

{ #category : #tests }
LDAPFilterTest >> testWithEqualTo [
	| filter |
	filter := LDAPFilter with: 'cn' equalTo: 'test1'.
	
	self assert: filter class equals: LDAPFilterEquality.
	self assert: filter description equals: 'cn'.
	self assert: filter assertionValue equals: 'test1'.

]
