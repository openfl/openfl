package openfl.net;

#if (!flash && !html5)
import haxe.io.Bytes;
import haxe.io.Error;
import openfl.errors.ArgumentError;
import openfl.errors.IOError;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.events.DatagramSocketDataEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
#if !js
import openfl.utils.ByteArray;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;
#end

/**
	* The DatagramSocket class enables code to send and receive Universal Datagram Protocol (UDP) packets.
	*
	This feature is supported on all desktop operating systems, on iOS, and on Android. You can test for support at run time
	using the DatagramSocket.isSupported property.

	Datagram packets are individually transmitted between the source and destination. Packets can arrive in a different order
	than they were sent. Packets lost in transmission are not retransmitted, or even detected.

	Data sent using a datagram socket is not automatically broken up into packets of transmittable size. If you send a UDP
	packet that exceeds the maximum transmission unit (MTU) size, network discards the packet (without warning). The limiting
	MTU is the smallest MTU of any interface, switch, or router in the transmission path.

	The Socket class uses TCP which provides guaranteed packet delivery and automatically divides and reassembles large packets.
	TCP also provides better network bandwidth management. These features mean that data sent using a TCP socket incurs higher
	latency, but for most uses, the benefits of TCP far outweigh the costs. Most network communication should use the Socket class
	rather than the DatagramSocket class.

	The DatagramSocket class is useful for working with applications where a small transmission latency is important and packet
	loss is tolerable. For example, network operations in voice-over-IP (VoIP) applications and real-time, multiplayer games can
	often benefit from UDP. The DatagramSocket class is also useful for some server-side applications. Since UDP is a stateless
	protocol, a server can handle more requests from more clients than it can with TCP.

	The DatagramSocket class can only be used in targets that support UDP.

	@event data Dispatched when this socket receives a packet of data.
 */
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DatagramSocket extends EventDispatcher
{
	/**
		Indicates whether or not DatagramSocket features are supported in the run-time environment.
	**/
	public static var isSupported(default, null):Bool = #if !js true #else false #end;

	#if !js
	/**
		Indicates whether this socket object is currently bound to a local address and port.
	**/
	public var bound(default, null):Bool;

	/**
		Indicates whether this socket object is currently connected to a remote address and port.
	**/
	public var connected(get, null):Bool;

	/**
		The IP address this socket is bound to on the local machine.
	**/
	public var localAddress(get, null):String;

	/**
		The port this socket is bound to on the local machine.
	**/
	public var localPort(get, null):Int;

	/**
		The IP address of the remote machine to which this socket is connected.
	**/
	public var remoteAddress(get, null):String;

	/**
		The port on the remote machine to which this socket is connected.
	**/
	public var remotePort(get, null):Int;

	@:noCompletion private var __udpSocket:UdpSocket;
	@:noCompletion private var __isReceiving:Bool;
	@:noCompletion private var __iBytes:Bytes = Bytes.alloc(4096);
	@:noCompletion private var __buffer:ByteArray;

	/**
		Creates a DatagramSocket object
	**/
	public function new()
	{
		super();
		__udpSocket = new UdpSocket();
		__isReceiving = false;
		__udpSocket.setBlocking(false);
		__buffer = new ByteArray();
	}

	/**
		Binds this socket to the specified local address and port.

		The bind() method executes synchronously. The bind operation completes before the next line of code is executed.

		Once a DatagramSocket is bound, it should be closed with the close() method before disposal to avoid subsequent
		receiving of messages.

		@param localPort The number of the port to bind to on the local computer. If localPort, is set to 0 (the default),
		the next available system port is bound. Permission to connect to a port number below 1024 is subject to the system
		security policy. On Mac and Linux systems, for example, the application must be running with root privileges to
		connect to ports below 1024.
		@param localAddress The IP address on the local machine to bind to. This address can be an IPv4 or IPv6 address.
		If localAddress is set to 0.0.0.0 (the default), the socket listens on all available IPv4 addresses. To listen on
		all available IPv6 addresses, you must specify "::" as the localAddress argument. To use an IPv6 address, the
		computer and network must both be configured to support IPv6. Furthermore, a socket bound to an IPv4 address cannot
		connect to a socket with an IPv6 address. Likewise, a socket bound to an IPv6 address cannot connect to a socket with
		an IPv4 address. The type of address must match.
		@throws IOError This error occurs if the socket cannot be bound, such as when:

		1. localPort is already in use by another socket.
		2. the user account under which the application is running doesn't have sufficient system privileges to bind to the
		specified port. (Privilege issues typically occur when localPort < 1024.)
		3. This DatagramSocket object is already bound.
		4. This DatagramSocket object has been closed.
		@throws ArgumentError This error occurs when localAddress is not a syntactically well-formed IP address.
		@throws RangeError This error occurs when localPort is less than 0 or greater than 65535.
	**/
	public function bind(localPort:Int = 0, localAddress:String = "0.0.0.0"):Void
	{
		if (localPort > 65535 || localPort < 0)
		{
			throw new RangeError("Invalid socket port number specified.");
		}
		try
		{
			__udpSocket.bind(new Host(localAddress), localPort);
			bound = true;
		}
		catch (e:Dynamic)
		{
			switch (e)
			{
				case "Bind failed":
					throw new IOError("Operation attempted on invalid socket.");
				case "Unresolved host":
					throw new ArgumentError("One of the parameters is invalid");
			}
		}
	}

	/**
		Closes the socket.

		The socket is disconnected from the remote machine and unbound from the local machine. A closed socket cannot
		be reused.
	**/
	public function close():Void
	{
		try
		{
			__udpSocket.close();
		}
		catch (e:Dynamic)
		{
			// do nothing
		}
		__isReceiving = false;
		bound = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, __onFrameUpdate);
	}

	/**
		Connects the socket to a specified remote address and port.

		When a datagram socket is "connected," datagram packets can only be sent to and received from the specified
		target. Packets from other sources are ignored. Connecting a datagram socket is not required. Establishing a
		connection can remove the need to filter out extraneous packets from other sources. However, a UDP socket
		connection is not a persistent network connection (as it is for a TCP connection). It is possible that the
		remote end of the socket does not even exist.

		If the bind() method has not been called, the socket is automatically bound to the default local address and port.

		@param remoteAddress The IP address of the remote machine with which to establish a connection. This address
		can be an IPv4 or IPv6 address. If bind() has not been called, the address family of the remoteAddress, IPv4 or IPv6,
		is used when calling the default bind().
		@param remotePort The port number on the remote machine used to establish a connection.
		@throws ArgumentError This error occurs when localAddress is not a syntactically valid address. Or when a default
		route address ('0.0.0.0' or '::') is used.
		@throws RangeError This error occurs when localPort is less than 1 or greater than 65535.
		@throws IOError This error occurs if the socket cannot be connected, such as when bind() has not been called before
		the call to connect() and default binding to the remote address family is not possible.
	**/
	public function connect(remoteAddress:String, remotePort:Int):Void
	{
		if (localPort > 65535 || localPort < 0)
		{
			throw new RangeError("Invalid socket port number specified.");
		}

		try
		{
			__udpSocket.connect(new Host(remoteAddress), remotePort);
			bound = true;
		}
		catch (e:Dynamic)
		{
			switch (e)
			{
				case "Bind failed":
					throw new IOError("Operation attempted on invalid socket.");
				case "Unresolved host":
					throw new ArgumentError("One of the parameters is invalid");
			}
		}
	}

	/**
		Enables the DatagramSocket object to receive incoming packets on the bound IP address and port.

		The function returns immediately. The DatagramSocket object dispatches a data event when a data packet is
		received.
	**/
	public function receive():Void
	{
		__isReceiving = true;
	}

	/**
		Sends packet containing the bytes in the ByteArray using UDP.

		If the socket is connected, the packet is sent to the remote address and port specified in the connect()
		method and no destination IP address and port can be specified. If the socket is not connected, the packet
		is sent to the specified address and port and you must supply valid values for address and port. If the bind()
		method has not been called, the socket is automatically bound to the default local address and port.

		Note: Sending data to a broadcast address is not supported.

		@param bytes A ByteArray containing the packet data.
		@param offset The zero-based offset into the bytes ByteArray object at which the packet begins.
		@param length The number of bytes in the packet. The default value of 0 causes the entire ByteArray to be sent,
		starting at the value specified by the offset parameter.
		@param address The IPv4 or IPv6 address of the remote machine. An address is required if one has not already
		been specified using the connect() method.
		@param port The port number on the remote machine. A value greater than 0 and less than 65536 is required if the
		port has not already been specified using the connect() method.
		@throws ArgumentError If the socket is not connected and address is not a well-formed IP address.
		@throws RangeError This error occurs when port is less than 1 or greater than 65535.
		@throws IOError This error occurs:

		If bind() has not been called, and when default binding to the destination address family is not possible.
		On some operating systems, an IOError is thrown if the connect() method is called when an ICMP "destination
		unreachable" message has already been received from the target host. (Thus, the error is thrown on the second
		failed attempt to send data, not the first.) Other operating systems, such as Windows, disregard these ICMP messages,
		so no error is thrown.
		@throws RangeError If offset is greater than the length of the ByteArray specified in bytes or if the amount of data
		specified to be written by offset plus length exceeds the data available.
		@throws IllegalOperationError If the address or port parameters are specified when the socket has already been connected.
	**/
	public function send(bytes:ByteArray, offset:UInt = 0, length:UInt = 0, address:String = null, port:Int = 0):Void
	{
		if (localPort > 65535 || localPort < 0)
		{
			throw new RangeError("Invalid socket port number specified.");
		}

		if (offset + length > bytes.length)
		{
			throw new RangeError("The supplied index is out of bounds.");
		}
		try
		{
			if (length == 0)
			{
				length = bytes.length;
			}
			if (address == null)
			{
				if (connected)
				{
					__udpSocket.output.writeBytes(cast bytes, offset, length);
					__udpSocket.output.flush();
				}
				else
				{
					throw new ArgumentError("One of the parameters is invalid");
				}
			}
			else
			{
				if (connected)
				{
					throw new IllegalOperationError("Cannot send data to a location when connected.");
				}
				var sAddress:Address = new Address();
				sAddress.port = port;
				sAddress.host = new Host(address).ip;
				__udpSocket.sendTo(cast bytes, offset, length, sAddress);
			}
		}
		catch (e:Dynamic)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}
	}

	override public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		if (type == DatagramSocketDataEvent.DATA)
		{
			Lib.current.addEventListener(Event.ENTER_FRAME, __onFrameUpdate);
		}
	}

	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);
		if (type == DatagramSocketDataEvent.DATA)
		{
			Lib.current.removeEventListener(Event.ENTER_FRAME, __onFrameUpdate);
		}
	}

	@:noCompletion private function __onFrameUpdate(e:Event):Void
	{
		while (__isReceiving)
		{
			try
			{
				// Todo: Avoid new object creation
				var address:Address = new Address();
				var bytesReady = __udpSocket.readFrom(__iBytes, 0, __iBytes.length, address);
				__buffer.writeBytes(__iBytes, 0, bytesReady);
				__buffer.position = 0;
				dispatchEvent(new DatagramSocketDataEvent(DatagramSocketDataEvent.DATA, false, false, address.getHost().toString(), address.port,
					__udpSocket.host().host.toString(), __udpSocket.host().port, __buffer));
				__buffer.clear();
			}
			catch (e:Error)
			{
				break;
			}
			catch (e:Dynamic)
			{
				// do nothing
			}
		}
	}

	@:noCompletion private function get_connected():Bool
	{
		#if neko
		try
		{
			__udpSocket.peer();
			return true;
		}
		catch (e:Dynamic)
		{
			return false;
		}
		#else
		return (__udpSocket.peer() != null);
		#end
	}

	@:noCompletion private function get_localAddress():String
	{
		if (bound)
		{
			return __udpSocket.host().host.toString();
		}
		return null;
	}

	@:noCompletion private function get_localPort():Int
	{
		if (bound)
		{
			return __udpSocket.host().port;
		}
		return 0;
	}

	@:noCompletion private function get_remoteAddress():String
	{
		if (connected)
		{
			return __udpSocket.peer().host.toString();
		}
		return null;
	}

	@:noCompletion private function get_remotePort():Int
	{
		if (connected)
		{
			return __udpSocket.peer().port;
		}
		return 0;
	}
	#end
}
#else
#if air
typedef DatagramSocket = flash.net.DatagramSocket;
#end
#end
