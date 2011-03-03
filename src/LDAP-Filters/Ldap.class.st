"
Ldap has not been documented yet. The class comment should describe the purpose of the class, its collaborations and its variables.

Instance Variables:
	conn	<LDAPConnection>
	
""
| ann result |

ann := Ldap new connect.
result := ann searchAll.
result do: [ :each | Transcript show: (each attrAt: #cn); cr ].
ann disconnect.
""
"
Class {
	#name : #Ldap,
	#superclass : #Object,
	#instVars : [
		'conn'
	],
	#category : #Ldap
}

{ #category : #action }
Ldap >> addValueTo: aDN attribute: aAttribute with: aValue [
	| req ops |
	
	"
	ajoute une valeur à un attribut
	| ann |

	ann := Ldap new connect.	
	ann addValueTo: 'uid=auverlot' attribute: 'givenName' with: 'Alfred'.
	ann disconnect.
	"
	
	ops := {
		LDAPAttrModifier addTo: aAttribute values: { aValue }.
	}.
	
	req := conn modify: (aDN, ',', self baseDN) with: ops.
	req wait. 
]

{ #category : #configuration }
Ldap >> baseDN [
	^ 'ou=people,dc=lifl,dc=fr'
]

{ #category : #configuration }
Ldap >> bindDN [
	^ 'cn=admin,dc=lifl,dc=fr'
]

{ #category : #action }
Ldap >> buildDNWith: aDN [
	^ aDN , ',' , self baseDN
]

{ #category : #action }
Ldap >> changeValueOf: aDN attribute: aAttribute with: aValue [
	| req ops |
	
	"
	Change la valeur d'un attribut'
	| ann |

	ann := Ldap new connect.
	ann changeValueOf: 'uid=auverlot' attribute: 'liflStatuts' with: 'ige'.
	ann disconnect.
	"
	ops := {
		LDAPAttrModifier set: aAttribute to: { aValue }.
	}.
	
	req := conn modify: (aDN, ',', self baseDN) with: ops.
	req wait.
]

{ #category : #accessing }
Ldap >> conn [
	^ conn
]

{ #category : #accessing }
Ldap >> conn: anObject [
	conn := anObject
]

{ #category : #action }
Ldap >> connect [
	| req |
	self conn: (LDAPConnection to: self hostname port: self port).
	req := conn bindAs: self bindDN credentials: self password.
	req wait.
	^ self.
	
	
	
	
]

{ #category : #action }
Ldap >> createEntry: aDN with: aCollection [

	| req |
	
	req := self conn addEntry: aDN attrs: aCollection.
	req wait.
]

{ #category : #action }
Ldap >> deleteAttribute: aAttribute from: aDN [
"
efface un attribut dans un DN
| ann |

ann := Ldap new connect.
ann deleteAttribute: 'liflNationalite' from: 'uid=auverlot'.
ann disconnect.
"
	| req ops |
	
	ops := {
		LDAPAttrModifier del: aAttribute.
	}.
	
	req := conn modify: (aDN, ',', self baseDN) with: ops.
	req wait.
]

{ #category : #action }
Ldap >> deleteAttribute: aAttribute value: aValue from: aDN [
	"efface un attribut selon sa valeur ?
	
| ann |

ann := Ldap new connect.
ann deleteAttribute: 'givenName' value: 'Alfred' from: 'uid=auverlot'.
ann disconnect.
	"
	| req ops |
	
	ops := {
		LDAPAttrModifier delFrom: aAttribute values: { aValue }.
	}.
	
	req := conn modify: (aDN, ',', self baseDN) with: ops.
	req wait.
]

{ #category : #action }
Ldap >> deleteEntry: aDN [

	"Efface une entrée dans l'annuaire
	
| ann |

ann := Ldap new connect.
ann deleteEntry: 'uid=bergel'.
ann disconnect.	
	'"
	| req |
	req := self conn delEntry: (aDN , ',' , self baseDN).
	req wait.
	
]

{ #category : #action }
Ldap >> disconnect [
	self conn disconnect.
]

{ #category : #configuration }
Ldap >> hostname [
	^ 'testldap.priv.lifl.fr'
	
]

{ #category : #configuration }
Ldap >> password [
	^'gwiadtest'
]

{ #category : #configuration }
Ldap >> port [
	^ 389
]

{ #category : #action }
Ldap >> search: aValue attribute: aAttribute [
	| req result |
	
	"
	Recherche des entrées selon la valeur d'un attribut'
	| ann result |

	ann := Ldap new connect.
	result := ann search: 'auverlot' attribute: 'uid'.
	result do: [ :each | Transcript show: (each attrAt: #liflNationalite); cr ].
	ann disconnect.
	"
	req := self conn newSearch: self baseDN scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: (LDAPFilter with: aAttribute equalTo: aValue) attrs: nil wantAttrsOnly: false.
	result := req result.
	^result
]

{ #category : #action }
Ldap >> searchAll [
	| req result |
	
	"
	Recherche toutes les entrées'
	| ann result |

	ann := Ldap new connect.
	result := ann searchAll.
	result do: [ :each | Transcript show: (each attrAt: #liflNationalite); cr ].
	ann disconnect.
	"
	
	req := self conn newSearch: self baseDN scope: (LDAPConnection wholeSubtree) deref: (LDAPConnection derefNever) filter: nil attrs: nil wantAttrsOnly: false.
	result := req result.
	^result
]
