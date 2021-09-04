"
In a LDAP search,  this element specifies how the server should treat alias entries that it may encounter during processing.

Alias entries are kind of like the LDAP equivalent of a UNIX symbolic link in that they can make it look like an entry exists in more than one location in the DIT. 

The act of following an alias to the entry that it references is called dereferencing that alias. 
"
Class {
	#name : #LDAPSearchDerefAliases,
	#superclass : #Object,
	#category : #'LDAP-Enumerated'
}

{ #category : #constants }
LDAPSearchDerefAliases class >> always [   
	^ 3
]

{ #category : #constants }
LDAPSearchDerefAliases class >> findingBase [  
	^ 2
]

{ #category : #constants }
LDAPSearchDerefAliases class >> inSearching [ 
	^ 1
]

{ #category : #constants }
LDAPSearchDerefAliases class >> never [
	^ 0
]
