package openfl.net; #if !flash #if (!openfl_legacy || disable_legacy_networking)


import haxe.io.Bytes;
import lime.app.Event;
import lime.system.BackgroundWorker;
import lime.utils.ByteArray;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.errors.IOError;
import openfl.events.SecurityErrorEvent;
import openfl.utils.ByteArray;

#if (js && html5)
import js.html.EventTarget;
import js.html.XMLHttpRequest;
import js.Browser;
import js.Lib;
#end

#if lime_curl
import lime.net.curl.CURL;
import lime.net.curl.CURLEasy;
import lime.net.curl.CURLCode;
import lime.net.curl.CURLInfo;
import lime.net.curl.CURLOption;
#end


/**
 * The URLLoader class downloads data from a URL as text, binary data, or
 * URL-encoded variables. It is useful for downloading text files, XML, or
 * other information to be used in a dynamic, data-driven application.
 *
 * <p>A URLLoader object downloads all of the data from a URL before making it
 * available to code in the applications. It sends out notifications about the
 * progress of the download, which you can monitor through the
 * <code>bytesLoaded</code> and <code>bytesTotal</code> properties, as well as
 * through dispatched events.</p>
 *
 * <p>When loading very large video files, such as FLV's, out-of-memory errors
 * may occur. </p>
 *
 * <p>When you use this class in Flash Player and in AIR application content
 * in security sandboxes other than then application security sandbox,
 * consider the following security model:</p>
 *
 * <ul>
 *   <li>A SWF file in the local-with-filesystem sandbox may not load data
 * from, or provide data to, a resource that is in the network sandbox. </li>
 *   <li> By default, the calling SWF file and the URL you load must be in
 * exactly the same domain. For example, a SWF file at www.adobe.com can load
 * data only from sources that are also at www.adobe.com. To load data from a
 * different domain, place a URL policy file on the server hosting the
 * data.</li>
 * </ul>
 *
 * <p>For more information related to security, see the Flash Player Developer
 * Center Topic: <a href="http://www.adobe.com/go/devnet_security_en"
 * scope="external">Security</a>.</p>
 * 
 * @event complete           Dispatched after all the received data is decoded
 *                           and placed in the data property of the URLLoader
 *                           object. The received data may be accessed once
 *                           this event has been dispatched.
 * @event httpResponseStatus Dispatched if a call to the load() method
 *                           attempts to access data over HTTP, and Adobe AIR
 *                           is able to detect and return the status code for
 *                           the request.
 * @event httpStatus         Dispatched if a call to URLLoader.load() attempts
 *                           to access data over HTTP. For content running in
 *                           Flash Player, this event is only dispatched if
 *                           the current Flash Player environment is able to
 *                           detect and return the status code for the
 *                           request.(Some browser environments may not be
 *                           able to provide this information.) Note that the
 *                           <code>httpStatus</code> event(if any) is sent
 *                           before(and in addition to) any
 *                           <code>complete</code> or <code>error</code>
 *                           event.
 * @event ioError            Dispatched if a call to URLLoader.load() results
 *                           in a fatal error that terminates the download.
 * @event open               Dispatched when the download operation commences
 *                           following a call to the
 *                           <code>URLLoader.load()</code> method.
 * @event progress           Dispatched when data is received as the download
 *                           operation progresses.
 *
 *                           <p>Note that with a URLLoader object, it is not
 *                           possible to access the data until it has been
 *                           received completely. So, the progress event only
 *                           serves as a notification of how far the download
 *                           has progressed. To access the data before it's
 *                           entirely downloaded, use a URLStream object. </p>
 * @event securityError      Dispatched if a call to URLLoader.load() attempts
 *                           to load data from a server outside the security
 *                           sandbox. Also dispatched if a call to
 *                           <code>URLLoader.load()</code> attempts to load a
 *                           SWZ file and the certificate is invalid or the
 *                           digest string does not match the component.
 */
