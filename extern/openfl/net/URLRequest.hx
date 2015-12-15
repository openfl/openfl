package openfl.net; #if (display || !flash)


/**
 * The URLRequest class captures all of the information in a single HTTP
 * request. URLRequest objects are passed to the <code>load()</code> methods
 * of the Loader, URLStream, and URLLoader classes, and to other loading
 * operations, to initiate URL downloads. They are also passed to the
 * <code>upload()</code> and <code>download()</code> methods of the
 * FileReference class.
 *
 * <p>A SWF file in the local-with-filesystem sandbox may not load data from,
 * or provide data to, a resource that is in the network sandbox. </p>
 *
 * <p>By default, the calling SWF file and the URL you load must be in the
 * same domain. For example, a SWF file at www.adobe.com can load data only
 * from sources that are also at www.adobe.com. To load data from a different
 * domain, place a URL policy file on the server hosting the data.</p>
 *
 * <p> However, in Adobe AIR, content in the application security sandbox
 * (content installed with the AIR application) is not restricted by these
 * security limitations. For content running in Adobe AIR, files in the
 * application security sandbox can access URLs using any of the following URL
 * schemes:</p>
 *
 * <ul>
 *   <li><code>http</code> and <code>https</code> </li>
 *   <li><code>file</code> </li>
 *   <li><code>app-storage</code> </li>
 *   <li><code>app</code> </li>
 * </ul>
 *
 * <p>Content running in Adobe AIR that is not in the application security
 * sandbox observes the same restrictions as content running in the browser
 * (in Flash Player), and loading is governed by the content's domain and any
 * permissions granted in URL policy files.</p>
 *
 * <p>For more information related to security, see the Flash Player Developer
 * Center Topic: <a href="http://www.adobe.com/go/devnet_security_en"
 * scope="external">Security</a>.</p>
 */
