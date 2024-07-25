package openfl.net._internal.websocket;

#if sys
import haxe.extern.EitherType;
import haxe.io.Input;
import haxe.io.Output;
import sys.net.Host;
import sys.net.Socket;
import sys.ssl.Certificate;
import sys.ssl.Key;
import sys.ssl.Socket as SSLSocket;

typedef HostInfo =
{
	port:Int,
	host:Host
};

typedef Sockets =
{
	write:Array<Socket>,
	read:Array<Socket>,
	others:Array<Socket>
};

@:forward
abstract FlexSocket(EitherType<Socket, SSLSocket>) from Socket to Socket from SSLSocket to SSLSocket
{
	public static var DEFAULT_CA(get, set):Null<Certificate>;

	public static var DEFAULT_VERIFY_CERT(get, set):Null<Bool>;

	private static inline function get_DEFAULT_CA():Null<Certificate>
	{
		return SSLSocket.DEFAULT_CA;
	}

	private static inline function set_DEFAULT_VERIFY_CERT(value:Null<Bool>):Null<Bool>
	{
		return SSLSocket.DEFAULT_VERIFY_CERT = value;
	}

	private static inline function get_DEFAULT_VERIFY_CERT():Null<Bool>
	{
		return SSLSocket.DEFAULT_VERIFY_CERT;
	}

	private static inline function set_DEFAULT_CA(value:Null<Certificate>):Null<Certificate>
	{
		return SSLSocket.DEFAULT_CA = value;
	}

	public static function select(read:Array<FlexSocket>, write:Array<FlexSocket>, others:Array<FlexSocket>, ?timeout:Float):Sockets
	{
		return Socket.select(read, write, others, timeout);
	}

	private static inline function __requireSSL(field:String, instance:FlexSocket):Void
	{
		if (!instance.isSecure)
		{
			throw '$field::Field only available when using a secure socket';
		}
	}

	public var custom(get, set):Dynamic;

	public var input(get, never):Input;

	public var isSecure(get, never):Bool;

	public var output(get, never):Output;

	public var verifyCert(get, set):Null<Bool>;

	public inline function new(secure:Bool = false)
	{
		if (secure)
		{
			// trace("SECURE");
			this = new SSLSocket();
		}
		else
		{
			// trace("UNSECURE");
			this = new Socket();
		}
	}

	private inline function get_custom():Dynamic
	{
		return (this : Socket).custom;
	}

	private inline function set_custom(value:Dynamic):Dynamic
	{
		return (this : Socket).custom = value;
	}

	private inline function get_input():Input
	{
		return (this : Socket).input;
	}

	private inline function get_isSecure():Bool
	{
		if (Std.isOfType(this, SSLSocket))
		{
			return true;
		}

		return false;
	}

	private inline function get_output():Output
	{
		return (this : Socket).output;
	}

	private inline function get_verifyCert():Null<Bool>
	{
		__requireSSL("verifyCert", this);

		return (this : sys.ssl.Socket).verifyCert;
	}

	private inline function set_verifyCert(value:Null<Bool>):Null<Bool>
	{
		__requireSSL("verifyCert", this);

		return (this : sys.ssl.Socket).verifyCert = value;
	}

	public inline function accept():Socket
	{
		return (this : Socket).accept();
	}

	public inline function addSNICertificate(cbServernameMatch:String->Bool, cert:Certificate, key:Key):Void
	{
		__requireSSL("addSNICertificate", this);

		(this : sys.ssl.Socket).addSNICertificate(cbServernameMatch, cert, key);
	}

	public inline function bind(host:String, port:Int):Void
	{
		(this : Socket).bind(new Host(host), port);
	}

	public inline function close():Void
	{
		(this : Socket).close();
	}

	public inline function connect(host:String, port:Int):Void
	{
		(this : Socket).connect(new Host(host), port);
	}

	public inline function handshake():Void
	{
		__requireSSL("handshake", this);

		(this : sys.ssl.Socket).handshake();
	}

	public inline function host():HostInfo
	{
		return (this : Socket).host();
	}

	public inline function listen(connections:Int = 0):Void
	{
		if (connections == 0) connections = 0x7FFFFFF;
		(this : Socket).listen(connections);
	}

	public inline function peer():HostInfo
	{
		return (this : Socket).peer();
	}

	public inline function peerCertificate():Certificate
	{
		__requireSSL("peerCertificate", this);

		return (this : sys.ssl.Socket).peerCertificate();
	}

	public inline function read():String
	{
		return (this : Socket).read();
	}

	public inline function setBlocking(value:Bool):Void
	{
		(this : Socket).setBlocking(value);
	}

	public inline function setCA(cert:Certificate):Void
	{
		__requireSSL("setCA", this);

		(this : sys.ssl.Socket).setCA(cert);
	}

	public inline function setCertificate(cert:Certificate, key:Key):Void
	{
		__requireSSL("setCertificate", this);

		(this : sys.ssl.Socket).setCertificate(cert, key);
	}

	public inline function setFastSend(value:Bool):Void
	{
		(this : Socket).setFastSend(value);
	}

	public inline function setHostname(name:String):Void
	{
		__requireSSL("setHostname", this);

		(this : sys.ssl.Socket).setHostname(name);
	}

	public inline function setTimeout(value:Float):Void
	{
		(this : Socket).setTimeout(value);
	}

	public inline function shutdown(read:Bool, write:Bool):Void
	{
		(this : Socket).shutdown(read, write);
	}

	private inline function waitForRead():Void
	{
		(this : Socket).waitForRead();
	}

	private inline function write(content:String):Void
	{
		(this : Socket).write(content);
	}
}
#end
