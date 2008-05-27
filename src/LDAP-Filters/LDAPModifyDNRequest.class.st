Class {
	#name : #LDAPModifyDNRequest,
	#superclass : #LDAPRequest,
	#category : #LDAP
}

{ #category : #'as yet unclassified' }
LDAPModifyDNRequest >> initializeWith: anLDAPWorker modifyDN: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder modifyDNRequest: messageId dn: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs)

]
