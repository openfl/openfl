package openfl.net.dns;

#if (!flash && sys)
/**
	The ResourceRecord class is the base class for Domain Name System (DNS)
	resource record classes.

	DNS resource records are returned by a DNSResolver object as a result of a
	DNS lookup.
**/
class ResourceRecord
{
	private function new() {}

	/**
		The query string used to look up this resource record.
	**/
	public var name:String;

	/**
		The resource time-to-live (ttl) value.

		The length of time (in seconds) that the resource record is valid.
		Records should not be cached for longer than this value. A ttl of zero
		means the record is volatile and must not be cached. A ttl less than
		zero means that the resource record is not valid.
	**/
	public var ttl:Int;
}
#else
#if air
typedef ResourceRecord = flash.net.dns.ResourceRecord;
#end
#end
