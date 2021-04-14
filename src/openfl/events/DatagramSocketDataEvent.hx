package openfl.events;

import openfl.utils.ByteArray;

/**
	A DatagramSocketDataEvent object is dispatched when Datagram socket has received data.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DatagramSocketDataEvent extends Event
{
	/**
		Defines the value of the type property of a data event object.
	**/
	public static inline var DATA:String = "data";

	/**
		The datagram packet data.
	**/
	public var data(default, null):ByteArray;

	/**
		The IP address of the DatagramSocket object that dispatched this event.


		Note: If the socket is bound to the special address: 0.0.0.0, then this property will return
		0.0.0.0. In order to know the specific IP to which the datagram message is sent, you must bind
		the socket to an explicit IP address.
	**/
	public var dstAddress(default, null):String;

	/**
		The port of the DatagramSocket object that dispatched this event.

	**/
	public var dstPort(default, null):Int;

	/**
		The IP address of the machine that sent the packet.
	**/
	public var srcAddress(default, null):String;

	/**
		The port on the machine that sent the packet.
	**/
	public var srcPort(default, null):Int;

	/**
		Creates an Event object that contains information about datagram events. Event objects are passed as parameters
		to event listeners.

		@param type The type of the event. Possible values are:DatagramSocketDataEvent.DATA
		@param bubbles Determines whether the Event object participates in the bubbling stage of the event flow.
		@param cancelable Determines whether the Event object can be canceled.
		@param srcAddress The IP address of the machine that sent the packet.
		@param srcPort The port on the machine that sent the packet.
		@param dstAddress The IP address to which the packet is addressed.
		@param dstPort The port to which the packet is addressed.
		@param data The datagram packet data.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, srcAddress:String = "", srcPort:Int = 0, dstAddress:String = "",
			dstPort:Int = 0, data:ByteArray = null)
	{
		super(type, bubbles, cancelable);
		this.data = data;
		this.dstAddress = dstAddress;
		this.dstPort = dstPort;
		this.srcAddress = srcAddress;
		this.srcPort = srcPort;
	}

	/**
		Creates a copy of the DatagramSocketDataEvent object and sets each property's value to match that of the original.
		@return A new DatagramSocketDataEvent object with property values that match those of the original.
	**/
	public override function clone():Event
	{
		return new DatagramSocketDataEvent(type, bubbles, cancelable, srcAddress, srcPort, dstAddress, dstPort, data);
	}

	/**
		Returns a string that contains all the properties of the DatagramSocketDataEvent object. The string is in the following format:

		[DatagramSocketDataEvent type=value bubbles=value cancelable=value srcAddress=value srcPort=value dstAddress=value dstPort=value data=value]
		@return A string that contains all the properties of the ProgressEvent object.
	**/
	override public function toString():String
	{
		return
			'[DatagramSocketDataEvent type=$type bubbles=$bubbles cancelable=$cancelable srcAddress=$srcAddress srcPort=$srcPort dstAddress=$dstAddress dstPort=$dstPort data=$data]';
	}
}
