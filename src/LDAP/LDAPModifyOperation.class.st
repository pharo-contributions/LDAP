"
Enumerated value to represent the change for a modify attributes request.

The change types defined in RFC 4511 (in the operation enumerated element of a change sequence) are:
- add
- delete
- replace
"
Class {
	#name : #LDAPModifyOperation,
	#superclass : #BEREnumerated,
	#category : #'LDAP-Enumerated'
}
