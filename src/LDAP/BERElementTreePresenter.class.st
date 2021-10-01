"
I am a presenter to display BER elements as trees in the inspector.
"
Class {
	#name : #BERElementTreePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roots',
		'tree'
	],
	#category : #'LDAP-Inspector'
}

{ #category : #accessing }
BERElementTreePresenter class >> childrenBlock [ 

	^ [ :e | e elements ]
]

{ #category : #accessing }
BERElementTreePresenter class >> classBlock [ 

	^ [ :e | String streamContents: [ :s | 
				s << e class name.
				e elements ifNotEmpty: [ :children | s << ' (' << children size asString << ')' ] ].
		]
]

{ #category : #initialization }
BERElementTreePresenter class >> defaultLayout [ 
	^ SpBoxLayout newVertical add: #tree; yourself
]

{ #category : #specs }
BERElementTreePresenter class >> defaultSpec [

	^ self defaultLayout
]

{ #category : #examples }
BERElementTreePresenter class >> example [
"Sample tree"
	| mod |
	mod := self sampleElement.
	^ self new root: mod; openWithSpec

]

{ #category : #examples }
BERElementTreePresenter class >> exampleInspect [
"Sample tree"
	self sampleElement inspect.

]

{ #category : #examples }
BERElementTreePresenter class >> sampleElement [
"Sample tree"
	| ops |
	ops :=  { 
		LDAPAttrModifier set: 'sn' to: { 'test' . 'foo' . 'bar'}.
		LDAPAttrModifier addTo: 'description' values: {'moo'}.
		LDAPAttrModifier del: 'color'.
		LDAPAttrModifier delFrom: 'groups' values: {'ni'}.
	}.

	^ LDAPModifyRequest new dn: 'cn=a,dc=root'; ops: ops.

]

{ #category : #accessing }
BERElementTreePresenter class >> valueBlock [ 

	^ [ :e | e value ifNotNil: [ String streamContents: [ :s | e displayStringOn: s ] ] ]
]

{ #category : #forwarding }
BERElementTreePresenter >> activateOnSingleClick [
	tree activateOnSingleClick.
]

{ #category : #initialization }
BERElementTreePresenter >> connectPresenters [ 

	super connectPresenters.

	tree whenActivatedDo: [ :event | self toggleExpandCurrent ].
		

]

{ #category : #controlling }
BERElementTreePresenter >> expand [
	tree expandRoots.
]

{ #category : #initialization }
BERElementTreePresenter >> initializePresenters [ 

	tree := self newTreeTable 
		isResizable: true;
		addColumn: (SpStringTableColumn title: 'Class' evaluated: self class classBlock);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: self class valueBlock);
		children: self class childrenBlock;
		yourself.
	

]

{ #category : #initialization }
BERElementTreePresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter
		title: self titleForWindow
]

{ #category : #ports }
BERElementTreePresenter >> outputActivationPort [ 
	^ tree outputActivationPort
]

{ #category : #accessing }
BERElementTreePresenter >> root: anObject [
	^ self roots: { anObject }
	
]

{ #category : #accessing }
BERElementTreePresenter >> roots: aCollection [
	roots := aCollection.
	self updatePresenter.
	
]

{ #category : #accessing }
BERElementTreePresenter >> selectedItem [
	"Return selected item."
	
	^ tree selectedItem
]

{ #category : #initialization }
BERElementTreePresenter >> titleForWindow [ 
	| element |
	roots ifNil: [ ^ 'No elements' ].

	element := roots size = 1 ifTrue: [ roots first ] ifFalse: [ roots ].
	^ element printString
]

{ #category : #controlling }
BERElementTreePresenter >> toggleExpandCurrent [
	| path state |
	path := tree selection selectedPath.
	path ifNil: [ ^ self ].
	state := tree isExpanded: path.
	state ifTrue: [ tree collapsePath: path ] ifFalse: [ tree expandPath: path ].
]

{ #category : #initialization }
BERElementTreePresenter >> updatePresenter [ 
	| elements |
	elements := roots ifNil: [ { BERNull new } ].
	tree roots: elements.
	
	self withWindowDo: [ :w | w title: self titleForWindow ]
]
