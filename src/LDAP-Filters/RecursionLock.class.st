"
I work as Semaphore forMutualExclusion but I won't block in critical: if I was already locked by the same process running me now.	

	|lock|

	lock _ RecursionLock new.
	lock critical:[
		Transcript show: 'Locked.';cr.
		lock critical:[
			Transcript show: 'By now I would be  deadlocked if I was a Semaphore.';cr. ] ]
"
Class {
	#name : #RecursionLock,
	#superclass : #Object,
	#instVars : [
		'lockedByProcess',
		'semaphore'
	],
	#category : 'LDAP'
}

{ #category : #'instance creation' }
RecursionLock class >> new [
	^ self basicNew initialize
]

{ #category : #'mutual-exclusion' }
RecursionLock >> critical: protectedBlock [
	| blockValue |
	lockedByProcess = Processor activeProcess
		ifTrue: [
			"If lockedByProcess matches, its obvously not nil and thereforey we were already locked.
			So skip the semaphore."
			blockValue _ protectedBlock value ]
		ifFalse: [ 
			"Otherwise lock and proceed as usual making sure we reset the lock once its over"
			semaphore critical: [
				lockedByProcess _ Processor activeProcess.
				blockValue _  [protectedBlock value] ensure: [lockedByProcess _ nil] ] ].
	^ blockValue

]

{ #category : #'initialize-release' }
RecursionLock >> initialize [
	semaphore _ Semaphore forMutualExclusion
]
