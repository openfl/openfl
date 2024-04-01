package openfl.net.dns;

#if (!flash && sys)
/**
	The ARecord class represents a Domain Name System (DNS) A resource record
	containing an IPv4 address.

	A resource records are returned by a DNSResolver object as a result of a DNS
	lookup of a domain name.
**/
class ARecord extends ResourceRecord
{
	/**
		The IPv4 address.
	**/
	public var address:String;

	/**
		Creates an A resource record.

		A records are obtained from a DNS lookup using the DNSResolver class.
		Application code should not create ARecord objects.
	**/
	public function new()
	{
		super();
	}
}
#else
#if air
typedef ARecord = flash.net.dns.ARecord;
#end
#end
