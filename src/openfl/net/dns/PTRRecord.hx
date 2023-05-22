package openfl.net.dns;

#if (!flash && sys)
/**
	The PTRRecord class represents a Domain Name System (DNS) PTR resource
	record containing a canonical domain name.

	PTR resource records are returned by a DNSResolver object as a result of a
	DNS lookup of an IP address.
**/
class PTRRecord extends ResourceRecord
{
	/**
		The canonical domain name assigned to the query IP address.
	**/
	public var ptrdName:String;

	/**
		Creates a PTR resource record.

		PTR records are obtained from a DNS lookup using the DNSResolver class.
		Application code should not create PTRRecord objects.
	**/
	public function new()
	{
		super();
	}
}
#else
#if air
typedef PTRRecord = flash.net.dns.PTRRecord;
#end
#end
