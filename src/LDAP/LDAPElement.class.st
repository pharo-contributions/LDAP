"
An LDAP Element, common superclass
"
Class {
	#name : #LDAPElement,
	#superclass : #BERElement,
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPElement class >> elementClasses [
	^ (super elementClasses, "yuk :)"
		{ 
			LDAPAddResult. LDAPBindResult. LDAPCompareResult. LDAPDelResult. LDAPExtendedResult.
			LDAPModifyResult. LDAPModifyDNResult. LDAPSearchResultEntry. LDAPSearchResultCode.
		}
	)
]
