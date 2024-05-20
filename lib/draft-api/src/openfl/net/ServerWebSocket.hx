package openfl.net;

import openfl.net._internal.websocket.FlexSocket;
import openfl.events.Event;
import openfl.net.WebSocket;
import openfl.Lib;
import haxe.io.Eof;
import haxe.io.Error;
import openfl.errors.ArgumentError;
import openfl.errors.IOError;
import openfl.errors.RangeError;
import openfl.errors.Error as CBError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ServerSocketConnectEvent;
import openfl.net.Socket as CBSocket;
import openfl.util.ByteArray;
import sys.net.Host;
import sys.ssl.Certificate;
import sys.ssl.Key;

/**
 * ...
 * @author Christopher Speciale
 */
class ServerWebSocket extends ServerSocket
{
	// Note: use chrome://flags/#allow-insecure-localhost to allow local host certificates in chrome!

	/**
		The Certificate Authoritiy responsible for signing the SSL Certificate for a Secure WebSocket Server.
	**/
	public var certAuthority(default, set):Certificate;

	/**
		Indicates whether or not ServerSocket features are supported in the run-time environment.
	**/
	public static var isSupported(default, null):Bool = #if html5 false #else true #end;

	/**
		Determines whether or not the Websocket Server should verify the Certificate.
	**/
	public var verifyCert(default, set):Null<Bool>;

	@:noCompletion private var __webServerSocket:FlexSocket;
	@:noCompletion private var __isSecure:Bool;

	@:noCompletion private function set_verifyCert(value:Bool):Bool
	{
		if (__isSecure)
		{
			return verifyCert = __webServerSocket.verifyCert = value;
		}

		return verifyCert = value;
	}

	@:noCompletion private function set_certAuthority(value:Certificate):Certificate
	{
		if (__isSecure)
		{
			__webServerSocket.setCA(value);
		}

		return certAuthority = value;
	}

	/**
		Creates a ServerSocket object.
		@throws  SecurityError This error occurs ff the calling content is running outside the AIR
				application security sandbox.
	**/
	public function new(secure:Bool = false)
	{
		__isSecure = secure;
		super();
	}

	override function __init():Void
	{
		__webServerSocket = new FlexSocket(__isSecure);

		if (__isSecure)
		{
			verifyCert = false;
		}

		__webServerSocket.setBlocking(false);
		__webServerSocket.setFastSend(true);
		__closed = false;
		bound = false;
		listening = false;
	}

	/**
		Binds this socket to the specified local address and port.
		@param localPort 	(default = 0) The number of the port to bind to on the local computer.
							If localPort, is set to 0 (the default), the next available system port is bound. Permission
							to connect to a port number below 1024 is subject to the system security policy. On Mac and
							Linux systems, for example, the application must be running with root privileges to connect
							to ports below 1024.
		@param localAddress (default = "0.0.0.0") The IP address on the local machine to bind
							to. This address can be an IPv4 or IPv6 address. If localAddress is set to 0.0.0.0 (the
							default), the socket listens on all available IPv4 addresses. To listen on all available IPv6
							addresses, you must specify "::" as the localAddress argument. To use an IPv6 address, the
							computer and network must both be configured to support IPv6. Furthermore, a socket bound to
							an IPv4 address cannot connect to a socket with an IPv6 address. Likewise, a socket bound to
							an IPv6 address cannot connect to a socket with an IPv4 address. The type of address must
							match.
		@throws RangeError    This error occurs when localPort is less than 0 or greater than 65535.
		@throws ArgumentError This error occurs when localAddress is not a syntactically well-formed IP address.
		@throws IOError 	  When the socket cannot be bound, such as when:
							  the underlying network socket (IP and port) is already in bound by another object or process.
							  the application is running under a user account that does not have the privileges necessary to bind to the port. Privilege issues typically occur when attempting to bind to well known ports (localPort < 1024)
							  this ServerSocket object is already bound. (Call close() before binding to a different socket.)
							  when localAddress is not a valid local address.
	**/
	override public function bind(localPort:Int = 0, localAddress:String = "0.0.0.0"):Void
	{
		if (localPort > 65535 || localPort < 0)
		{
			throw new RangeError("Invalid socket port number specified.");
		}
		try
		{
			this.localAddress = localAddress;
			this.localPort = localPort;
			__webServerSocket.bind(localAddress, localPort);
			bound = true;
		}
		catch (e:Dynamic)
		{
			switch (e)
			{
				case "Bind failed":
					trace("bind fail");
					throw new IOError("Operation attempted on invalid socket.");
				case "Unresolved host":
					throw new ArgumentError("One of the parameters is invalid");
			}
		}
	}

