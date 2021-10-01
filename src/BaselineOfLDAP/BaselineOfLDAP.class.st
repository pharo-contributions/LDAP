"
LDAP (Lightweight Directory Access Protocol) is a network protocol for remote directories. 

This implementation is fully written in Pharo and don't requires access to native libraries.
"
Class {
	#name : #BaselineOfLDAP,
	#superclass : #BaselineOf,
	#category : #BaselineOfLDAP
}

{ #category : #baselines }
BaselineOfLDAP >> baseline: spec [
	<baseline>
	spec
		for: #common
			do: [
				"Packages"
				spec
					package: 'LDAP';
					package: 'LDAP-Tests' with: [ spec requires: #('LDAP') ];
					package: 'LDAP-SSL' with: [ spec requires: #('LDAP') ];
					package: 'LDAP-ActiveDirectory' with: [ spec requires: #('LDAP' 'LDAP-SSL') ].
			 ]
]
