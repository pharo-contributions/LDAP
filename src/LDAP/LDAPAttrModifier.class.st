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
	^ LDAPModifyAddOp affecting: anAttr values: someValues
]

{ #category : #operations }
LDAPAttrModifier class >> del: anAttr [
	^ LDAPModifyDelOp affecting: anAttr values: {}
]

{ #category : #operations }
LDAPAttrModifier class >> delFrom: anAttr values: someValues [
	^ LDAPModifyDelOp affecting: anAttr values: someValues
]

{ #category : #operations }
LDAPAttrModifier class >> set: anAttr to: someValues [
	^ LDAPModifyReplaceOp affecting: anAttr values: someValues
]
