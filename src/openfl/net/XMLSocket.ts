import DataEvent from "../events/DataEvent";
import Event from "../events/Event";
import IOErrorEvent from "../events/IOErrorEvent";
import EventDispatcher from "../events/EventDispatcher";
import ProgressEvent from "../events/ProgressEvent";
import Socket from "../net/Socket";
import ByteArray from "../utils/ByteArray";

/**
	The XMLSocket class implements client sockets that let the Flash Player or
	AIR application communicate with a server computer identified by an IP
	address or domain name. The XMLSocket class is useful for client-server
	applications that require low latency, such as real-time chat systems. A
	traditional HTTP-based chat solution frequently polls the server and
	downloads new messages using an HTTP request. In contrast, an XMLSocket
	chat solution maintains an open connection to the server, which lets the
	server immediately send incoming messages without a request from the
	client. To use the XMLSocket class, the server computer must run a daemon
	that understands the protocol used by the XMLSocket class. The protocol is
	described in the following list:
	* XML messages are sent over a full-duplex TCP/IP stream socket
	connection.
	* Each XML message is a complete XML document, terminated by a zero (0)
	byte.
	* An unlimited number of XML messages can be sent and received over a
	single XMLSocket connection.

	Setting up a server to communicate with the XMLSocket object can be
	challenging. If your application does not require real-time interactivity,
	use the URLLoader class instead of the XMLSocket class.

	To use the methods of the XMLSocket class, first use the constructor, `new
	XMLSocket`, to create an XMLSocket object.

	SWF files in the local-with-filesystem sandbox may not use sockets.

	_Socket policy files_ on the target host specify the hosts from which SWF
	files can make socket connections, and the ports to which those
	connections can be made. The security requirements with regard to socket
	policy files have become more stringent in the last several releases of
	Flash Player. In all versions of Flash Player, Adobe recommends the use of
	a socket policy file; in some circumstances, a socket policy file is
	required. Therefore, if you are using XMLSocket objects, make sure that
	the target host provides a socket policy file if necessary.

	The following list summarizes the requirements for socket policy files in
	different versions of Flash Player:

	*  In Flash Player 9.0.124.0 and later, a socket policy file is required
	for any XMLSocket connection. That is, a socket policy file on the target
	host is required no matter what port you are connecting to, and is
	required even if you are connecting to a port on the same host that is
	serving the SWF file.
	*  In Flash Player versions 9.0.115.0 and earlier, if you want to connect
	to a port number below 1024, or if you want to connect to a host other
	than the one serving the SWF file, a socket policy file on the target host
	is required.
	*  In Flash Player 9.0.115.0, even if a socket policy file isn't required,
	a warning is displayed when using the Flash Debug Player if the target
	host doesn't serve a socket policy file.

	However, in Adobe AIR, content in the `application` security sandbox
	(content installed with the AIR application) are not restricted by these
	security limitations.

	For more information related to security, see the Flash Player Developer
	Center Topic: <a href="http://www.adobe.com/go/devnet_security_en"
	scope="external">Security</a>.

	@event close         Dispatched when the server closes the socket
						 connection. The `close` event is dispatched only when
						 the server closes the connection; it is not
						 dispatched when you call the `XMLSocket.close()`
						 method.
	@event connect       Dispatched after a successful call to the
						 `XMLSocket.connect()` method.
	@event data          Dispatched after raw data is sent or received.
	@event ioError       Dispatched when an input/output error occurs that
						 causes a send or receive operation to fail.
	@event securityError Dispatched if a call to the `XMLSocket.connect()`
						 method attempts to connect either to a server outside
						 the caller's security sandbox or to a port lower than
						 1024.
**/
export default class XMLSocket extends EventDispatcher
{
	/**
		Indicates the number of milliseconds to wait for a connection.
		If the connection doesn't succeed within the specified time, the
		connection fails. The default value is 20,000 (twenty seconds).
	**/
	public timeout: number;

	protected __connected: boolean;
	protected __socket: Socket;

	/**
		Creates a new XMLSocket object. If no parameters are specified, an
		initially disconnected socket is created. If parameters are specified,
		a connection is attempted to the specified host and port.
		**Note:** It is strongly advised to use the constructor form **without
		parameters**, then add any event listeners, then call the `connect`
		method with `host` and `port` parameters. This sequence guarantees
		that all event listeners will work properly.

		@param host A fully qualified DNS domain name or an IP address in the
					form _.222.333.444_. In Flash Player 9.0.115.0 and AIR 1.0
					and later, you can specify IPv6 addresses, such as
					rtmp://[2001:db8:ccc3:ffff:0:444d:555e:666f]. You can also
					specify `null` to connect to the host server on which the
					SWF file resides. If the SWF file issuing this call is
					running in a web browser, `host` must be in the same
					domain as the SWF file.
		@param port The TCP port number on the target host used to establish a
					connection. In Flash Player 9.0.124.0 and later, the
					target host must serve a socket policy file specifying
					that socket connections are permitted from the host
					serving the SWF file to the specified port. In earlier
					versions of Flash Player, a socket policy file is required
					only if you want to connect to a port number below 1024,
					or if you want to connect to a host other than the one
					serving the SWF file.
	**/
	public constructor(host: string = null, port: number = 80)
	{
		super();

		if (host != null)
		{
			this.connect(host, port);
		}
	}

