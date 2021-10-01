"
BERSet is a set of values encoded in BER.
"
Class {
	#name : #BERSet,
	#superclass : #BERConstruct,
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BERSet class >> tagValue [
	"SET + Constructed"
	^ (17 + 32)
]
