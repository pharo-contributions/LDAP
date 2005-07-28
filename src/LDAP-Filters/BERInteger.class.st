Class {
	#name : #BERInteger,
	#superclass : #BERElement,
	#category : 'LDAP-BER'
}

{ #category : #'as yet unclassified' }
BERInteger class >> tagValue [
	^ 2 
]

{ #category : #'as yet unclassified' }
BERInteger >> decode: aStream [
	|  highBitPos xorMask |
	value _ 0.
	(1 to: length) do: [ :i | value _ (value bitShift: 8) + aStream next asInteger ].

	"if the high bit is set, we have negative"	
	highBitPos _ value highBit.
	(highBitPos  = (length * 8))  ifTrue: [
		xorMask _ (1 bitShift: highBitPos) - 1.
		value _ value bitXor: xorMask.
		value _ (value + 1) negated ]

]

{ #category : #'as yet unclassified' }
BERInteger >> writeBodyOn: aStream [
	| octets netOctets isNegative remainderValue octetsIndex |
	isNegative _ value < 0.
	octets _ ByteArray new: (value digitLength + 2).
	
	"put value into octet array, covert negatives as appropiate"
	
	isNegative not 
		ifTrue: [
			value = 0
				ifTrue: [
					octetsIndex _ 1.
					octets at: octetsIndex put: 0 ]
				ifFalse: [
					remainderValue _ value.
					octetsIndex _ 0.
					[remainderValue >  0] whileTrue: [
						octetsIndex _ octetsIndex + 1.
						octets at: octetsIndex put: (remainderValue bitAnd: 255).
						remainderValue _ remainderValue bitShift: -8 ] ]
					]
		ifFalse: [ 
			"negatives are in two's complement -- to convert: 1. change to positive. 2. substract 1, 3. xor everythnig"
			remainderValue _ value negated.
			remainderValue _ remainderValue - 1.
			octetsIndex _ 0.
			[
				octetsIndex _ octetsIndex + 1.
				octets at: octetsIndex put: ((remainderValue bitXor: 255) bitAnd: 255).
				remainderValue _ remainderValue bitShift: -8.
				remainderValue > 0.
			] whileTrue ].
	
	"if originally we had a positive, and highest bit is set in the beginning of the array, we prefix the array with a zero byte"
	"if said bit is set and original was negative, prefix with a all-ones byte"
	"we actually test the end of the array because we are switching it around later for network order"

	value > 0 ifTrue: [
		(((octets at: octetsIndex) bitAnd: 128) > 0) ifTrue: [
			octetsIndex _ octetsIndex + 1.
			octets at: octetsIndex put: 0 ] ].
	value < 0 ifTrue: [
		(((octets at: octetsIndex) bitAnd: 128) = 0) ifTrue: [
			octetsIndex _ octetsIndex + 1.
			octets at: octetsIndex put: 255 ] ].		

	"hton"
	netOctets _ ByteArray new: octetsIndex.
	(1 to: octetsIndex) 
		do: [:i | netOctets at: i put: (octets at: (octetsIndex + 1) - i) ].
	
	self writeLength: octetsIndex on: aStream.
	aStream nextPutAll: (netOctets asString).
	^ octetsIndex
]
