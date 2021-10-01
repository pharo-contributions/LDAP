"
A Secure LDAP Connection using SSL
"
Class {
	#name : #LDAPSConnection,
	#superclass : #LDAPConnection,
	#category : #'LDAP-SSL'
}

{ #category : #accessing }
LDAPSConnection class >> workerClass [
	^ LDAPSWorker
]
