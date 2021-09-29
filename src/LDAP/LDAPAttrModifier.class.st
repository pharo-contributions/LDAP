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
	^ LDAPModifyAttributes new 
		operation: LDAPAddAttributesOperation new; 
		attr: anAttr; 
		values: someValues; 
		yourself
]

{ #category : #operations }
LDAPAttrModifier class >> del: anAttr [
	^ self delFrom: anAttr values: #()
]

{ #category : #operations }
LDAPAttrModifier class >> delFrom: anAttr values: someValues [
	^ LDAPModifyAttributes new 
		operation: LDAPDeleteAttributesOperation new;
		attr: anAttr;
		values: someValues;
		yourself 
]

{ #category : #operations }
LDAPAttrModifier class >> set: anAttr to: someValues [
	^ LDAPModifyAttributes new
		operation: LDAPReplaceAttributesOperation new;
		attr: anAttr;
		values: someValues;
		yourself 

]
