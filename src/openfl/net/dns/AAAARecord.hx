package openfl.net.dns;

#if (!flash && sys)
/**
	The AAAARecord class represents a Domain Name System (DNS) AAAA resource
	record containing an IPv6 address.

	AAAA resource records are returned by a DNSResolver object as a result of a
	DNS lookup of a domain name.
**/
class AAAARecord extends ResourceRecord
{
	/**
		The IPv6 address.
	**/
	public var address:String;

	/**
		Creates an AAAA resource record.

		AAAA records are obtained from a DNS lookup using the DNSResolver class.
		Application code should not create AAAARecord objects.
	**/
	public function new()
	{
		super();
	}
}
#else
#if air
typedef AAAARecord = flash.net.dns.AAAARecord;
#end
#end
