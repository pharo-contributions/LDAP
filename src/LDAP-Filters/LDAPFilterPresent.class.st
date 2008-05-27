Class {
	#name : #LDAPFilterPresent,
	#superclass : #LDAPFilterWithType,
	#category : #'LDAP-Filters'
}

{ #category : #'as yet unclassified' }
LDAPFilterPresent class >> having: anAttrType [
	^ self new setType: anAttrType

]

{ #category : #'as yet unclassified' }
LDAPFilterPresent class >> tagValue [
	^ 7
]