	/**
		Closes the socket and stops listening for connections.
		Closed sockets cannot be reopened. Create a new ServerSocket instance instead.
		@throws Error This error occurs if the socket could not be closed, or the socket was not open.
	**/
	override public function close():Void
	{
		try
		{
			__webServerSocket.close();
		}
		catch (e:Dynamic)
		{
			trace("close?");
			throw new CBError("Operation attempted on invalid socket.");
		}
		listening = false;
		bound = false;
		__closed = true;
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	/**
		 Initiates listening for TCP connections on the bound IP address and port.
		The listen() method returns immediately. Once you call listen(), the ServerSocket
		object dispatches a connect event whenever a connection attempt is made. The socket
		property of the ServerSocketConnectEvent event object references a Socket object
		representing the server-client connection.
		The backlog parameter specifies how many pending connections are queued while the
		connect events are processed by your application. If the queue is full, additional
		connections are denied without a connect event being dispatched. If the default
		value of zero is specified, then the system-maximum queue length is used. This
		length varies by platform and can be configured per computer. If the specified
		value exceeds the system-maximum length, then the system-maximum length is used
		instead. No means for discovering the actual backlog value is provided. (The
		system-maximum value is determined by the SOMAXCONN setting of the TCP network
		subsystem on the host computer.)
		@throws RangeError	There is insufficient data available to read.
		@throws IOError		This error occurs if the socket is not open or bound.
							This error also occurs if the call to listen() fails for any
							other reason.
	**/
	override public function listen(backlog:Int = 0):Void
	{
		if (__closed)
		{
			trace("listen?");
			throw new IOError("Operation attempted on invalid socket.");
		}
		if (backlog < 0)
		{
			throw new RangeError("The supplied index is out of bounds.");
		}
		else if (backlog == 0)
		{
			backlog = 0x7FFFFFF;
		}

		__webServerSocket.listen(backlog);
		listening = true;
	}

	@:noCompletion private function __fromSockettoWebsocket(socket:FlexSocket):WebSocket
	{
		socket.setFastSend(true);
		socket.setBlocking(false);

		var webSocket:WebSocket = WebSocket.toWebSocket(socket, this);
		/*var cbSocket = new WebSocket(); 
			cbSocket.__socket = socket;
			cbSocket.__connected = true;
			cbSocket.__timestamp = Sys.time();

			cbSocket.__host = socket.peer().host.host;
			cbSocket.__port = socket.peer().port;

			cbSocket.__output = new ByteArray();
			cbSocket.__output.endian = cbSocket.__endian;

			cbSocket.__input = new ByteArray();
			cbSocket.__input.endian = cbSocket.__endian; */

		// CrossByte.current.addEventListener(TickEvent.TICK, cbSocket.this_onTick);

		return webSocket;
	}

	@:noCompletion override private function this_onEnterFrame(e:Event):Void
	{
		var socket:FlexSocket = null;

		try
		{
			socket = __webServerSocket.accept();
		}
		/*catch (e:Eof){
			close();
			dispatchEvent(new Event(Event.CLOSE));
		}*/
		catch (e:Error)
		{
			close();
			dispatchEvent(new Event(Event.CLOSE));
		}
		catch (e:Dynamic)
		{
			// Do nothing.
		}

		if (socket != null)
		{
			// trace('con');
			__fromSockettoWebsocket(socket);
		}
	}

	/**
		The certificate for a Secure WebSocket Server.
	**/
	public var cert(default, set):{certificate:Certificate, key:Key};

	@:noCompletion private function set_cert(value:{certificate:Certificate, key:Key}):{certificate:Certificate, key:Key}
	{
		if (__isSecure)
		{
			__webServerSocket.setCertificate(value.certificate, value.key);
		}

		return cert = value;
	}
}