class URLLoader extends EventDispatcher {
	
	
	/**
	 * Indicates the number of bytes that have been loaded thus far during the
	 * load operation.
	 */
	public var bytesLoaded:Int;
	
	/**
	 * Indicates the total number of bytes in the downloaded data. This property
	 * contains 0 while the load operation is in progress and is populated when
	 * the operation is complete. Also, a missing Content-Length header will
	 * result in bytesTotal being indeterminate.
	 */
	public var bytesTotal:Int;
	
	/**
	 * The data received from the load operation. This property is populated only
	 * when the load operation is complete. The format of the data depends on the
	 * setting of the <code>dataFormat</code> property:
	 *
	 * <p>If the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.TEXT</code>, the received data is a string
	 * containing the text of the loaded file.</p>
	 *
	 * <p>If the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.BINARY</code>, the received data is a ByteArray
	 * object containing the raw binary data.</p>
	 *
	 * <p>If the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.VARIABLES</code>, the received data is a
	 * URLVariables object containing the URL-encoded variables.</p>
	 */
	public var data:Dynamic;
	
	/**
	 * Controls whether the downloaded data is received as text
	 * (<code>URLLoaderDataFormat.TEXT</code>), raw binary data
	 * (<code>URLLoaderDataFormat.BINARY</code>), or URL-encoded variables
	 * (<code>URLLoaderDataFormat.VARIABLES</code>).
	 *
	 * <p>If the value of the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.TEXT</code>, the received data is a string
	 * containing the text of the loaded file.</p>
	 *
	 * <p>If the value of the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.BINARY</code>, the received data is a ByteArray
	 * object containing the raw binary data.</p>
	 *
	 * <p>If the value of the <code>dataFormat</code> property is
	 * <code>URLLoaderDataFormat.VARIABLES</code>, the received data is a
	 * URLVariables object containing the URL-encoded variables.</p>
	 * 
	 * @default URLLoaderDataFormat.TEXT
	 */
	public var dataFormat (default, set):URLLoaderDataFormat;
	
	
	#if lime_curl
	private var __curl:CURL;
	private var __data:ByteArray;
	#end
	
	
	/**
	 * Creates a URLLoader object.
	 * 
	 * @param request A URLRequest object specifying the URL to download. If this
	 *                parameter is omitted, no load operation begins. If
	 *                specified, the load operation begins immediately(see the
	 *                <code>load</code> entry for more information).
	 */
	public function new (request:URLRequest = null) {
		
		super ();
		
		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;
		
		#if lime_curl
		__data = new ByteArray ();
		__curl = CURLEasy.init ();
		#end
		
		if (request != null) {
			
			load (request);
			
		}
		
	}
	
	
	/**
	 * Closes the load operation in progress. Any load operation in progress is
	 * immediately terminated. If no URL is currently being streamed, an invalid
	 * stream error is thrown.
	 * 
	 */
	public function close ():Void {
		
		#if lime_curl
		CURLEasy.cleanup (__curl);
		#end
		
	}
	
	
	private dynamic function getData ():Dynamic {
		
		return null;
		
	}
	
	
	/**
	 * Sends and loads data from the specified URL. The data can be received as
	 * text, raw binary data, or URL-encoded variables, depending on the value
	 * you set for the <code>dataFormat</code> property. Note that the default
	 * value of the <code>dataFormat</code> property is text. If you want to send
	 * data to the specified URL, you can set the <code>data</code> property in
	 * the URLRequest object.
	 *
	 * <p><b>Note:</b> If a file being loaded contains non-ASCII characters(as
	 * found in many non-English languages), it is recommended that you save the
	 * file with UTF-8 or UTF-16 encoding as opposed to a non-Unicode format like
	 * ASCII.</p>
	 *
	 * <p> A SWF file in the local-with-filesystem sandbox may not load data
	 * from, or provide data to, a resource that is in the network sandbox.</p>
	 *
	 * <p> By default, the calling SWF file and the URL you load must be in
	 * exactly the same domain. For example, a SWF file at www.adobe.com can load
	 * data only from sources that are also at www.adobe.com. To load data from a
	 * different domain, place a URL policy file on the server hosting the
	 * data.</p>
	 *
	 * <p>You cannot connect to commonly reserved ports. For a complete list of
	 * blocked ports, see "Restricting Networking APIs" in the <i>ActionScript
	 * 3.0 Developer's Guide</i>.</p>
	 *
	 * <p> In Flash Player 10 and later, if you use a multipart Content-Type(for
	 * example "multipart/form-data") that contains an upload(indicated by a
	 * "filename" parameter in a "content-disposition" header within the POST
	 * body), the POST operation is subject to the security rules applied to
	 * uploads:</p>
	 *
	 * <ul>
	 *   <li>The POST operation must be performed in response to a user-initiated
	 * action, such as a mouse click or key press.</li>
	 *   <li>If the POST operation is cross-domain(the POST target is not on the
	 * same server as the SWF file that is sending the POST request), the target
	 * server must provide a URL policy file that permits cross-domain
	 * access.</li>
	 * </ul>
	 *
	 * <p>Also, for any multipart Content-Type, the syntax must be valid
	 * (according to the RFC2046 standards). If the syntax appears to be invalid,
	 * the POST operation is subject to the security rules applied to
	 * uploads.</p>
	 *
	 * <p>For more information related to security, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @param request A URLRequest object specifying the URL to download.
	 * @throws ArgumentError <code>URLRequest.requestHeader</code> objects may
	 *                       not contain certain prohibited HTTP request headers.
	 *                       For more information, see the URLRequestHeader class
	 *                       description.
	 * @throws MemoryError   This error can occur for the following reasons: 1)
	 *                       Flash Player or AIR cannot convert the
	 *                       <code>URLRequest.data</code> parameter from UTF8 to
	 *                       MBCS. This error is applicable if the URLRequest
	 *                       object passed to <code>load()</code> is set to
	 *                       perform a <code>GET</code> operation and if
	 *                       <code>System.useCodePage</code> is set to
	 *                       <code>true</code>. 2) Flash Player or AIR cannot
	 *                       allocate memory for the <code>POST</code> data. This
	 *                       error is applicable if the URLRequest object passed
	 *                       to <code>load</code> is set to perform a
	 *                       <code>POST</code> operation.
	 * @throws SecurityError Local untrusted files may not communicate with the
	 *                       Internet. This may be worked around by reclassifying
	 *                       this file as local-with-networking or trusted.
	 * @throws SecurityError You are trying to connect to a commonly reserved
	 *                       port. For a complete list of blocked ports, see
	 *                       "Restricting Networking APIs" in the <i>ActionScript
	 *                       3.0 Developer's Guide</i>.
	 * @throws TypeError     The value of the request parameter or the
	 *                       <code>URLRequest.url</code> property of the
	 *                       URLRequest object passed are <code>null</code>.
	 * @event complete           Dispatched after data has loaded successfully.
	 * @event httpResponseStatus Dispatched if a call to the <code>load()</code>
	 *                           method attempts to access data over HTTP and
	 *                           Adobe AIR is able to detect and return the
	 *                           status code for the request.
	 * @event httpStatus         If access is over HTTP, and the current Flash
	 *                           Player environment supports obtaining status
	 *                           codes, you may receive these events in addition
	 *                           to any <code>complete</code> or
	 *                           <code>error</code> event.
	 * @event ioError            The load operation could not be completed.
	 * @event open               Dispatched when a load operation commences.
	 * @event progress           Dispatched when data is received as the download
	 *                           operation progresses.
	 * @event securityError      A load operation attempted to retrieve data from
	 *                           a server outside the caller's security sandbox.
	 *                           This may be worked around using a policy file on
	 *                           the server.
	 * @event securityError      A load operation attempted to load a SWZ file(a
	 *                           Adobe platform component), but the certificate
	 *                           is invalid or the digest does not match the
	 *                           component.
	 */
	public function load (request:URLRequest):Void {
		
		#if (js && html5)
		requestUrl (request.url, request.method, request.data, request.formatRequestHeaders ());
		#else
		if (request.url != null && request.url.indexOf ("http://") == -1 && request.url.indexOf ("https://") == -1) {
			
			var worker = new BackgroundWorker ();
			worker.doWork.add (function (_) {
				
				var path = request.url;
				var index = path.indexOf ("?");
				
				if (index > -1) {
					
					path = path.substring (0, index);
					
				}
				
				var bytes = ByteArray.readFile (path);
				worker.sendComplete (bytes);
				
			});
			worker.onComplete.add (function (bytes) {
				
				switch (dataFormat) {
					
					case BINARY: this.data = bytes;
					default: this.data = bytes.readUTFBytes (bytes.length);
					
				}
				
				var evt = new Event (Event.COMPLETE);
				evt.currentTarget = this;
				dispatchEvent (evt);
				
			});
			worker.run ();
			
		}
		#if lime_curl
		else
		{
			requestUrl (request.url, request.method, request.data, request.formatRequestHeaders ());
		}
		#end
		#end
		
	}
	
	
	#if (js && html5)
	@:noCompletion private function registerEvents (subject:EventTarget):Void {
		
		var self = this;
		if (untyped __js__("typeof XMLHttpRequestProgressEvent") != __js__('"undefined"')) {
			
			subject.addEventListener ("progress", onProgress, false);
			
		}
		
		untyped subject.onreadystatechange = function () {
			
			if (subject.readyState != 4) return;
			
			var s = try subject.status catch (e:Dynamic) null;
			
			if (s == untyped __js__("undefined")) {
				
				s = null;
				
			}
			
			if (s != null) {
				
				self.onStatus (s);
				
			}
			
			//js.Lib.alert (s);
			
			if (s != null && s >= 200 && s < 400) {
				
				self.onData (subject.response);
				
			} else {
				
				if (s == null) {
					
					self.onError ("Failed to connect or resolve host");
					
				} else if (s == 12029) {
					
					self.onError ("Failed to connect to host");
					
				} else if (s == 12007) {
					
					self.onError ("Unknown host");
					
				} else if (s == 0) {
					
					self.onError ("Unable to make request (may be blocked due to cross-domain permissions)");
					self.onSecurityError ("Unable to make request (may be blocked due to cross-domain permissions)");
					
				} else {
					
					self.onError ("Http Error #" + subject.status);
					
				}
				
			}
			
		};
		
	}
	
	
	@:noCompletion private function requestUrl (url:String, method:String, data:Dynamic, requestHeaders:Array<URLRequestHeader>):Void {
		
		var xmlHttpRequest:XMLHttpRequest = untyped __new__("XMLHttpRequest");
		registerEvents (cast xmlHttpRequest);
		var uri:Dynamic = "";
		
		if (Std.is (data, ByteArray)) {
			
			var data:ByteArray = cast data;
			
			switch (dataFormat) {
				
				case BINARY: uri = data.__getBuffer ();
				default: uri = data.readUTFBytes (data.length);
				
			}
			
		} else if (Std.is (data, URLVariables)) {
			
			var data:URLVariables = cast data;
			
			for (p in Reflect.fields (data)) {
				
				if (uri.length != 0) uri += "&";
				uri += StringTools.urlEncode (p) + "=" + StringTools.urlEncode (Reflect.field (data, p));
				
			}
			
		} else {
			
			if (data != null) {
				
				uri = data.toString ();
				
			}
			
		}
		
		try {
			
			if (method == "GET" && uri != null && uri != "") {
				
				var question = url.split ("?").length <= 1;
				xmlHttpRequest.open (method, url + (if (question) "?" else "&") + uri, true);
				uri = "";
				
			} else {
				
				//js.Lib.alert ("open: " + method + ", " + url + ", true");
				xmlHttpRequest.open (method, url, true);
				
			}
			
		} catch (e:Dynamic) {
			
			onError (e.toString ());
			return;
			
		}
		
		//js.Lib.alert ("dataFormat: " + dataFormat);
		
		switch (dataFormat) {
			
			case BINARY: untyped xmlHttpRequest.responseType = 'arraybuffer';
			default:
			
		}
		
		for (header in requestHeaders) {
			
			//js.Lib.alert ("setRequestHeader: " + header.name + ", " + header.value);
			xmlHttpRequest.setRequestHeader (header.name, header.value);
			
		}
		
		//js.Lib.alert ("uri: " + uri);
		
		xmlHttpRequest.send (uri);
		onOpen ();
		
		getData = function () {
			
			if (xmlHttpRequest.response != null) {
				
				return xmlHttpRequest.response;
				
			} else { 
				
				return xmlHttpRequest.responseText;
				
			}
			
		};
		
	}
	
	
	#elseif lime_curl
	
	
	private function prepareData (data:Dynamic):ByteArray {
		
		var uri:ByteArray = new ByteArray ();
		
		if (Std.is (data, ByteArray)) {
			
			var data:ByteArray = cast data;
			uri = data;
			
		} else if (Std.is (data, URLVariables)) {
			
			var data:URLVariables = cast data;
			var tmp:String = "";
			
			for (p in Reflect.fields (data)) {
				
				if (tmp.length != 0) tmp += "&";
				tmp += StringTools.urlEncode (p) + "=" + StringTools.urlEncode (Std.string (Reflect.field (data, p)));
				
			}
			
			uri.writeUTFBytes (tmp);
			
		} else {
			
			if (data != null) {
				
				uri.writeUTFBytes (Std.string (data));
				
			}
			
		}
		
		return uri;
		
	}
	
	
	private function requestUrl (url:String, method:URLRequestMethod, data:Dynamic, requestHeaders:Array<URLRequestHeader>):Void {
		
		var uri = prepareData(data);
		uri.position = 0;
		
		__data = new ByteArray ();
		bytesLoaded = 0;
		bytesTotal = 0;
		
		CURLEasy.reset (__curl);
		CURLEasy.setopt (__curl, URL, url);
		
		switch (method) {
			
			case HEAD:
				
				CURLEasy.setopt(__curl, NOBODY, true);
			
			case GET:
				
				CURLEasy.setopt(__curl, HTTPGET, true);
				
				if (uri.length > 0) {
					
					CURLEasy.setopt (__curl, URL, url + "?" + uri.readUTFBytes (uri.length));
					
				}
			
			case POST:
				
				CURLEasy.setopt(__curl, POST, true);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, POSTFIELDSIZE, uri.length);
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
			case PUT:
				
				CURLEasy.setopt(__curl, UPLOAD, true);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
			case _:
				
				CURLEasy.setopt(__curl, CUSTOMREQUEST, cast method);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
		}
		
