"
I represent an unknown element.

I get instanced when my tag is not recognized.
ASN.1 specification makes that with the length, I can get skipped and the message can still be decrypted.
"
Class {
	#name : #BERUnknownElement,
	#superclass : #BEROctetString,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERUnknownElement >> value [ 
	"Do not UTF-8 decode me"
	^ value ifNil: [ #[] ]
]
