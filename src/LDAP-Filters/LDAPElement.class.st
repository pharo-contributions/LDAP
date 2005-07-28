Class {
	#name : #LDAPElement,
	#superclass : #BERElement,
	#category : 'LDAP'
}

{ #category : #'as yet unclassified' }
LDAPElement class >> elementClasses [
	^ (super elementClasses, "yuk :)"
		{ 
			LDAPAddResult. LDAPBindResult. LDAPCompareResult. LDAPDelResult. LDAPExtendedResult.
			LDAPModifyResult. LDAPModifyDNResult. LDAPSearchResultEntry. LDAPSearchResultCode.
		}
	)
]
