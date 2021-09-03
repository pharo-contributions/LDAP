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
	^ LDAPModifyChange new operation: 0; attr: anAttr; values: someValues; yourself 

]

{ #category : #operations }
LDAPAttrModifier class >> del: anAttr [
	^ LDAPModifyChange new operation: 1; attr: anAttr; values: {}; yourself 
]

{ #category : #operations }
LDAPAttrModifier class >> delFrom: anAttr values: someValues [
	^ LDAPModifyChange new operation: 1; attr: anAttr; values: someValues; yourself 
]

{ #category : #operations }
LDAPAttrModifier class >> set: anAttr to: someValues [
	^ LDAPModifyChange new operation: 2; attr: anAttr; values: someValues; yourself 

]
