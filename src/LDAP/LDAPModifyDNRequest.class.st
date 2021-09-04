"
Request to modify a distinguished name
"
Class {
	#name : #LDAPModifyDNRequest,
	#superclass : #BERSequence,
	#category : #'LDAP-Core'
}

{ #category : #initialization }
LDAPModifyDNRequest >> initializeWith: anLDAPWorker modifyDN: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs [
	self initializeWith: anLDAPWorker.
	anLDAPWorker send:
		(LDAPEncoder modifyDNRequest: messageId dn: aDN toRDN: aRDN underDN: aUnderDN wantToClearAttrs: aWantsToClearAttrs)

]
