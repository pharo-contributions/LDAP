"
A secure worker (thread)
"
Class {
	#name : #LDAPSWorker,
	#superclass : #LDAPWorker,
	#instVars : [
		'ssl'
	],
	#category : #'LDAP-SSL'
}

{ #category : #'instance creation' }
LDAPSWorker class >> socketClass [
	^ ZdcSecureSocketStream
]

{ #category : #connecting }
LDAPSWorker >> postConnect [
	"SSL handshake"
	sockStream connect.
]
