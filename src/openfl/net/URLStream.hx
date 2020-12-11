package openfl.net;

#if !flash
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.IDataInput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
	The URLStream class provides low-level access to downloading URLs. Data is
	made available to application code immediately as it is downloaded,
	instead of waiting until the entire file is complete as with URLLoader.
	The URLStream class also lets you close a stream before it finishes
	downloading. The contents of the downloaded file are made available as raw
	binary data.
	The read operations in URLStream are nonblocking. This means that you must
	use the `bytesAvailable` property to determine whether sufficient data is
	available before reading it. An `EOFError` exception is thrown if
	insufficient data is available.

	All binary data is encoded by default in big-endian format, with the most
	significant byte first.

	The security rules that apply to URL downloading with the URLStream class
	are identical to the rules applied to URLLoader objects. Policy files may
	be downloaded as needed. Local file security rules are enforced, and
	security warnings are raised as needed.

	@event complete           Dispatched when data has loaded successfully.
	@event httpResponseStatus Dispatched if a call to the `URLStream.load()`
							  method attempts to access data over HTTP and
							  Adobe AIR is able to detect and return the
							  status code for the request.
							  If a URLStream object registers for an
							  `httpStatusEvent` event, error responses are
							  delivered as though they are content. So instead
							  of dispatching an `ioError` event, the URLStream
							  dispatches `progress` and `complete` events as
							  the error data is loaded into the URLStream.
	@event httpStatus         Dispatched if a call to `URLStream.load()`
							  attempts to access data over HTTP, and Flash
							  Player or Adobe AIR is able to detect and return
							  the status code for the request. (Some browser
							  environments may not be able to provide this
							  information.) Note that the `httpStatus` (if
							  any) will be sent before (and in addition to)
							  any `complete` or `error` event.
	@event ioError            Dispatched when an input/output error occurs
							  that causes a load operation to fail.
	@event open               Dispatched when a load operation starts.
	@event progress           Dispatched when data is received as the download
							  operation progresses. Data that has been
							  received can be read immediately using the
							  methods of the URLStream class.
	@event securityError      Dispatched if a call to `URLStream.load()`
							  attempts to load data from a server outside the
							  security sandbox.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class URLStream extends EventDispatcher implements IDataInput
{
	/**
		Returns the number of bytes of data available for reading in the input
		buffer. Your code must call the `bytesAvailable` property to ensure
		that sufficient data is available before you try to read it with one
		of the `read` methods.
	**/
	public var bytesAvailable(get, never):UInt;

	/**
		Indicates whether this URLStream object is currently connected. A call
		to this property returns a value of `true` if the URLStream object is
		connected, or `false` otherwise.
	**/
	public var connected(get, never):Bool;

	// @:require(flash11_4) public var diskCacheEnabled (default, null):Bool;

	/**
		Indicates the byte order for the data. Possible values are
		`Endian.BIG_ENDIAN` or `Endian.LITTLE_ENDIAN`.

		@default Endian.BIG_ENDIAN
	**/
	public var endian(get, set):Endian;

	// @:require(flash11_4) public var length (default, null):Float;

	/**
		Controls the version of Action Message Format (AMF) used when writing
		or reading an object.
	**/
	public var objectEncoding:ObjectEncoding;

	// @:require(flash11_4) public var position:Float;
	@:noCompletion private var __data:ByteArray;
	@:noCompletion private var __loader:URLLoader;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(URLStream.prototype, {
			"bytesAvailable": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bytesAvailable (); }")},
			"connected": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_connected (); }")},
			"endian": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_endian (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_endian (v); }")
			},
		});
	}
	#end

	public function new()
	{
		super();

		__loader = new URLLoader();
		__loader.dataFormat = URLLoaderDataFormat.BINARY;
	}

	/**
		Immediately closes the stream and cancels the download operation. No
		data can be read from the stream after the `close()` method is called.

		@throws IOError The stream could not be closed, or the stream was not
						open.
	**/
	public function close():Void
	{
		__removeEventListeners();
		__data = null;
	}

	/**
		Begins downloading the URL specified in the `request` parameter.
		**Note**: If a file being loaded contains non-ASCII characters (as
		found in many non-English languages), it is recommended that you save
		the file with UTF-8 or UTF-16 encoding, as opposed to a non-Unicode
		format like ASCII.

		If the loading operation fails immediately, an IOError or
		SecurityError (including the local file security error) exception is
		thrown describing the failure. Otherwise, an `open` event is
		dispatched if the URL download starts downloading successfully, or an
		error event is dispatched if an error occurs.

		By default, the calling SWF file and the URL you load must be in
		exactly the same domain. For example, a SWF file at www.adobe.com can
		load data only from sources that are also at www.adobe.com. To load
		data from a different domain, place a URL policy file on the server
		hosting the data.

		In Flash Player, you cannot connect to commonly reserved ports. For a
		complete list of blocked ports, see "Restricting Networking APIs" in
		the _ActionScript 3.0 Developer's Guide_.

		In Flash Player, you can prevent a SWF file from using this method by
		setting the `allowNetworking` parameter of the the `object` and
		`embed` tags in the HTML page that contains the SWF content.

		In Flash Player 10 and later, and in AIR 1.5 and later, if you use a
		multipart Content-Type (for example "multipart/form-data") that
		contains an upload (indicated by a "filename" parameter in a
		"content-disposition" header within the POST body), the POST operation
		is subject to the security rules applied to uploads:

		* The POST operation must be performed in response to a user-initiated
		action, such as a mouse click or key press.
		* If the POST operation is cross-domain (the POST target is not on the
		same server as the SWF file that is sending the POST request), the
		target server must provide a URL policy file that permits cross-domain
		access.

		Also, for any multipart Content-Type, the syntax must be valid
		(according to the RFC2046 standards). If the syntax appears to be
		invalid, the POST operation is subject to the security rules applied
		to uploads.

		These rules also apply to AIR content in non-application sandboxes.
		However, in Adobe AIR, content in the application sandbox (content
		installed with the AIR application) are not restricted by these
		security limitations.

		For more information related to security, see The Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		In AIR, a URLRequest object can register for the `httpResponse` status
		event. Unlike the `httpStatus` event, the `httpResponseStatus` event
		is delivered before any response data. Also, the `httpResponseStatus`
		event includes values for the `responseHeaders` and `responseURL`
		properties (which are undefined for an `httpStatus` event. Note that
		the `httpResponseStatus` event (if any) will be sent before (and in
		addition to) any `complete` or `error` event.

		If there _is_ an `httpResponseStatus` event listener, the body of the
		response message is _always_ sent; and HTTP status code responses
		always results in a `complete` event. This is true in spite of whether
		the HTTP response status code indicates a success or an error.

		In AIR, if there is _no_ `httpResponseStatus` event listener, the
		behavior differs based on the SWF version:

		* For SWF 9 content, the body of the HTTP response message is sent
		_only if_ the HTTP response status code indicates success. Otherwise
		(if there is an error), no body is sent and the URLRequest object
		dispatches an IOError event.
		* For SWF 10 content, the body of the HTTP response message is
		_always_ sent. If there is an error, the URLRequest object dispatches
		an IOError event.

		@param request A URLRequest object specifying the URL to download. If
					   the value of this parameter or the `URLRequest.url`
					   property of the URLRequest object passed are `null`,
					   the application throws a null pointer error.
		@throws ArgumentError `URLRequest.requestHeader` objects may not
							  contain certain prohibited HTTP request headers.
							  For more information, see the URLRequestHeader
							  class description.
		@throws MemoryError   This error can occur for the following reasons:
							  1. Flash Player or Adobe AIR cannot convert the
							  `URLRequest.data` parameter from UTF8 to MBCS.
							  This error is applicable if the URLRequest
							  object passed to `load()` is set to perform a
							  `GET` operation and if `System.useCodePage` is
							  set to `true`.
							  2. Flash Player or Adobe AIR cannot allocate
							  memory for the `POST` data. This error is
							  applicable if the URLRequest object passed to
							  load is set to perform a `POST` operation.
		@throws SecurityError Local untrusted SWF files may not communicate
							  with the Internet. This may be worked around by
							  reclassifying this SWF file as
							  local-with-networking or trusted.
		@throws SecurityError You are trying to connect to a commonly reserved
							  port. For a complete list of blocked ports, see
							  "Restricting Networking APIs" in the
							  _ActionScript 3.0 Developer's Guide_.
		@event complete           Dispatched after data has loaded
								  successfully. If there is a
								  `httpResponseStatus` event listener, the
								  URLRequest object also dispatches a
								  `complete` event whether the HTTP response
								  status code indicates a success _or_ an
								  error.
		@event httpResponseStatus Dispatched if a call to the `load()` method
								  attempts to access data over HTTP and Adobe
								  AIR is able to detect and return the status
								  code for the request.
		@event httpStatus         If access is by HTTP and the current
								  environment supports obtaining status codes,
								  you may receive these events in addition to
								  any `complete` or `error` event.
		@event ioError            The load operation could not be completed.
		@event open               Dispatched when a load operation starts.
		@event securityError      A load operation attempted to retrieve data
								  from a server outside the caller's security
								  sandbox. This may be worked around using a
								  policy file on the server.
	**/
	public function load(request:URLRequest):Void
	{
		__removeEventListeners();
		__addEventListeners();

		__loader.load(request);
	}

	/**
		Reads a Boolean value from the stream. A single byte is read, and
		`true` is returned if the byte is nonzero, `false` otherwise.

		@return `True` is returned if the byte is nonzero, `false` otherwise.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readBoolean():Bool
	{
		return __data.readBoolean();
	}

	/**
		Reads a signed byte from the stream.
		The returned value is in the range -128...127.

		@return Value in the range -128...127.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readByte():Int
	{
		return __data.readByte();
	}

	/**
		Reads `length` bytes of data from the stream. The bytes are read into
		the ByteArray object specified by `bytes`, starting `offset` bytes
		into the ByteArray object.

		@param bytes  The ByteArray object to read data into.
		@param offset The offset into `bytes` at which data read should begin.
					  Defaults to 0.
		@param length The number of bytes to read. The default value of 0 will
					  cause all available data to be read.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void
	{
		__data.readBytes(bytes, offset, length);
	}

	/**
		Reads an IEEE 754 double-precision floating-point number from the
		stream.

		@return An IEEE 754 double-precision floating-point number from the
				stream.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readDouble():Float
	{
		return __data.readDouble();
	}

	/**
		Reads an IEEE 754 single-precision floating-point number from the
		stream.

		@return An IEEE 754 single-precision floating-point number from the
				stream.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readFloat():Float
	{
		return __data.readFloat();
	}

	/**
		Reads a signed 32-bit integer from the stream.
		The returned value is in the range -2147483648...2147483647.

		@return Value in the range -2147483648...2147483647.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readInt():Int
	{
		return __data.readInt();
	}

	/**
		Reads a multibyte string of specified length from the byte stream
		using the specified character set.

		@param length  The number of bytes from the byte stream to read.
		@param charSet The string denoting the character set to use to
					   interpret the bytes. Possible character set strings
					   include `"shift_jis"`, `"CN-GB"`, `"iso-8859-1"`, and
					   others. For a complete list, see <a
					   href="../../charset-codes.html">Supported Character
					   Sets</a>.
					   **Note:** If the value for the `charSet` parameter is
					   not recognized by the current system, the application
					   uses the system's default code page as the character
					   set. For example, a value for the `charSet` parameter,
					   as in `myTest.readMultiByte(22, "iso-8859-01")` that
					   uses `01` instead of `1` might work on your development
					   machine, but not on another machine. On the other
					   machine, the application will use the system's default
					   code page.
		@return UTF-8 encoded string.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
	**/
	public function readMultiByte(length:UInt, charSet:String):String
	{
		return __data.readMultiByte(length, charSet);
	}

	/**
		Reads an object from the socket, encoded in Action Message Format
		(AMF).

		@return The deserialized object.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readObject():Dynamic
	{
		return null;
	}

	/**
		Reads a signed 16-bit integer from the stream.
		The returned value is in the range -32768...32767.

		@return Value in the range -32768...32767.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readShort():Int
	{
		return __data.readShort();
	}

	/**
		Reads an unsigned byte from the stream.
		The returned value is in the range 0...255.

		@return Value in the range 0...255.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readUnsignedByte():UInt
	{
		return __data.readUnsignedByte();
	}

	/**
		Reads an unsigned 32-bit integer from the stream.
		The returned value is in the range 0...4294967295.

		@return Value in the range 0...4294967295.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readUnsignedInt():UInt
	{
		return __data.readUnsignedInt();
	}

	/**
		Reads an unsigned 16-bit integer from the stream.
		The returned value is in the range 0...65535.

		@return Value in the range 0...65535.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readUnsignedShort():UInt
	{
		return __data.readUnsignedShort();
	}

	/**
		Reads a UTF-8 string from the stream. The string is assumed to be
		prefixed with an unsigned short indicating the length in bytes.

		@return A UTF-8 string.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readUTF():String
	{
		return __data.readUTF();
	}

	/**
		Reads a sequence of `length` UTF-8 bytes from the stream, and returns
		a string.

		@param length A sequence of UTF-8 bytes.
		@return A UTF-8 string produced by the byte representation of
				characters of specified length.
		@throws EOFError There is insufficient data available to read. If a
						 local SWF file triggers a security warning, Flash
						 Player prevents the URLStream data from being
						 available to ActionScript. When this happens, the
						 `bytesAvailable` property returns 0 even if data has
						 been received, and any of the read methods throws an
						 EOFError exception.
		@throws IOError  An I/O error occurred on the stream, or the stream is
						 not open.
	**/
	public function readUTFBytes(length:UInt):String
	{
		return __data.readUTFBytes(length);
	}

	// @:require(flash11_4) public function stop ():Void;
	@:noCompletion private function __addEventListeners():Void
	{
		__loader.addEventListener(Event.COMPLETE, loader_onComplete);
		__loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.addEventListener(ProgressEvent.PROGRESS, loader_onProgressEvent);
	}

	@:noCompletion private function __removeEventListeners():Void
	{
		__loader.removeEventListener(Event.COMPLETE, loader_onComplete);
		__loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_onIOError);
		__loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
		__loader.removeEventListener(ProgressEvent.PROGRESS, loader_onProgressEvent);
	}

	// Event Handlers
	@:noCompletion private function loader_onComplete(event:Event):Void
	{
		__removeEventListeners();
		__data = __loader.data;

		dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, __loader.bytesLoaded, __loader.bytesTotal));
		dispatchEvent(new Event(Event.COMPLETE));
	}

	@:noCompletion private function loader_onIOError(event:IOErrorEvent):Void
	{
		__removeEventListeners();

		dispatchEvent(event);
	}

	@:noCompletion private function loader_onSecurityError(event:SecurityErrorEvent):Void
	{
		__removeEventListeners();

		dispatchEvent(event);
	}

	@:noCompletion private function loader_onProgressEvent(event:ProgressEvent):Void
	{
		__data = __loader.data;
		dispatchEvent(event);
	}

	// Get & Set Methods
	private function get_bytesAvailable():UInt
	{
		if (__data != null)
		{
			return __data.length - __data.position;
		}

		return 0;
	}

	private function get_connected():Bool
	{
		return false;
	}

	private function get_endian():Endian
	{
		return __data.endian;
	}

	private function set_endian(value:Endian):Endian
	{
		return __data.endian = value;
	}
}
#else
typedef URLStream = flash.net.URLStream;
#end
