package openfl.net.dns;

#if (!flash && sys)
/**
	The SRVRecord class represents a Domain Name System (DNS) SRV resource
	record containing a service host.

	SRV resource records are returned by a DNSResolver object as a result of a
	DNS lookup on a service locator. More than one record can be returned by a
	single lookup if more than one service host is available.
**/
class SRVRecord extends ResourceRecord
{
	/**
		The port the service is using on the server.
	**/
	public var port:Int;

	/**
		The priority of the service host identified by this record.

		Lower values are higher priority.
	**/
	public var priority:Int;

	/**
		The canonical host name of the server providing the service.
	**/
	public var target:String;

	/**
		The relative weight to use when selecting from service hosts that have
		the same priority.
	**/
	public var weight:Int;

	/**
		Creates an SRV resource record.

		SRV records are obtained from a DNS lookup using the DNSResolver class.
		Application code should not create SRVRecord objects.
	**/
	public function new()
	{
		super();
	}
}
#else
#if air
typedef SRVRecord = flash.net.dns.SRVRecord;
#end
#end