		var headers:Array<String> = [];
		headers.push ("Expect: "); // removes the default cURL value
		
		for (requestHeader in requestHeaders) {
			
			headers.push ('${requestHeader.name}: ${requestHeader.value}');
			
		}
		
		CURLEasy.setopt (__curl, HTTPHEADER, headers);
		
		CURLEasy.setopt (__curl, PROGRESSFUNCTION, progressFunction);
		
		CURLEasy.setopt (__curl, WRITEFUNCTION, writeFunction);
		CURLEasy.setopt (__curl, HEADERFUNCTION, headerFunction);
		
		CURLEasy.setopt (__curl, SSL_VERIFYPEER, false);
		CURLEasy.setopt (__curl, SSL_VERIFYHOST, false);
		CURLEasy.setopt (__curl, USERAGENT, "libcurl-agent/1.0");
		CURLEasy.setopt (__curl, CONNECTTIMEOUT, 30);
		CURLEasy.setopt (__curl, TRANSFERTEXT, dataFormat == BINARY ? 0 : 1);
		
		var worker = new BackgroundWorker ();
		worker.doWork.add (function (_) {
			
			var result = CURLEasy.perform (__curl);
			worker.sendComplete (result);
			
		});
		worker.onComplete.add (function (result) {
			
			var responseCode = CURLEasy.getinfo (__curl, RESPONSE_CODE);
			
			if (result == CURLCode.OK) {
				
				switch (dataFormat) {
					
					case BINARY:
						
						this.data = __data;
					
					default:
						
						__data.position = 0;
						this.data = __data.readUTFBytes (__data.length);
					
				}
				
				onStatus (Std.parseInt (responseCode));
				
				var evt = new Event (Event.COMPLETE);
				evt.currentTarget = this;
				dispatchEvent (evt);
				
			} else {
				
				onError ("Problem with curl: " + result);
				
			}
			
		});
		worker.run ();
		
	}
	
	
	private function writeFunction (output:Bytes, size:Int, nmemb:Int):Int {
		
		__data.writeBytes (ByteArray.fromBytes (output));
		return size * nmemb;
		
	}
	
	
	private function headerFunction (output:Bytes, size:Int, nmemb:Int):Int {
		
		// TODO
		return size * nmemb;
		
	}
	
	
	private function progressFunction (dltotal:Float, dlnow:Float, uptotal:Float, upnow:Float):Int {
		
		if (upnow > bytesLoaded || dlnow > bytesLoaded || uptotal > bytesTotal || dltotal > bytesTotal) {
			
			if (upnow > bytesLoaded) bytesLoaded = Std.int (upnow);
			if (dlnow > bytesLoaded) bytesLoaded = Std.int (dlnow);
			if (uptotal > bytesTotal) bytesTotal = Std.int (uptotal);
			if (dltotal > bytesTotal) bytesTotal = Std.int (dltotal);
			
			var evt = new ProgressEvent (ProgressEvent.PROGRESS);
			evt.currentTarget = this;
			evt.bytesLoaded = bytesLoaded;
			evt.bytesTotal = bytesTotal;
			dispatchEvent (evt);
			
		}
		
		return 0;
		
	}

	
	private function readFunction (max:Int, input:ByteArray):Bytes {
		
		
		return input;
		
	}
	
	
	#end
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function onData (_):Void {
		
		#if (js && html5)
		var content:Dynamic = getData ();
		
		switch (dataFormat) {
			
			case BINARY: this.data = ByteArray.__ofBuffer (content);
			default: this.data = Std.string (content);
			
		}
		#end
		
		var evt = new Event (Event.COMPLETE);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	@:noCompletion private function onError (msg:String):Void {
		
		var evt = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		evt.text = msg;
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	@:noCompletion private function onOpen ():Void {
		
		var evt = new Event (Event.OPEN);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	@:noCompletion private function onProgress (event:XMLHttpRequestProgressEvent):Void {
		
		var evt = new ProgressEvent (ProgressEvent.PROGRESS);
		evt.currentTarget = this;
		evt.bytesLoaded = event.loaded;
		evt.bytesTotal = event.total;
		dispatchEvent (evt);
		
	}
	
	
	@:noCompletion private function onSecurityError (msg:String):Void {
		
		var evt = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
		evt.text = msg;
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	@:noCompletion private function onStatus (status:Int):Void {
		
		var evt = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, status);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function set_dataFormat (inputVal:URLLoaderDataFormat):URLLoaderDataFormat {
		
		#if (js && html5)
		// prevent inadvertently using typed arrays when they are unsupported
		// @todo move these sorts of tests somewhere common in the vein of Modernizr
		
		if (inputVal == URLLoaderDataFormat.BINARY && !Reflect.hasField (Browser.window, "ArrayBuffer")) {
			
			dataFormat = URLLoaderDataFormat.TEXT;
			
		} else {
			
			dataFormat = inputVal;
			
		}
		
		return dataFormat;
		#else
		return dataFormat = inputVal;
		#end
		
	}
	
	
}


@:noCompletion @:dox(hide) typedef XMLHttpRequestProgressEvent = Dynamic;


#else
typedef URLLoader = openfl._legacy.net.URLLoader;
#end
#else
typedef URLLoader = flash.net.URLLoader;
#end