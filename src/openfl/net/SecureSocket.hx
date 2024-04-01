package openfl.net;

import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.errors.IOError;
import openfl.errors.SecurityError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.security.CertificateStatus;
import openfl.security.X500DistinguishedName;
import openfl.security.X509Certificate;
import openfl.utils.ByteArray;
#if sys
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Error;
import sys.net.Host;
import sys.net.Socket as SysSocket;
import sys.ssl.Certificate;
import sys.ssl.Socket as SysSecureSocket;
#end

#if !flash
/**
	The SecureSocket class enables code to make socket connections using the
	Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols.

	You can test for support at run time using the `SecureSocket.isSupported`
	property.

	_OpenFL target support:_ This feature is supported on all desktop operating
	systems, on iOS, and on Android. It is not supported on non-sys targets.

	_Adobe AIR profile support:_ This feature is supported on all desktop
	operating systems, but is not supported on all AIR for TV devices. On mobile
	devices, it is supported on Android and also supported on iOS starting from
	AIR 20. See
	[AIR Profile Support](https://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	The SSL/TLS protocols provide a mechanism to handle both aspects of a secure
	socket connection:

	1. Encryption of data communication over the socket
	2. Authentication of the host's identity via its certificate

	The supported encryption protocols are SSL 3.1 and higher, and TLS 1.0 and
	higher. (TLS is the successor protocol for SSL. TLS 1.0 equals SSL 3.1,
	TLS 1.1 equals SSL 3.2, and so on.) SSL versions 3.0 or lower are not
	supported.

	Validation of the server certificate is performed using the trust store and
	certificate validation support of the client platform. In addition you can
	add your own certificates programmatically with the
	`addBinaryChainBuildingCertificate()` method. This API isn't supported on
	all systems currently. Using this API on some systems will throw an
	exception - "ArgumentError: Error #2004"

	The SecureSocket class only connects to servers with valid, trusted
	certificates. You cannot choose to connect to a server in spite of a problem
	with its certificate. For example, there is no way to connect to a server
	with an expired certificate. The same is true for a certificate that doesn't
	chain to a trusted anchor certificate. The connection will not be made, even
	though the certificate would be valid otherwise.

	The SecureSocket class is useful for performing encrypted communication to a
	trusted server. In other respects, a SecureSocket object behaves like a
	regular Socket object.

	To use the SecureSocket class, create a SecureSocket object
	(`new SecureSocket()`). Next, set up your listeners, and then run
	`SecureSocket.connect(host, port)`. When you successfully connect to the
	server, the socket dispatches a `connec`t event. A successful connection is
	one in which the server's security protocols are supported and its
	certificate is valid and trusted. If the certificate cannot be validated,
	the Socket dispatches an `IOError` event.

	Important: The Online Certificate Status Protocol (OCSP) is not supported by
	all operating systems. Users can also disable OCSP checking on individual
	computers. If OCSP is not supported or is disabled and a certificate does
	not contain the information necessary to check revocation using a
	Certificate Revocation List (CRL), then certificate revocation is not
	checked. The certificate is accepted if otherwise valid. This scenario could
	allow a server to use a revoked certificate.

	@event close            Dispatched when the server closes the socket
							connection.
	@event connect          Dispatched when a network connection has been
							established.
	@event ioError          Dispatched when an input or output error occurs that
							causes a send or receive operation to fail.
	@event securityError    Dispatched when a call to SecureSocket.connect()
							fails because of a security restriction.
	@event socketData       Dispatched when a socket has received data.
**/
@:access(openfl.security.X509Certificate)
@:access(openfl.security.X500DistinguishedName)
class SecureSocket extends Socket
{
	/**
		Indicates whether secure sockets are supported on the current system.

		Secure sockets are not supported on all platforms. Check this property
		before attempting to create a SecureSocket instance.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		#if sys
		return true;
		#else
		return false;
		#end
	}

	/**
		Creates a new SecureSocket object.

		Check `SecureSocket.isSupported` before attempting to create a
		SecureSocket instance. If SSL 3.0 or TLS 1.0 sockets are not supported,
		the runtime will throw an IllegalOperationError.

		@throws IllegalOperationError When SSL Version 3.0 (and higher) or TLS
		Version 1.0 (and higher) is not supported.

		@throws SecurityError Local untrusted SWF files cannot communicate with
		the Internet. You can work around this problem by reclassifying this
		SWF file as local-with-networking or trusted.
	**/
	public function new()
	{
		super();
		#if !sys
		throw new IllegalOperationError("Not supported");
		#end
	}

