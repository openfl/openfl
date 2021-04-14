package openfl.net;

#if !flash
import haxe.io.Bytes;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.utils.ByteArray;
#if lime
import lime.net.HTTPRequest;
import lime.net.HTTPRequestHeader;
#end

/**
	The URLLoader class downloads data from a URL as text, binary data, or
	URL-encoded variables. It is useful for downloading text files, XML, or
	other information to be used in a dynamic, data-driven application.

	A URLLoader object downloads all of the data from a URL before making it
	available to code in the applications. It sends out notifications about the
	progress of the download, which you can monitor through the
	`bytesLoaded` and `bytesTotal` properties, as well as
	through dispatched events.

	When loading very large video files, such as FLV's, out-of-memory errors
	may occur.

	When you use this class in Flash Player and in AIR application content
	in security sandboxes other than then application security sandbox,
	consider the following security model:


	* A SWF file in the local-with-filesystem sandbox may not load data
	from, or provide data to, a resource that is in the network sandbox.
	*  By default, the calling SWF file and the URL you load must be in
	exactly the same domain. For example, a SWF file at www.adobe.com can load
	data only from sources that are also at www.adobe.com. To load data from a
	different domain, place a URL policy file on the server hosting the
	data.


	For more information related to security, see the Flash Player Developer
	Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

	@event complete           Dispatched after all the received data is decoded
							  and placed in the data property of the URLLoader
							  object. The received data may be accessed once
							  this event has been dispatched.
	@event httpResponseStatus Dispatched if a call to the load() method
							  attempts to access data over HTTP, and Adobe AIR
							  is able to detect and return the status code for
							  the request.
	@event httpStatus         Dispatched if a call to URLLoader.load() attempts
							  to access data over HTTP. For content running in
							  Flash Player, this event is only dispatched if
							  the current Flash Player environment is able to
							  detect and return the status code for the
							  request.(Some browser environments may not be
							  able to provide this information.) Note that the
							  `httpStatus` event(if any) is sent
							  before(and in addition to) any
							  `complete` or `error`
							  event.
	@event ioError            Dispatched if a call to URLLoader.load() results
							  in a fatal error that terminates the download.
	@event open               Dispatched when the download operation commences
							  following a call to the
							  `URLLoader.load()` method.
	@event progress           Dispatched when data is received as the download
							  operation progresses.

							  Note that with a URLLoader object, it is not
							  possible to access the data until it has been
							  received completely. So, the progress event only
							  serves as a notification of how far the download
							  has progressed. To access the data before it's
							  entirely downloaded, use a URLStream object.
	@event securityError      Dispatched if a call to URLLoader.load() attempts
							  to load data from a server outside the security
							  sandbox. Also dispatched if a call to
							  `URLLoader.load()` attempts to load a
							  SWZ file and the certificate is invalid or the
							  digest string does not match the component.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class URLLoader extends EventDispatcher
{
	/**
		Indicates the number of bytes that have been loaded thus far during the
		load operation.
	**/
	public var bytesLoaded:Int;

	/**
		Indicates the total number of bytes in the downloaded data. This property
		contains 0 while the load operation is in progress and is populated when
		the operation is complete. Also, a missing Content-Length header will
		result in bytesTotal being indeterminate.
	**/
	public var bytesTotal:Int;

	/**
		The data received from the load operation. This property is populated only
		when the load operation is complete. The format of the data depends on the
		setting of the `dataFormat` property:

		If the `dataFormat` property is
		`URLLoaderDataFormat.TEXT`, the received data is a string
		containing the text of the loaded file.

		If the `dataFormat` property is
		`URLLoaderDataFormat.BINARY`, the received data is a ByteArray
		object containing the raw binary data.

		If the `dataFormat` property is
		`URLLoaderDataFormat.VARIABLES`, the received data is a
		URLVariables object containing the URL-encoded variables.
	**/
	public var data:Dynamic;

	/**
		Controls whether the downloaded data is received as text
		(`URLLoaderDataFormat.TEXT`), raw binary data
		(`URLLoaderDataFormat.BINARY`), or URL-encoded variables
		(`URLLoaderDataFormat.VARIABLES`).

		If the value of the `dataFormat` property is
		`URLLoaderDataFormat.TEXT`, the received data is a string
		containing the text of the loaded file.

		If the value of the `dataFormat` property is
		`URLLoaderDataFormat.BINARY`, the received data is a ByteArray
		object containing the raw binary data.

		If the value of the `dataFormat` property is
		`URLLoaderDataFormat.VARIABLES`, the received data is a
		URLVariables object containing the URL-encoded variables.

		@default URLLoaderDataFormat.TEXT
	**/
	public var dataFormat:URLLoaderDataFormat;

	@:noCompletion private var __httpRequest:#if (!lime || display || macro || doc_gen) Dynamic #else _IHTTPRequest #end; // TODO: Better (non-private) solution

	/**
		Creates a URLLoader object.

		@param request A URLRequest object specifying the URL to download. If this
					   parameter is omitted, no load operation begins. If
					   specified, the load operation begins immediately(see the
					   `load` entry for more information).
	**/
	public function new(request:URLRequest = null)
	{
		super();

		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;

		if (request != null)
		{
			load(request);
		}
	}

	/**
		Closes the load operation in progress. Any load operation in progress is
		immediately terminated. If no URL is currently being streamed, an invalid
		stream error is thrown.

	**/
	public function close():Void
	{
		if (__httpRequest != null)
		{
			__httpRequest.cancel();
		}
	}

	/**
		Sends and loads data from the specified URL. The data can be received as
		text, raw binary data, or URL-encoded variables, depending on the value
		you set for the `dataFormat` property. Note that the default
		value of the `dataFormat` property is text. If you want to send
		data to the specified URL, you can set the `data` property in
		the URLRequest object.

		**Note:** If a file being loaded contains non-ASCII characters(as
		found in many non-English languages), it is recommended that you save the
		file with UTF-8 or UTF-16 encoding as opposed to a non-Unicode format like
		ASCII.

		 A SWF file in the local-with-filesystem sandbox may not load data
		from, or provide data to, a resource that is in the network sandbox.

		 By default, the calling SWF file and the URL you load must be in
		exactly the same domain. For example, a SWF file at www.adobe.com can load
		data only from sources that are also at www.adobe.com. To load data from a
		different domain, place a URL policy file on the server hosting the
		data.

		You cannot connect to commonly reserved ports. For a complete list of
		blocked ports, see "Restricting Networking APIs" in the _ActionScript
		3.0 Developer's Guide_.

		 In Flash Player 10 and later, if you use a multipart Content-Type(for
		example "multipart/form-data") that contains an upload(indicated by a
		"filename" parameter in a "content-disposition" header within the POST
		body), the POST operation is subject to the security rules applied to
		uploads:

		* The POST operation must be performed in response to a user-initiated
		action, such as a mouse click or key press.
		* If the POST operation is cross-domain(the POST target is not on the
		same server as the SWF file that is sending the POST request), the target
		server must provide a URL policy file that permits cross-domain
		access.

		Also, for any multipart Content-Type, the syntax must be valid
		(according to the RFC2046 standards). If the syntax appears to be invalid,
		the POST operation is subject to the security rules applied to
		uploads.

		For more information related to security, see the Flash Player
		Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		@param request A URLRequest object specifying the URL to download.
		@throws ArgumentError `URLRequest.requestHeader` objects may
							  not contain certain prohibited HTTP request headers.
							  For more information, see the URLRequestHeader class
							  description.
		@throws MemoryError   This error can occur for the following reasons: 1)
							  Flash Player or AIR cannot convert the
							  `URLRequest.data` parameter from UTF8 to
							  MBCS. This error is applicable if the URLRequest
							  object passed to `load()` is set to
							  perform a `GET` operation and if
							  `System.useCodePage` is set to
							  `true`. 2) Flash Player or AIR cannot
							  allocate memory for the `POST` data. This
							  error is applicable if the URLRequest object passed
							  to `load` is set to perform a
							  `POST` operation.
		@throws SecurityError Local untrusted files may not communicate with the
							  Internet. This may be worked around by reclassifying
							  this file as local-with-networking or trusted.
		@throws SecurityError You are trying to connect to a commonly reserved
							  port. For a complete list of blocked ports, see
							  "Restricting Networking APIs" in the _ActionScript
							  3.0 Developer's Guide_.
		@throws TypeError     The value of the request parameter or the
							  `URLRequest.url` property of the
							  URLRequest object passed are `null`.
		@event complete           Dispatched after data has loaded successfully.
		@event httpResponseStatus Dispatched if a call to the `load()`
								  method attempts to access data over HTTP and
								  Adobe AIR is able to detect and return the
								  status code for the request.
		@event httpStatus         If access is over HTTP, and the current Flash
								  Player environment supports obtaining status
								  codes, you may receive these events in addition
								  to any `complete` or
								  `error` event.
		@event ioError            The load operation could not be completed.
		@event open               Dispatched when a load operation commences.
		@event progress           Dispatched when data is received as the download
								  operation progresses.
		@event securityError      A load operation attempted to retrieve data from
								  a server outside the caller's security sandbox.
								  This may be worked around using a policy file on
								  the server.
		@event securityError      A load operation attempted to load a SWZ file(a
								  Adobe platform component), but the certificate
								  is invalid or the digest does not match the
								  component.
	**/
	public function load(request:URLRequest):Void
	{
		#if (lime && !macro)
		if (dataFormat == BINARY)
		{
			var httpRequest = new HTTPRequest<ByteArray>();
			__prepareRequest(httpRequest, request);

			httpRequest.load()
				.onProgress(httpRequest_onProgress)
				.onError(httpRequest_onError)
				.onComplete(function(data:ByteArray):Void
				{
					__dispatchStatus();
					this.data = data;

					var event = new Event(Event.COMPLETE);
					dispatchEvent(event);
				});
		}
		else
		{
			var httpRequest = new HTTPRequest<String>();
			__prepareRequest(httpRequest, request);

			httpRequest.load()
				.onProgress(httpRequest_onProgress)
				.onError(httpRequest_onError)
				.onComplete(function(data:String):Void
				{
					__dispatchStatus();
					this.data = data;

					var event = new Event(Event.COMPLETE);
					dispatchEvent(event);
				});
		}
		#end
	}

	@:noCompletion private function __dispatchStatus():Void
	{
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, __httpRequest.responseStatus);
		event.responseURL = __httpRequest.uri;

		var headers = new Array<URLRequestHeader>();

		#if (lime && !display && !macro && !doc_gen)
		if (__httpRequest.enableResponseHeaders && __httpRequest.responseHeaders != null)
		{
			for (header in __httpRequest.responseHeaders)
			{
				headers.push(new URLRequestHeader(header.name, header.value));
			}
		}
		#end

		event.responseHeaders = headers;
		dispatchEvent(event);
	}

	@:noCompletion private function __prepareRequest(httpRequest:#if (!lime || display || macro || doc_gen) Dynamic #else _IHTTPRequest #end,
			request:URLRequest):Void
	{
		#if lime
		__httpRequest = httpRequest;
		__httpRequest.uri = request.url;
		__httpRequest.method = request.method;

		if (request.data != null)
		{
			if (Type.typeof(request.data) == Type.ValueType.TObject)
			{
				var fields = Reflect.fields(request.data);

				for (field in fields)
				{
					__httpRequest.formData.set(field, Reflect.field(request.data, field));
				}
			}
			else if ((request.data is Bytes))
			{
				__httpRequest.data = request.data;
			}
			else
			{
				__httpRequest.data = Bytes.ofString(Std.string(request.data));
			}
		}

		__httpRequest.contentType = request.contentType;

		if (request.requestHeaders != null)
		{
			for (header in request.requestHeaders)
			{
				__httpRequest.headers.push(new HTTPRequestHeader(header.name, header.value));
			}
		}

		__httpRequest.followRedirects = request.followRedirects;
		__httpRequest.timeout = Std.int(request.idleTimeout);
		__httpRequest.withCredentials = request.manageCookies;

		// TODO: Better user agent?
		var userAgent = request.userAgent;
		if (userAgent == null) userAgent = "Mozilla/5.0 (Windows; U; en) AppleWebKit/420+ (KHTML, like Gecko) OpenFL/1.0";

		__httpRequest.userAgent = request.userAgent;
		__httpRequest.enableResponseHeaders = true;
		#end
	}

	// Event Handlers
	@:noCompletion private function httpRequest_onError(error:Dynamic):Void
	{
		__dispatchStatus();

		if (error == 403)
		{
			var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
			event.text = Std.string(error);
			dispatchEvent(event);
		}
		else
		{
			var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			event.text = Std.string(error);
			dispatchEvent(event);
		}
	}

	@:noCompletion private function httpRequest_onProgress(bytesLoaded:Int, bytesTotal:Int):Void
	{
		var event = new ProgressEvent(ProgressEvent.PROGRESS);
		event.bytesLoaded = bytesLoaded;
		event.bytesTotal = bytesTotal;
		dispatchEvent(event);
	}
}
#else
typedef URLLoader = flash.net.URLLoader;
#end
