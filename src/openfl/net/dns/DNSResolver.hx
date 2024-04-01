package openfl.net.dns;

#if (!flash && sys)
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;

/**
	The DNSResolver class lets you lookup Domain Name System (DNS) resource records.

	You can test for support at run time using the `DNSResolver.isSupported`
	property.

	_OpenFL target support:_ Not currently supported, except when targeting AIR.

	_Adobe AIR profile support:_ This feature is supported on all desktop
	operating systems, but is not supported on mobile devices. It is partially
	supported on AIR for TV devices.See
	[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	You can look up the following types of resource records:

	- ARecord: IPv4 address for a host.
	- AAAARecord: IPv6 address for a host.
	- MXRecord: mail exchange record for a host.
	- PTRRecord: host name for an IP address.
	- SRVRecord: service record for a service

	The following table indicates DNS lookup support on AIR for TV devices. Unsupported requests result in the DNSResolver object dispatching an flash.events.ErrorEvent object.

	| Record type specified in `DNSResolver.lookup()` | Support                                                   |
	| ----------------------------------------------- | --------------------------------------------------------- |
	| ARecord                                         | Full support                                              |
	| AAAARecord                                      | Full support                                              |
	| MXRecord                                        | Not supported                                             |
	| PTRRecord                                       | Supported only for IPv4 addresses, not for IPv6 addresses |
	| SRVRecord                                       | Not supported                                             |
**/
class DNSResolver extends EventDispatcher
{
	/**
		Indicates whether DNS lookups are supported on the client system.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		return false;
	}

	/**
		Creates a DNSResolver object.
	**/
	public function new()
	{
		super();
		throw new IllegalOperationError("Not supported");
	}

	/**
		Looks up a DNS resource record based on a query string.

		The `lookup()` method performs a DNS lookup asynchronously. Listen for
		the `lookup` event to get the results of the lookup. Listen for the
		`error` event to receive errors. Results are dispatched in a
		DNSResolverEvent object.

		To specify the type of resource record to look up, pass the
		corresponding class in the `recordType` parameter. (Pass the class name
		itself and not a string containing the class name.)

		The content of the query string passed to the method depends on the type
		of resource record being looked up. The following list illustrates the
		query string to use for each record type.

		| Record type | Query string             | Example                  |
		| ----------- | ------------------------ | ------------------------ |
		| ARecord     | host name                | "example.com"            |
		| AAAARecord  | host name                | "example.com"            |
		| MXRecord    | host name                | "example.com"            |
		| PTRRecord   | IP address               | "208.77.188.166"         |
		| SRVRecord   | _service._protocol.host. | "_sip._tcp.example.com." |
	**/
	public function lookup(host:String, recordType:Class<ResourceRecord>):Void {}
}
#else
#if air
typedef DNSResolver = flash.net.dns.DNSResolver;
#end
#end
