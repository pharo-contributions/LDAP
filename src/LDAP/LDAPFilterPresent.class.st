"
A present filter
"
Class {
	#name : #LDAPFilterPresent,
	#superclass : #LDAPFilterWithType,
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterPresent class >> having: anAttrType [
	^ self new setType: anAttrType

]

{ #category : #accessing }
LDAPFilterPresent class >> tagValue [
	^ 7
]
