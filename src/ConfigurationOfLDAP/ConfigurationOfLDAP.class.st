"
(ConfigurationOfSoup project version: '1.0') load
"
Class {
	#name : #ConfigurationOfLDAP,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfLDAP
}

{ #category : #'development support' }
ConfigurationOfLDAP class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfLDAP class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfLDAP class >> catalogChangeLog [
		
 ^ '- Version 1. 0 21/09/2013 migrated to SmalltalkHub
[[[
(ConfigurationOfSoup project version: ''1.0'') load
]]]

'
	
	
]

{ #category : #catalog }
ConfigurationOfLDAP class >> catalogDescription [

^ 
'LDAP (Lightweight Directory Access Protocol) is a library to manage authentification of users over the LDAP protocol.'
]

{ #category : #catalog }
ConfigurationOfLDAP class >> catalogKeyClassesAndExample [

	^ '==LDAPConnection== , ==LDAPAttrModifier== and ==LDAPFilter== are the key classes of the package.'
]

{ #category : #catalog }
ConfigurationOfLDAP class >> catalogKeywords [
	^ #(LDAP web network distributed)
	
]

{ #category : #private }
ConfigurationOfLDAP class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfLDAP class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfLDAP class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfLDAP class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfLDAP class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfLDAP class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfLDAP class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfLDAP class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfLDAP >> baseline10: spec [
	<version: '1.0-baseline'>

	spec for: #'pharo' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/PharoExtras/LDAP/main'.
		spec package: 'LDAP'].
		
		
	 
]

{ #category : #baselines }
ConfigurationOfLDAP >> baseline11: spec [
	<version: '1.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/PharoExtras/LDAP/main'.
		spec 
			package: 'LDAP';
			package: #'LDAP-Tests'. ].

]

{ #category : #accessing }
ConfigurationOfLDAP >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfLDAP >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfLDAP >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		constructor := (Smalltalk globals at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfLDAP >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.1'.

]

{ #category : #versions }
ConfigurationOfLDAP >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'First release'.
		spec author: 'S. Ducasse'.
		spec timestamp: '27/09/2013 08:58'.
		spec package: 'LDAP' with: 'LDAP-RHE.51'. 		 
	].


]

{ #category : #versions }
ConfigurationOfLDAP >> version11: spec [
	<version: '1.1' imports: #('1.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.1'.
		spec author: 'UdoSchneider'.
		spec timestamp: '9/15/2014 17:54'.
		spec 
			package: 'LDAP' with: 'LDAP-UdoSchneider.54';
			package: #'LDAP-Tests' with: 'LDAP-Tests-UdoSchneider.2'. ].

]
