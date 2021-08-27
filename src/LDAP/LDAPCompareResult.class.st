"
Result for compare
"
Class {
	#name : #LDAPCompareResult,
	#superclass : #LDAPResult,
	#category : #'LDAP-Results'
}

{ #category : #documentation }
LDAPCompareResult class >> missingRFC2251 [
	self notYetImplemented
	
"The following parts of RFC 2251 have not been implemented:

- When Message ID is over the maximum, we should rebind to reset the counter. Although practically it would be enough to just zero the counter when it overflows, since we can reuse the IDs when we have alroady gotten a response
- UTF-8 encoding
- Distinction between binary attributes (as is <AttributeType>:binary
- Automatic referral following
- Controls
- SASL Bind
- When rebinding we must terminate all pending operations, as the server will get rid of them
- Filter extensibleMatch and MatchingRuleAssertion
- SearchResultReference (Continuation References)
- Searches need more friendly selectors for stuff like derefAliases and such
- ModifyDNRequest has the wrong selector (delete old rdn bool, new superior [0] ldapdn optional)
- Extended Request
- Would be nice to have a getSchema (by using subschemaSubentry)
"
]

{ #category : #accessing }
LDAPCompareResult class >> tagValue [
	^ 16r6F
	
]

{ #category : #testing }
LDAPCompareResult >> processResult [
	self resultCode = 5 ifTrue: [ ^ false ].
	self resultCode = 6 ifTrue: [ ^ true ].
	"we save nil for execptions"
	^ nil

]
