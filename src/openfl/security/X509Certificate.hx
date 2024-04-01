package openfl.security;

import openfl.utils.ByteArray;

#if !flash
/**
	The X509Certificate class represents an X.509 certificate. This class
	defines X.509 properties specified in
	[RFC2459](http://tools.ietf.org/rfc/rfc2459). After you make a successful
	call to `SecureSocket.connect()`, the server's certificate data is stored as
	an X509Certificate instance in the `SecureSocket.serverCertificate`
	property.

	Use this class to examine a server certificate after establishing a secure
	socket connection. The properties in this class provide access to the most
	used attributes of an X.509 certificate. If you must access other parts of a
	server certificate (for example, its extensions), the complete certificate
	is available in the `encoded` property. The certificate stored in the
	`encoded` property is DER-encoded.

	@see `openfl.net.SecureSocket`
**/
class X509Certificate
{
	private function new() {}

	/**
		Provides the whole certificate in encoded form. Client code can decode
		this value to process certificate extensions. X.509 certificate
		extensions are not represented in the other properties in this class.
		Decoding the `encoded` property is the only way to access a
		certificate's extensions.
	**/
	public var encoded(default, null):ByteArray;

	/**
		Provides the issuer's Distinguished Name (DN).
	**/
	public var issuer(default, null):X500DistinguishedName;

	/**
		Provides the issuer's unique identifier.
	**/
	public var issuerUniqueID(default, null):String;

	/**
		Provides the serial number of the certificate as a hexadecimal string.
		The issuer assigns this number, and the number is unique within the
		issuer's list of issued certificates.
	**/
	public var serialNumber(default, null):String;

	/**
		Provides the signature algorithm Object Identifier (OID).
	**/
	public var signatureAlgorithmOID(default, null):String;

	/**
		Provides the signature algorithm's parameters. If there are no signature
		algorithm parameters, this value is set to `null`.
	**/
	public var signatureAlgorithmParams(default, null):ByteArray;

	/**
		Provides the subject's Distinguished Name (DN).
	**/
	public var subject(default, null):X500DistinguishedName;

	/**
		Provides the subject's public key.
	**/
	public var subjectPublicKey(default, null):String;

	/**
		Provides the algorithm OID for the subject's public key.
	**/
	public var subjectPublicKeyAlgorithmOID(default, null):String;

	/**
		Provides the subject's unique identifier.
	**/
	public var subjectUniqueID(default, null):String;

	/**
		Indicates the date on which the certificate's validity period ends.
	**/
	public var validNotAfter(default, null):Date;

	/**
		Indicates the date on which the certificate's validity period begins.
	**/
	public var validNotBefore(default, null):Date;

	/**
		Provides the version number of the certificate format. This property
		indicates whether the certificate has extensions, a unique identifier,
		or only the basic fields.

		- `version` = 2: Indicates X.509 Version 3 - Extensions are present
		- `version` = 1: Indicates X.509 Version 2 - Extensions are not present, but a unique identifier is present.
		- `version` = null: Indicates X.509 Version 1 - Only the basic certificate fields are present
	**/
	public var version(default, null):UInt;
}
#else
typedef X509Certificate = flash.security.X509Certificate;
#end
