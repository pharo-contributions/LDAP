Class {
	#name : #LDAPAttrModifier,
	#superclass : #Object,
	#category : #LDAP
}

{ #category : #'as yet unclassified' }
LDAPAttrModifier class >> addTo: anAttr values: someValues [
	^ LDAPModifyAddOp affecting: anAttr values: someValues
]

{ #category : #'as yet unclassified' }
LDAPAttrModifier class >> del: anAttr [
	^ LDAPModifyDelOp affecting: anAttr values: {}
]

{ #category : #'as yet unclassified' }
LDAPAttrModifier class >> delFrom: anAttr values: someValues [
	^ LDAPModifyDelOp affecting: anAttr values: someValues
]

{ #category : #'as yet unclassified' }
LDAPAttrModifier class >> set: anAttr to: someValues [
	^ LDAPModifyReplaceOp affecting: anAttr values: someValues
]
