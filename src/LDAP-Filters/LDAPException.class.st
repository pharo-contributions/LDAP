Class {
	#name : #LDAPException,
	#superclass : #Error,
	#instVars : [
		'resultCode'
	],
	#category : #'LDAP-Exceptions'
}

{ #category : #'as yet unclassified' }
LDAPException class >> newWithCode: aResultCode [
	| ex newClass |
	newClass := self.
	(aResultCode >= 16 and: [aResultCode <= 21])
		 ifTrue: [ newClass := LDAPAttrProblemException ].
	(aResultCode >= 32) & (aResultCode <= 36) & (aResultCode ~= 35)
		ifTrue: [ newClass := LDAPNameProblemException ].
	(aResultCode >= 48 and: [aResultCode <= 50])
		ifTrue: [ newClass := LDAPSecurityProblemException ].
	(aResultCode >= 51 and: [aResultCode <= 54])
		ifTrue: [ newClass := LDAPServiceProblemException ].
	((aResultCode >= 64 and: [aResultCode <= 69]) or: [aResultCode = 71])
		ifTrue: [ newClass := LDAPUpdateProblemException ].
		
	ex := newClass new initializeWithCode: aResultCode.
	^ ex
]

{ #category : #'as yet unclassified' }
LDAPException >> asSymbol [
"perl-extracted out of openldap's ldap.h -- we should get rid of those ugly LDAP prefixes"
^ resultCode caseOf: {
[0]->[#LDAPSuccess].
[1]->[#LDAPOperationsError].
[2]->[#LDAPProtocolError].
[3]->[#LDAPTimeLimitExceeded].
[4]->[#LDAPSizeLimitExceeded].
[5]->[#LDAPCompareFalse].
[6]->[#LDAPCompareTrue].
[7]->[#LDAPAuthMethodNotSupported].
[8]->[#LDAPStrongAuthRequired].
[10]->[#LDAPReferral].
[11]->[#LDAPAdminLimitExceeded].
[12]->[#LDAPUnavailableCriticalExtension].
[13]->[#LDAPConfidentialityRequired].
[14]->[#LDAPSaslBindInProgress].
[16]->[#LDAPNoSuchAttribute].
[17]->[#LDAPUndefinedAttributeType].
[18]->[#LDAPInappropriateMatching].
[19]->[#LDAPConstraintViolation].
[20]->[#LDAPAttributeOrValueExists].
[21]->[#LDAPInvalidAttributeSyntax].
[32]->[#LDAPNoSuchObject].
[33]->[#LDAPAliasProblem].
[34]->[#LDAPInvalidDnSyntax].
[35]->[#LDAPIsLeaf].
[36]->[#LDAPAliasDereferencingProblem].
[48]->[#LDAPInappropriateAuthentication].
[49]->[#LDAPInvalidCredentials].
[50]->[#LDAPInsufficientAccessRights].
[51]->[#LDAPBusy].
[52]->[#LDAPUnavailable].
[53]->[#LDAPUnwillingToPerform].
[54]->[#LDAPLoopDetect].
[64]->[#LDAPNamingViolation].
[65]->[#LDAPObjectClassViolation].
[66]->[#LDAPNotAllowedOnNonleaf].
[67]->[#LDAPNotAllowedOnRdn].
[68]->[#LDAPEntryAlreadyExists].
[69]->[#LDAPObjectClassModsProhibited].
[71]->[#LDAPAffectsMultipleDsas].
[80]->[#LDAPOther].
[81]->[#LDAPServerDown].
[82]->[#LDAPLocalError].
[83]->[#LDAPEncodingError].
[84]->[#LDAPDecodingError].
[85]->[#LDAPLdapTimeout].
[86]->[#LDAPAuthUnknown].
[87]->[#LDAPFilterError].
[88]->[#LDAPUserCancelled].
[90]->[#LDAPNoMemory].
[91]->[#LDAPConnectError].
[92]->[#LDAPLdapNotSupported].
[93]->[#LDAPControlNotFound].
[94]->[#LDAPNoResultsReturned].
[95]->[#LDAPMoreResultsToReturn].
[96]->[#LDAPClientLoop].
[97]->[#LDAPReferralLimitExceeded].
[100]->[#LDAPInvalidResponse].
[101]->[#LDAPAmbiguousResponse].
[112]->[#LDAPTlsNotSupported].
} otherwise: [#LDAPUnknownReturnCode]
]

{ #category : #'as yet unclassified' }
LDAPException >> initializeWithCode: aResultCode [
	resultCode := aResultCode.
	self messageText: self asSymbol
]
