"
An attribute modifier
"
Class {
	#name : #LDAPAttrModifier,
	#superclass : #Object,
	#category : #'LDAP-Core'
}

{ #category : #operations }
LDAPAttrModifier class >> addTo: anAttr values: someValues [
	^ LDAPModifyOp new operation: 0; attr: anAttr; values: someValues; yourself 

]

{ #category : #operations }
LDAPAttrModifier class >> del: anAttr [
	^ LDAPModifyOp new operation: 1; attr: anAttr; values: {}; yourself 
]

{ #category : #operations }
LDAPAttrModifier class >> delFrom: anAttr values: someValues [
	^ LDAPModifyOp new operation: 1; attr: anAttr; values: someValues; yourself 
]

{ #category : #operations }
LDAPAttrModifier class >> set: anAttr to: someValues [
	^ LDAPModifyOp new operation: 2; attr: anAttr; values: someValues; yourself 

]
