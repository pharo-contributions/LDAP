Extension { #name : #String }

{ #category : #'*ldap-activedirectory' }
String >> asActiveDirectoryUnicodePassword [
	^ String
		streamContents: [ :writeStream | 
			UTF16TextConverter new
				useLittleEndian: true;
				nextPut: $" toStream: writeStream;
				nextPutAll: self toStream: writeStream;
				nextPut: $" toStream: writeStream ]
]
