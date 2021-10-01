"
Request to reset a password.

The request DN is the user DN.
"
Class {
	#name : #ADSetPasswordRequest,
	#superclass : #LDAPModifyRequest,
	#category : #'LDAP-ActiveDirectory-Requests'
}

{ #category : #converting }
ADSetPasswordRequest class >> encodedPassword: aString [
	^ String
		streamContents: [ :writeStream | 
			UTF16TextConverter new
				useLittleEndian: true;
				nextPut: $" toStream: writeStream;
				nextPutAll: aString toStream: writeStream;
				nextPut: $" toStream: writeStream ]
]

{ #category : #accessing }
ADSetPasswordRequest >> password: aString [
	| op encoded |
	encoded := self class encodedPassword: aString.
	op := LDAPAttrModifier set: 'unicodePwd' to: {encoded}.
	self ops: {op}.

]
