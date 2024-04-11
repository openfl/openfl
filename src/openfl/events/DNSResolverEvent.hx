package openfl.events;

#if (!flash && sys)
import openfl.net.dns.ResourceRecord;

/**
	The DNSResolverEvent class represents the results of a Domain Name System
	(DNS) lookup operation.

	Use the DNSResolver `lookup()` method to initiate a DNS query. Resource
	records returned by the query are placed in the `resourceRecords` array of
	this DNSResolverEvent object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DNSResolverEvent extends Event
{
	/**
		Defines the value of the `type` property of a `lookup` event object.
	**/
	public static inline var LOOKUP:EventType<DNSResolverEvent> = "lookup";

	/**
		The query string, such as a host name, IP address, or service locator
		used in the call to the `lookup()` method of the DNSResolver class for
		which this event is a response.
	**/
	public var host:String;

	/**
		An array containing the resource records returned by the DNS lookup operation.
	**/
	public var resourceRecords:Array<ResourceRecord>;

	/**
		Creates an DNSResolverEvent object that contains the results of a DNS
		lookup operation. Event objects are passed as parameters to event listeners.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, host:String = "", resourceRecords:Array<ResourceRecord> = null)
	{
		super(type, bubbles, cancelable);
		this.host = host;
		this.resourceRecords = resourceRecords;
	}

	public override function clone():DNSResolverEvent
	{
		return new DNSResolverEvent(type, bubbles, cancelable, host, resourceRecords);
	}
}
#else
#if air
typedef DNSResolverEvent = flash.events.DNSResolverEvent;
#end
#end