	/**
		Closes the connection specified by the XMLSocket object. The `close`
		event is dispatched only when the server closes the connection; it is
		not dispatched when you call the `close()` method.

	**/
	public close(): void
	{
		this.__socket.removeEventListener(Event.CLOSE, this.__onClose);
		this.__socket.removeEventListener(Event.CONNECT, this.__onConnect);
		this.__socket.removeEventListener(IOErrorEvent.IO_ERROR, this.__onError);
		this.__socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.__onSocketData);

		this.__socket.close();
	}

	/**
		Establishes a connection to the specified Internet host using the
		specified TCP port.
		If you specify `null` for the `host` parameter, the host contacted is
		the one where the file calling `XMLSocket.connect()` resides. For
		example, if the calling file was downloaded from www.adobe.com,
		specifying `null` for the host parameter means you are connecting to
		www.adobe.com.

		You can prevent a file from using this method by setting the
		`allowNetworking` parameter of the the `object` and `embed` tags in
		the HTML page that contains the SWF content.

		For more information, see the Flash Player Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		@param host A fully qualified DNS domain name or an IP address in the
					form _111.222.333.444_. You can also specify `null` to
					connect to the host server on which the SWF file resides.
					If the calling file is a SWF file running in a web
					browser, `host` must be in the same domain as the file.
		@param port The TCP port number on the target host used to establish a
					connection. In Flash Player 9.0.124.0 and later, the
					target host must serve a socket policy file specifying
					that socket connections are permitted from the host
					serving the SWF file to the specified port. In earlier
					versions of Flash Player, a socket policy file is required
					only if you want to connect to a port number below 1024,
					or if you want to connect to a host other than the one
					serving the SWF file.
		@throws SecurityError Local untrusted files may not communicate with
							  the Internet. Work around this limitation by
							  reclassifying the file as local-with-networking
							  or trusted.
		@throws SecurityError You may not specify a socket port higher than
							  65535.
		@event connect       Dispatched when network connection has been
							 established.
		@event data          Dispatched when raw data has been received.
		@event securityError A connect operation attempted to connect to a
							 host outside the caller's security sandbox, or to
							 a port that requires a socket policy file. Work
							 around either problem by using a socket policy
							 file on the target host.
	**/
	public connect(host: string, port: number): void
	{
		this.__connected = false;

		this.__socket = new Socket();

		this.__socket.addEventListener(Event.CLOSE, this.__onClose);
		this.__socket.addEventListener(Event.CONNECT, this.__onConnect);
		this.__socket.addEventListener(IOErrorEvent.IO_ERROR, this.__onError);
		this.__socket.addEventListener(ProgressEvent.SOCKET_DATA, this.__onSocketData);

		this.__socket.connect(host, port);
	}

	/**
		Converts the XML object or data specified in the `object` parameter to
		a string and transmits it to the server, followed by a zero (0) byte.
		If `object` is an XML object, the string is the XML textual
		representation of the XML object. The send operation is asynchronous;
		it returns immediately, but the data may be transmitted at a later
		time. The `XMLSocket.send()` method does not return a value indicating
		whether the data was successfully transmitted.
		If you do not connect the XMLSocket object to the server using
		`XMLSocket.connect()`), the `XMLSocket.send()` operation fails.

		@param object An XML object or other data to transmit to the server.
		@throws IOError The XMLSocket object is not connected to the server.
	**/
	public send(object: Object): void
	{
		this.__socket.writeUTFBytes(String(object));
		this.__socket.writeByte(0);
		this.__socket.flush();
	}

	// Event Handlers
	protected __onClose(_): void
	{
		this.__connected = false;
		this.dispatchEvent(new Event(Event.CLOSE));
	}

	protected __onConnect(_): void
	{
		this.__connected = true;
		this.dispatchEvent(new Event(Event.CONNECT));
	}

	protected __onError(_): void
	{
		this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	protected __onSocketData(_): void
	{
		this.dispatchEvent(new DataEvent(DataEvent.DATA, false, false, this.__socket.readUTFBytes(this.__socket.bytesAvailable)));
	}

	// Get & Set Methods

	/**
		Indicates whether this XMLSocket object is currently connected. You
		can also check whether the connection succeeded by registering for the
		`connect` event and `ioError` event.
	**/
	public get connected(): boolean
	{
		return this.__connected;
	}
}
