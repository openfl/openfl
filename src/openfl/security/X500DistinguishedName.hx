package openfl.security;

#if !flash
/**
	The X500DistinguishedName class defines Distinguished Name (DN) properties
	for use in the X509Certificate class. The Distinguished Name protocol is
	specified in [RFC1779](http://tools.ietf.org/rfc/rfc1779).

	This class is useful for any code that needs to examine a server
	certificate's Subject and Issuer DN after a secure socket connection has
	been established. Subject and Issuer DN data is accessible in the
	X509Certificate class's `subject` and `issuer` properties. These properties
	are populated with X500DistinguishedName objects after
	`SecureSocket.connect()` establishes a connection with the server.

	This class stores DN attributes as string properties. You can use the
	`toString()` method to get all of the individual DN properties in one
	string. Properties with no DN value are set to `null`.

	Note: The X500DistinguishedName properties store only the first occurrence
	of each DN attribute, although the DN protocol allows for multiple
	attributes of the same type.

	@see `openfl.net.SecureSocket`
**/
class X500DistinguishedName
{
	private function new() {}

	/**
		Returns the DN CommonName attribute.
	**/
	public var commonName(default, null):String;

	/**
		Returns the DN CountryName attribute.
	**/
	public var countryName(default, null):String;

	/**
		Returns the DN LocalityName attribute.
	**/
	public var localityName(default, null):String;

	/**
		Returns the DN OrganizationalUnitName attribute.
	**/
	public var organizationalUnitName(default, null):String;

	/**
		Returns the DN OrganizationName attribute.
	**/
	public var organizationName(default, null):String;

	/**
		Returns the DN StateOrProvinceName attribute.
	**/
	public var stateOrProvinceName(default, null):String;

	/**
		Returns all DN properties in one string.
	**/
	public function toString():String
	{
		var result = "";
		if (commonName != null)
		{
			result += '/CN=$commonName';
		}
		if (countryName != null)
		{
			result += '/C=$countryName';
		}
		if (localityName != null)
		{
			result += '/L=$localityName';
		}
		if (organizationalUnitName != null)
		{
			result += '/OU=$organizationalUnitName';
		}
		if (organizationName != null)
		{
			result += '/O=$organizationName';
		}
		if (stateOrProvinceName != null)
		{
			result += '/S=$stateOrProvinceName';
		}
		return result;
	}
}
#else
typedef X500DistinguishedName = flash.security.X500DistinguishedName;
#end
