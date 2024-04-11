package openfl.net.dns;

#if (!flash && sys)
/**
	The MXRecord class represents a Domain Name System (DNS) MX resource record
	containing a mail exchange server address.

	MX resource records are returned by a DNSResolver object as a result of a
	DNS lookup on a domain name. More than one record can be returned by a
	single lookup if more than one mail exchange is available.
**/
class MXRecord extends ResourceRecord
{
	/**
		The host name of a mail exchange service.
	**/
	public var exchange:String;

	/**
		The priority of the mail exchange identified by this record.

		Lower values are higher priority.
	**/
	public var preference:Int;

	/**
		Creates an MX resource record.

		MX records are obtained from a DNS lookup using the DNSResolver class.
		Application code should not create MXRecord objects.
	**/
	public function new()
	{
		super();
	}
}
#else
#if air
typedef MXRecord = flash.net.dns.MXRecord;
#end
#end
