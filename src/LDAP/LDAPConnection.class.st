"
A LDAPConnection describes the connection of a client to a LDAP server.
"
Class {
	#name : #LDAPConnection,
	#superclass : #Object,
	#instVars : [
		'worker',
		'workerThread'
	],
	#category : #'LDAP-Core'
}

{ #category : #'search scope constants' }
LDAPConnection class >> baseObject [
	^ 0
]

{ #category : #'private - accessing' }
LDAPConnection class >> collectionizedAttrs: someAttrs [
	^someAttrs collect: [:val | 
		val isString ifTrue: [ OrderedCollection with: val ] ifFalse: [ val ] ].
]

{ #category : #'search deref constants' }
LDAPConnection class >> derefAlways [
	^ 3
]

{ #category : #'search deref constants' }
LDAPConnection class >> derefFindingBaseObj [
	^ 2
]

{ #category : #'search deref constants' }
LDAPConnection class >> derefInSearching [
	^ 1
]

{ #category : #'search deref constants' }
LDAPConnection class >> derefNever [
	^ 0
]

{ #category : #documentation }
LDAPConnection class >> missingRFC2251 [
	self notYetImplemented
	
"The following parts of RFC 2251 have not been implemented:

SOON 
- When Message ID is over the maximum, we should rebind to reset the counter. Although practically it would be enough to just zero the counter when it overflows, since we can reuse the IDs when we have alroady gotten a response
- When rebinding we must terminate all pending operations, as the server will get rid of them; note we will have to notify waiters.
- Distinction between binary attributes (as is <AttributeType>:binary -- do we really need something implemented?
- UTF-8 encoding
- Extended Request
EVENTUALLY
- Controls / Search constraints
- Automatic referral following
- SearchResultReference (Continuation References)
- Filter extensibleMatch and MatchingRuleAssertion
- Would be nice to have a getSchema (by using subschemaSubentry)
WONT
- SASL Bind
"
]

{ #category : #'search scope constants' }
LDAPConnection class >> singleLevel [
	^ 1
]

{ #category : #'instance creation' }
LDAPConnection class >> to: aHostname [
	^ self to: aHostname port: 389
]

{ #category : #'instance creation' }
LDAPConnection class >> to: aHostname port: aPort [
	| obj |
	obj := self basicNew initializeWithHost: aHostname port: aPort.
	^ obj
]

{ #category : #'search scope constants' }
LDAPConnection class >> wholeSubtree [
	^ 2
]

{ #category : #accessing }
LDAPConnection >> addEntry: aDN attrs: someAttrs [
	^ LDAPRequest new initializeWith: worker request: (LDAPAddRequest new dn: aDN; attrs: someAttrs).
]

{ #category : #binding }
LDAPConnection >> bindAs: aUsername credentials: aPassword [
	^ self bindAs: aUsername credentials: aPassword method: nil

]

{ #category : #binding }
LDAPConnection >> bindAs: aUsername credentials: aPassword method: anAuthMethod [
	^ LDAPBindRequest new initializeWith: worker username: aUsername credentials: aPassword method: anAuthMethod
]

{ #category : #accessing }
LDAPConnection >> compare: aDN using: anEqualityFilter [
	^ LDAPCompareRequest new initializeWith: worker dn: aDN comparing: anEqualityFilter
]

{ #category : #accessing }
LDAPConnection >> delEntry: aDN [
	^	LDAPRequest new initializeWith: worker request: (LDAPDelRequest new dn: aDN)
]

{ #category : #connecting }
LDAPConnection >> disconnect [
	self unbind.
	worker disconnect.
	workerThread terminate
]

{ #category : #initialization }
LDAPConnection >> initializeWithHost: aHostname port: aPort [
	worker := LDAPWorker newTo: aHostname port: aPort.
	worker connect.
	workerThread := worker start.

]

{ #category : #testing }
LDAPConnection >> isValid [
	"Answers whether the connection looks still valid"
	^worker running
]

{ #category : #accessing }
LDAPConnection >> modify: aDN with: someLDAPAttrModifiers [
	^ LDAPModifyRequest new initializeWith: worker dn: aDN ops: someLDAPAttrModifiers
]

{ #category : #accessing }
LDAPConnection >> modifyDN: aDN toRDN: aRDN moveUnderDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs [
	^ LDAPModifyDNRequest new initializeWith: worker modifyDN: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs
]

{ #category : #accessing }
LDAPConnection >> modifyDN: aDN toRDN: aRDN wantToClearAttrs: aWantsToClearAttrs [
	^ self modifyDN: aDN toRDN: aRDN moveUnderDN: nil wantToClearAttrs: aWantsToClearAttrs
]

{ #category : #searching }
LDAPConnection >> newSearch: aBase scope: aSearchScope deref: aDerefBehaviour filter: aFilter attrs: someAttrs wantAttrsOnly: wantsAttrsOnly [
	| nonNilFilter nonNilAttrs |

	nonNilFilter := aFilter
		ifNil: [ nonNilFilter := LDAPFilter with: 'objectclass' ]
		ifNotNil: [ aFilter ].
	
	nonNilAttrs := someAttrs
		ifNil: [ nonNilAttrs := OrderedCollection new ]
		ifNotNil: [ someAttrs ].
	
	^ LDAPSearchRequest new initializeWith: worker base: aBase scope: aSearchScope deref: aDerefBehaviour filter: nonNilFilter attrs: nonNilAttrs wantAttrsOnly: wantsAttrsOnly
]

{ #category : #binding }
LDAPConnection >> unbind [
	^ LDAPRequest new initializeWith: worker request: (LDAPUnbindRequest new)
]
