"
I am LDAP Message.

I am a pseudo BER Sequence. (I do not have my own application tag)
"
Class {
	#name : #LDAPMessage,
	#superclass : #BERSequence,
	#classVars : [
		'LdapTags'
	],
	#category : #'LDAP-Core'
}

{ #category : #'class initialization' }
LDAPMessage class >> initialize [ 
"LDAP messages class initialization. Populate the knownTags variable for application elements creation."
	| classes |
	classes := BERElement allSubclasses select: [ :c | c class canPerform: #tagValue ].
	classes := classes select: #isApplication.
	LdapTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

{ #category : #'instance creation' }
LDAPMessage class >> newFrom: aStream [
"Create a BER decoder with the LDAPMessage as application"
	| decoder message |
	message := self new.
	decoder := BERDecoder new application: message.
	decoder decode: message from: aStream.
	^ message
]

{ #category : #accessing }
LDAPMessage >> controls [
	^ (elements size > 2) ifTrue: [ elements third value ] ifFalse: [ #() ]
]

{ #category : #accessing }
LDAPMessage >> controls: aCollection [
	| controls |
	controls := LDAPControls new.
	aCollection do: [ :each | controls addElement: each ].
	(elements size > 2) ifTrue: [ elements at: 3 put: controls ] ifFalse: [ elements addLast: controls ]
]

{ #category : #'instance creation' }
LDAPMessage >> createApplicationElement: aTagValue [
"Create a BER applicatio element from a tag value"
	| elementClass |
	elementClass := LdapTags at: aTagValue ifAbsent: [ ^ nil ].
	^ elementClass new

]

{ #category : #'instance creation' }
LDAPMessage >> createContextElement: aTagValue at: anIndex with: aDecoder [
"Used for controls"
	(aTagValue = LDAPControls tagValue) ifTrue: [ ^ LDAPControls new ].
	
	^ super createContextElement: aTagValue at: anIndex with: aDecoder
]

{ #category : #converting }
LDAPMessage >> encoded [
"Return the encoded message"
	^ ByteString streamContents: [ :stream | self writeOn: stream ]

]

{ #category : #accessing }
LDAPMessage >> id [
	^ elements first value
]

{ #category : #accessing }
LDAPMessage >> id: anInteger [
	elements first value: anInteger 
]

{ #category : #initialization }
LDAPMessage >> initialize [ 
	super initialize.
	
	self addElement: (BERInteger new). "id"
	self addElement: (BERNull new). "protocolOp"

]

{ #category : #accessing }
LDAPMessage >> operation [
	^ elements second
]

{ #category : #accessing }
LDAPMessage >> operation: anObject [
	elements at: 2 put: anObject
]

{ #category : #accessing }
LDAPMessage >> response [
	^ elements value second
]

{ #category : #accessing }
LDAPMessage >> sequence: anObject [
	elements removeAll.
	elements addAll: anObject value.
]