	@:noCompletion private var __peerCertificate:#if sys Certificate #else Dynamic #end;

	/**
		Holds the X.509 certificate obtained from the server after a secure
		SSL/TLS connection is established. If a secure connection is not
		established, this property is set to `null`.

		For more information on X.509 certificates, see
		[RFC2459](http://tools.ietf.org/rfc/rfc2459).
	**/
	public var serverCertificate(get, null):X509Certificate;

	@:noCompletion private function get_serverCertificate():X509Certificate
	{
		if (__socket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}
		if (__peerCertificate == null)
		{
			return null;
		}
		var result = new X509Certificate();

		var subject = new X500DistinguishedName();
		subject.commonName = __peerCertificate.subject("CN");
		subject.countryName = __peerCertificate.subject("C");
		subject.localityName = __peerCertificate.subject("L");
		subject.organizationName = __peerCertificate.subject("O");
		subject.organizationalUnitName = __peerCertificate.subject("OU");
		subject.stateOrProvinceName = __peerCertificate.subject("S");
		result.subject = subject;

		var issuer = new X500DistinguishedName();
		issuer.commonName = __peerCertificate.issuer("CN");
		issuer.countryName = __peerCertificate.issuer("C");
		issuer.localityName = __peerCertificate.issuer("L");
		issuer.organizationName = __peerCertificate.issuer("O");
		issuer.organizationalUnitName = __peerCertificate.issuer("OU");
		issuer.stateOrProvinceName = __peerCertificate.issuer("S");
		result.issuer = issuer;

		result.validNotBefore = __peerCertificate.notBefore;
		result.validNotAfter = __peerCertificate.notAfter;

		return result;
	}

	@:noCompletion private var __serverCertificateStatus:CertificateStatus = CertificateStatus.UNKNOWN;

	/**
		Returns the status of the server's certificate.

		The status is `CertificateStatus.UNKNOWN` until the socket attempts to
		connect to a server. After validation, the status is one of the strings
		enumerated by the CertificateStatus class. The connection only succeeds
		when the certificate is valid and trusted. Thus, after a `connect`
		event, the value of `serverCertificateStatus` is always `trusted`.

		**Note:** Once the certificate has been validated or rejected, the
		status value is not updated until the next call to the `connect()`
		method. Calling `close()` does not reset the status value to "unknown".
	**/
	public var serverCertificateStatus(get, null):CertificateStatus;

	@:noCompletion private function get_serverCertificateStatus():CertificateStatus
	{
		return __serverCertificateStatus;
	}

	/**
		Adds an X.509 certificate to the local certificate chain that your
		system uses for validating the server certificate. The certificate is
		temporary, and lasts for the duration of the session.

		Server certificate validation relies on your system's trust store for
		certificate chain building and validation. Use this method to
		programmatically add additional certification chains and trusted
		anchors.

		On Mac OS, the System keychain is the default keychain used during the
		SSL/TLS handshake process. Any intermediate certificates in that
		keychain are included when building the certification chain.

		The certificate you add with this API must be a DER-encoded X.509
		certificate. If the trusted parameter is true, the certificate you add
		with this API is considered a trusted anchor.

		For more information on X.509 certificates, see
		[RFC2459](http://tools.ietf.org/rfc/rfc2459).

		@param certificate A ByteArray object containing a DER-encoded X.509 digital certificate.
		@param trusted Set to true to designate this certificate as a trust anchor.

		@throws ArgumentError When the certificate cannot be added.

	**/
	public function addBinaryChainBuildingCertificate(certificate:ByteArray, trusted:Bool):Void
	{
		throw new ArgumentError("Not supported");
	}