@:final extern class URLRequest {
	
	
	/**
	 * The MIME content type of the content in the the <code>data</code>
	 * property.
	 *
	 * <p>The default value is
	 * <code>application/x-www-form-urlencoded</code>.</p>
	 *
	 * <p><b>Note</b>:The <code>FileReference.upload()</code>,
	 * <code>FileReference.download()</code>, and <code>HTMLLoader.load()</code>
	 * methods do not support the <code>URLRequest.contentType</code>
	 * property.</p>
	 *
	 * <p>When sending a POST request, the values of the <code>contentType</code>
	 * and <code>data</code> properties must correspond properly. The value of
	 * the <code>contentType</code> property instructs servers on how to
	 * interpret the value of the <code>data</code> property. </p>
	 *
	 * <ul>
	 *   <li>If the value of the <code>data</code> property is a URLVariables
	 * object, the value of <code>contentType</code> must be
	 * <code>application/x-www-form-urlencoded</code>. </li>
	 *   <li> If the value of the <code>data</code> property is any other type,
	 * the value of <code>contentType</code> should indicate the type of the POST
	 * data that will be sent(which is the binary or string data contained in
	 * the value of the <code>data</code> property). </li>
	 *   <li>For <code>FileReference.upload()</code>, the Content-Type of the
	 * request is set automatically to <code>multipart/form-data</code>, and the
	 * value of the <code>contentType</code> property is ignored.</li>
	 * </ul>
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
	 */
	public var contentType:String;
	
	/**
	 * An object containing data to be transmitted with the URL request.
	 *
	 * <p>This property is used in conjunction with the <code>method</code>
	 * property. When the value of <code>method</code> is <code>GET</code>, the
	 * value of <code>data</code> is appended to the value of
	 * <code>URLRequest.url</code>, using HTTP query-string syntax. When the
	 * <code>method</code> value is <code>POST</code>(or any value other than
	 * <code>GET</code>), the value of <code>data</code> is transmitted in the
	 * body of the HTTP request.</p>
	 *
	 * <p>The URLRequest API offers binary <code>POST</code> support and support
	 * for URL-encoded variables, as well as support for strings. The data object
	 * can be a ByteArray, URLVariables, or String object.</p>
	 *
	 * <p>The way in which the data is used depends on the type of object
	 * used:</p>
	 *
	 * <ul>
	 *   <li>If the object is a ByteArray object, the binary data of the
	 * ByteArray object is used as <code>POST</code> data. For <code>GET</code>,
	 * data of ByteArray type is not supported. Also, data of ByteArray type is
	 * not supported for <code>FileReference.upload()</code> and
	 * <code>FileReference.download()</code>.</li>
	 *   <li>If the object is a URLVariables object and the method is
	 * <code>POST</code>, the variables are encoded using
	 * <i>x-www-form-urlencoded</i> format and the resulting string is used as
	 * <code>POST</code> data. An exception is a call to
	 * <code>FileReference.upload()</code>, in which the variables are sent as
	 * separate fields in a <code>multipart/form-data</code> post.</li>
	 *   <li>If the object is a URLVariables object and the method is
	 * <code>GET</code>, the URLVariables object defines variables to be sent
	 * with the URLRequest object.</li>
	 *   <li>Otherwise, the object is converted to a string, and the string is
	 * used as the <code>POST</code> or <code>GET</code> data.</li>
	 * </ul>
	 *
	 * <p>This data is not sent until a method, such as
	 * <code>navigateToURL()</code> or <code>FileReference.upload()</code>, uses
	 * the URLRequest object.</p>
	 *
	 * <p><b>Note</b>: The value of <code>contentType</code> must correspond to
	 * the type of data in the <code>data</code> property. See the note in the
	 * description of the <code>contentType</code> property.</p>
	 */
	public var data:Dynamic;
	
	#if flash
	@:noCompletion @:dox(hide) public var digest:String;
	#end
	
	/**
	 * Controls the HTTP form submission method.
	 *
	 * <p>For SWF content running in Flash Player(in the browser), this property
	 * is limited to GET or POST operations, and valid values are
	 * <code>URLRequestMethod.GET</code> or
	 * <code>URLRequestMethod.POST</code>.</p>
	 *
	 * <p>For content running in Adobe AIR, you can use any string value if the
	 * content is in the application security sandbox. Otherwise, as with content
	 * running in Flash Player, you are restricted to using GET or POST
	 * operations.</p>
	 *
	 * <p>For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 *
	 * <p><b>Note:</b> If running in Flash Player and the referenced form has no
	 * body, Flash Player automatically uses a GET operation, even if the method
	 * is set to <code>URLRequestMethod.POST</code>. For this reason, it is
	 * recommended to always include a "dummy" body to ensure that the correct
	 * method is used.</p>
	 * 
	 * @default URLRequestMethod.GET
	 * @throws ArgumentError If the <code>value</code> parameter is not
	 *                       <code>URLRequestMethod.GET</code> or
	 *                       <code>URLRequestMethod.POST</code>.
	 */
	public var method:String;
	
	/**
	 * The array of HTTP request headers to be appended to the HTTP request. The
	 * array is composed of URLRequestHeader objects. Each object in the array
	 * must be a URLRequestHeader object that contains a name string and a value
	 * string, as follows:
	 *
	 * <p>Flash Player and the AIR runtime impose certain restrictions on request
	 * headers; for more information, see the URLRequestHeader class
	 * description.</p>
	 *
	 * <p>Not all methods that accept URLRequest parameters support the
	 * <code>requestHeaders</code> property, consult the documentation for the
	 * method you are calling. For example, the
	 * <code>FileReference.upload()</code> and
	 * <code>FileReference.download()</code> methods do not support the
	 * <code>URLRequest.requestHeaders</code> property.</p>
	 *
	 * <p>Due to browser limitations, custom HTTP request headers are only
	 * supported for <code>POST</code> requests, not for <code>GET</code>
	 * requests.</p>
	 */
	public var requestHeaders:Array<URLRequestHeader>;
	
	/**
	 * The URL to be requested.
	 *
	 * <p>Be sure to encode any characters that are either described as unsafe in
	 * the Uniform Resource Locator specification(see
	 * http://www.faqs.org/rfcs/rfc1738.html) or that are reserved in the URL
	 * scheme of the URLRequest object(when not used for their reserved
	 * purpose). For example, use <code>"%25"</code> for the percent(%) symbol
	 * and <code>"%23"</code> for the number sign(#), as in
	 * <code>"http://www.example.com/orderForm.cfm?item=%23B-3&discount=50%25"</code>.</p>
	 *
	 * <p>By default, the URL must be in the same domain as the calling file,
	 * unless the content is running in the Adobe AIR application security
	 * sandbox. If you need to load data from a different domain, put a URL
	 * policy file on the server that is hosting the data. For more information,
	 * see the description of the URLRequest class.</p>
	 *
	 * <p>For content running in Adobe AIR, files in the application security
	 * sandobx  -  files installed with the AIR application  -  can access URLs
	 * using any of the following URL schemes:</p>
	 *
	 * <ul>
	 *   <li><code>http</code> and <code>https</code> </li>
	 *   <li><code>file</code> </li>
	 *   <li><code>app-storage</code> </li>
	 *   <li><code>app</code> </li>
	 * </ul>
	 *
	 * <p><b>Note:</b> IPv6(Internet Protocol version 6) is supported in AIR and
	 * in Flash Player 9.0.115.0 and later. IPv6 is a version of Internet
	 * Protocol that supports 128-bit addresses(an improvement on the earlier
	 * IPv4 protocol that supports 32-bit addresses). You might need to activate
	 * IPv6 on your networking interfaces. For more information, see the Help for
	 * the operating system hosting the data. If IPv6 is supported on the hosting
	 * system, you can specify numeric IPv6 literal addresses in URLs enclosed in
	 * brackets([]), as in the following. </p>
	 * <pre xml:space="preserve">
	 * rtmp://[2001:db8:ccc3:ffff:0:444d:555e:666f]:1935/test </pre>
	 */
	public var url:String;
	
	//public var userAgent:String;
	
	
	/**
	 * Creates a URLRequest object. If <code>System.useCodePage</code> is
	 * <code>true</code>, the request is encoded using the system code page,
	 * rather than Unicode. If <code>System.useCodePage</code> is
	 * <code>false</code>, the request is encoded using Unicode, rather than the
	 * system code page.
	 * 
	 * @param url The URL to be requested. You can set the URL later by using the
	 *            <code>url</code> property.
	 */
	public function new (url:String = null);
	
	
	#if flash
	@:noCompletion @:dox(hide) public function useRedirectedURL (sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;
	#end
	
	
}


#else
typedef URLRequest = flash.net.URLRequest;
#end