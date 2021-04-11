package openfl.events;

import openfl.events.Event;
import openfl.net.Socket;

/**
	A ServerSocket object dispatches a ServerSocketConnectEvent object when a client attempts to
	connect to the server socket.

	The socket property of the ServerSocketConnectEvent object provides the Socket object to use
	for subsequent communication between the server and the client. To deny the connection, call
	the Socket close() method.
**/
class ServerSocketConnectEvent extends Event
{
	public static inline var CONNECT:String = "connect";

	public var socket:Socket;

	/**
		Creates a ServerSocketConnectEvent object that contains information about a client connection.

		@param type The type of the event. Must be: ServerSocketConnectEvent.CONNECT.
		@param bubbles (default = false) Determines whether the Event object participates in the
			   bubbling stage of the event flow. Always false
		@param cancelable (default = false) Determines whether the Event object can be canceled. Always
			   false.
		@param socket (default = null) The socket for the new connection.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, socket:Socket = null)
	{
		super(type, bubbles, cancelable);
		this.socket = socket;
	}

	/**
		Creates a copy of the ServerSocketConnectEvent object and sets each property's value to match that
		of the original.
		@return Event A new ServerSocketConnectEvent object with property values that match those of the original.
	**/
	public override function clone():Event
	{
		return new ServerSocketConnectEvent(type, bubbles, cancelable, socket);
	}

	/**
		Returns a string that contains all the properties of the ServerSocketConnectEvent object. The string is
		in the following format:
		[ServerSocketConnectEvent type=value bubbles=value cancelable=value socket=value]
		@return A string that contains all the properties of the ProgressEvent object.
	**/
	override public function toString():String
	{
		return '[ServerSocketConnectEvent type=$type bubbles=$type cancelable=$cancelable socket=$socket]';
	}
}