	/**
		Connects the socket to the specified host and port using SSL or TLS.

		When you call the `SecureSocket.connect()` method, the socket attempts
		SSL/TLS handshaking with the server. If the handshake succeeds, the
		socket attempts to validate the server certificate. If the certificate
		is valid and trusted, then the secure socket connection is established,
		and the socket dispatches a `connect` event. If the handshake fails or
		the certificate cannot be validated, the socket dispatches an `IOError`
		event. You can check the certificate validation result by reading the
		`serverCertificateStatus` property after the `IOError` event is
		dispatched. (When a `connect` event is dispatched, the certificate
		status is always `trusted`.)

		If the socket was already connected, the existing connection is closed
		first.

		@param host The name or IP address of the host to connect to.
		@param port The port number to connect to.

		@throws IOError When you don't specify a host and the connection fails.

		@throws SecurityError When you specify a socket port less than zero or
		higher than 65535.
	**/
	override public function connect(host:String, port:Int):Void
	{
		__serverCertificateStatus = UNKNOWN;
		__peerCertificate = null;
		if (__socket != null)
		{
			close();
		}

		if (port < 0 || port > 65535)
		{
			throw new SecurityError("Invalid socket port number specified.");
		}

		#if sys
		var h:Host = null;

		try
		{
			h = new Host(host);
		}
		catch (e:Dynamic)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Invalid host"));
			return;
		}

		__timestamp = Sys.time();
		#end

		__host = host;
		__port = port;

		__output = new ByteArray();
		__output.endian = __endian;

		__input = new ByteArray();
		__input.endian = __endian;

		#if sys
		try
		{
			__socket = new SysSecureSocket();
		}
		catch (e:Dynamic)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Connection failed"));
			return;
		}
		try
		{
			__socket.setBlocking(false);
			__socket.connect(h, port);
			__socket.setFastSend(true);
		}
		catch (e:Dynamic) {}
		#end

		Lib.current.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	@:noCompletion override private function this_onEnterFrame(event:Event):Void
	{
		#if sys
		var doConnect = false;
		var doClose = false;

		if (!connected)
		{
			try
			{
				var r = SysSocket.select(null, [__socket], null, 0);
				if (r.write[0] == __socket)
				{
					doConnect = true;
				}
				else if (Sys.time() - __timestamp > timeout / 1000)
				{
					doClose = true;
				}
				else
				{
					// try again later
					return;
				}
			}
			catch (e:Dynamic)
			{
				doClose = true;
			}
		}

		if (doClose)
		{
			__cleanSocket();

			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Connection failed"));
			return;
		}
		else if (doConnect)
		{
			var secureSocket:SysSecureSocket = cast __socket;
			var blocked = false;
			try
			{
				secureSocket.handshake();
				blocked = false;
			}
			catch (e:Error)
			{
				switch (e)
				{
					case Error.Blocked:
						blocked = true;
					case Error.Custom(Error.Blocked):
						blocked = true;
					default:
						__serverCertificateStatus = INVALID;
						__cleanSocket();
						dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, Std.string(e)));
						return;
				}
			}
			catch (e:Dynamic)
			{
				__serverCertificateStatus = INVALID;
				__cleanSocket();
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, Std.string(e)));
				return;
			}
			if (blocked)
			{
				// try again next frame. we shouldn't try the handshake
				// repeatedly in a loop because it can cause rendering to
				// noticeably hang until the socket is unblocked, especially if
				// there are multiple sockets connecting at once.
				return;
			}
			__peerCertificate = secureSocket.peerCertificate();
			if (__peerCertificate != null)
			{
				__serverCertificateStatus = TRUSTED;
			}
			else
			{
				__serverCertificateStatus = INVALID;
				__cleanSocket();
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Invalid certificate"));
				return;
			}
		}
		#end
		super.this_onEnterFrame(event);
	}
}
#else
typedef SecureSocket = flash.net.SecureSocket;
#end
