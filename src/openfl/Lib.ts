import InternalLib from "./_internal/Lib";
import MovieClip from "./display/MovieClip";
import URLLoader from "./net/URLLoader";
import URLRequest from "./net/URLRequest";

export default class Lib
{
	public static as<T>(v: any, c: T): null | T
	{
		return v as T;
	}

	public static attach(name: string): MovieClip
	{
		return new MovieClip();
	}

	/**
		Cancels a specified `setInterval()` call.

		@param	id	The ID of the `setInterval()` call, which you set to a variable, as
		in the following:
	**/
	public static clearInterval(id: number): void
	{
		window.clearInterval(id);
	}

	/**
		Cancels a specified `setTimeout()` call.

		@param	id	The ID of the `setTimeout()` call, which you set to a variable, as in
		the following
	**/
	public static clearTimeout(id: number): void
	{
		window.clearTimeout(id);
	}

	/**
		Returns a reference to the class object of the class specified by the `name`
		parameter.

		@param	name	The name of a class.
		@returns	Returns a reference to the class object of the class specified by the
		`name` parameter.
		@throws	ReferenceError	No public definition exists with the specified name.
	**/
	public static getDefinitionByName(name: string): any
	{
		return null;
	}

	/**
		Returns the fully qualified class name of an object.

		@param	value	The object for which a fully qualified class name is desired. Any
		ActionScript value may be passed to this method including all available
		ActionScript types, object instances, primitive types such as uint, and class
		objects.
		@returns	String	A string containing the fully qualified class name.
	**/
	public static getQualifiedClassName(value: any): string
	{
		return value?.constructor?.name;
	}

	/**
		Returns the fully qualified class name of the base class of the object specified
		by the value parameter. This provides a quicker way of retrieving the
		base class name than `describeType()`, but also doesn't provide all the
		information `describeType()` does.

		After you retrieve the name of a class with this function, you can convert the
		class name to a class reference with the `getDefinitionByName()` function.

		**Note:** This restricts itself to instance hierarchies, whereas the
		`describeType()` uses class object hierarchies if the value parameter is
		a data type. Calling `describeType()` on a data type returns the superclass based
		on the class object hierarchy, in which all class objects inherit from Class. The
		`getQualifiedSuperclassName()` function, however, ignores the class object
		hierarchy and returns the superclass based on the more familiar instance
		hierarchy. For example, calling `getQualifiedSuperclassName(String)` returns
		Object although technically the String class object inherits from Class. In other
		words, the results are the same whether you use an instance of a type or the type
		itself.

		@param	value	Any value.
		@returns	A fully qualified base class name, or null if none exists.

	**/
	public static getQualifiedSuperclassName(value: any): string
	{
		return null;
	}

	/**
		Used to compute relative time. For a Flash runtime processing ActionScript 3.0,
		this method returns the number of milliseconds that have elapsed since the Flash
		runtime virtual machine for ActionScript 3.0 (AVM2) started. For a Flash runtime
		processing ActionScript 2.0, this method returns the number of milliseconds since
		the Flash runtime began initialization. Flash runtimes use two virtual machines to
		process ActionScript. AVM1 is the ActionScript virtual machine used to run
		ActionScript 1.0 and 2.0. AVM2 is the ActionScript virtual machine used to run
		ActionScript 3.0. The getTimer() method behavior for AVM1 is different than the
		behavior for AVM2.

		For a calendar date (timestamp), see the Date object.

		@returns	The number of milliseconds since the runtime was initialized (while
		processing ActionScript 2.0), or since the virtual machine started (while
		processing ActionScript 3.0). If the runtime starts playing one SWF file, and
		another SWF file is loaded later, the return value is relative to when the first
		SWF file was loaded.
	**/
	public static getTimer(): number
	{
		return window.performance.now();
	}

	public static getURL(request: URLRequest, target: string = null): void
	{
		Lib.navigateToURL(request, target);
	}

	/**
		Opens or replaces a window in the application that contains the Flash Player
		container (usually a browser). In Adobe AIR, the opens a URL in the
		default system web browser

		**Important Security Note**

		Developers often pass URL values to the `navigateToURL()` that were
		obtained from external sources such as FlashVars. Attackers may try to manipulate
		these external sources to perform attacks such as cross-site scripting. Therefore,
		developers should validate all URLs before passing them to this function.

		Good data validation for URLs can mean different things depending on the usage of
		the URL within the overall application. The most common data validation techniques
		include validating that the URL is of the appropriate scheme. For instance,
		unintentionally allowing javascript: URLs may result in cross-site scripting.
		Validating that the URL is a within your domain can ensure that the SWF file can't
		be used as an open-redirector by people who conduct phishing attacks. For additional
		security, you may also choose to validate the path of the URL and to validate that
		the URL conforms to the RFC guidelines

		For example, the following code shows a simple example of performing data validation
		by denying any URL that does not begin with http:// or https:// and validating that
		the URL is within your domain name. This example may not be appropriate for all
		web applications and you should consider whether additional checks against the URL
		are necessary.

		```as3
		// AS3 Regular expression pattern match for URLs that start with http:// and https:// plus your domain name.
		function checkProtocol (flashVarURL:String):Boolean {
			// Get the domain name for the SWF if it is not known at compile time.
			// If the domain is known at compile time, then the following two lines can be replaced with a hard coded string.
			var my_lc:LocalConnection = new LocalConnection();
			var domainName:String = my_lc.domain;
			// Build the RegEx to test the URL.
			// This RegEx assumes that there is at least one "/" after the
			// domain. http://www.mysite.com will not match.
			var pattern:RegExp = new RegExp("^http[s]?\:\\/\\/([^\\/]+)\\/");
			var result:Object = pattern.exec(flashVarURL);
			if (result == null || result[1] != domainName || flashVarURL.length >= 4096) {
			return (false);
			}
			return (true);
		}
		```

		For local content running in a browser, calls to the `navigateToURL()` method that
		specify a "javascript:" pseudo-protocol (via a URLRequest object passed as the first
		parameter) are only permitted if the SWF file and the containing web page (if there
		is one) are in the local-trusted security sandbox. Some browsers do not support using
		the javascript protocol with the `navigateToURL()` method. Instead, consider using the
		`call()` method of the ExternalInterface API to invoke JavaScript methods within the
		enclosing HTML page.

		In Flash Player, and in non-application sandboxes in Adobe AIR, you cannot connect to
		commonly reserved ports. For a complete list of blocked ports, see "Restricting
		Networking APIs" in the ActionScript 3.0 Developer's Guide.

		In Flash Player 10 and later running in a browser, using this method programmatically
		to open a pop-up window may not be successful. Various browsers (and browser
		configurations) may block pop-up windows at any time; it is not possible to guarantee
		any pop-up window will appear. However, for the best chance of success, use this
		method to open a pop-up window only in code that executes as a direct result of a
		user action (for example, in an event handler for a mouse click or key-press event.)

		In Flash Player 10 and later, if you use a multipart Content-Type (for example
		"multipart/form-data") that contains an upload (indicated by a "filename" parameter
		in a "content-disposition" header within the POST body), the POST operation is subject
		to the security rules applied to uploads:

		* The POST operation must be performed in response to a user-initiated action, such
		as a mouse click or key press.
		* If the POST operation is cross-domain (the POST target is not on the same server
		as the SWF file that is sending the POST request), the target server must provide
		a URL policy file that permits cross-domain access.

		Also, for any multipart Content-Type, the syntax must be valid (according to the
		RFC2046 standards). If the syntax appears to be invalid, the POST operation is
		subject to the security rules applied to uploads.

		In AIR, on mobile platforms, the sms: and tel: URI schemes are supported. On
		Android, vipaccess:, connectpro:, and market: URI schemes are supported. The URL
		syntax is subject to the platform conventions. For example, on Android, the URI
		scheme must be lower case. When you navigate to a URL using one of these schemes,
		the runtime opens the URL in the default application for handling the scheme. Thus,
		navigating to tel:+5555555555 opens the phone dialer with the specified number
		already entered. A separate application or utility, such as a phone dialer must be
		available to process the URL.

		The following code shows how you can invoke the VIP Access and Connect Pro
		applications on Android:

		```as3
		//Invoke the VIP Access Application.
		navigateToURL(new URLRequest("vipaccess://com.verisign.mvip.main?action=securitycode"));

		//Invoke the Connect Pro Application.
		navigateToURL(new URLRequest("connectpro://"));
		```

		@param	request	A URLRequest object that specifies the URL to navigate to.
		For content running in Adobe AIR, when using the `navigateToURL()` function, the
		runtime treats a URLRequest that uses the POST method (one that has its method
		property set to `URLRequestMethod.POST`) as using the GET method.

		@param	window	The browser window or HTML frame in which to display the document
		indicated by the request parameter. You can enter the name of a specific window or
		use one of the following values:

		* `"_self"` specifies the current frame in the current window.
		* `"_blank"` specifies a new window.
		* `"_parent"` specifies the parent of the current frame.
		* `"_top"` specifies the top-level frame in the current window.

		If you do not specify a value for this parameter, a new empty window is created.
		In the stand-alone player, you can either specify a new ("_blank") window or a
		named window. The other values don't apply.

		**Note:** When code in a SWF file that is running in the local-with-filesystem
		sandbox calls the `navigateToURL()` and specifies a custom window name
		for the window parameter, the window name is transfered into a random name. The
		name is in the form "_flashXXXXXXXX", where each X represents a random hexadecimal
		digit. Within the same session (until you close the containing browser window),
		if you call the again and specify the same name for the window parameter,
		the same random string is used.

		@throws	IOError	The digest property of the request object is not null. You should
		only set the digest property of a URLRequest object for use calling the
		`URLLoader.load()` method when loading a SWZ file (an Adobe platform component).
		@throws	SecurityError	In Flash Player (and in non-application sandbox content in
		Adobe AIR), this error is thrown in the following situations:
		* Local untrusted SWF files may not communicate with the Internet. You can avoid
		this situation by reclassifying this SWF file as local-with-networking or trusted.
		* A navigate operation attempted to evaluate a scripting pseudo-URL, but the
		containing document (usually an HTML document in a browser) is from a sandbox to
		which you do not have access. You can avoid this situation by specifying
		`allowScriptAccess="always"` in the containing document.
		* You cannot navigate the special windows "_self", "_top", or "_parent" if your
		SWF file is contained by an HTML page that has set the allowScriptAccess to
		"none", or to "sameDomain" when the domains of the HTML file and the SWF file do
		not match.
		* You cannot navigate a window with a nondefault name from within a SWF file that
		is in the local-with-filesystem sandbox.
		* You cannot connect to commonly reserved ports. For a complete list of blocked
		ports, see "Restricting Networking APIs" in the ActionScript 3.0 Developer's Guide.
		@throws	Error	If the method is not called in response to a user action, such as a
		 mouse event or keypress event. This requirement only applies to content in Flash
		 Player and to non-application sandbox content in Adobe AIR.
	**/
	public static navigateToURL(request: URLRequest, target: string = null): void
	{
		if (target == null)
		{
			target = "_blank";
		}

		var uri = request.url ?? "";

		if (typeof request.data === "object")
		{
			var query = "";

			for (let field in request.data)
			{
				if (query.length > 0) query += "&";
				query += encodeURIComponent(field) + "=" + encodeURIComponent(request.data[field]);
			}

			if (uri.indexOf("?") > -1)
			{
				uri += "&" + query;
			}
			else
			{
				uri += "?" + query;
			}
		}

		window.open(uri, target);
	}

	public static notImplemented(): void
	{

	}

	public static preventDefaultTouchMove(): void
	{
		document.addEventListener("touchmove", (event: Event): void =>
		{
			event.preventDefault();
		}, false);
	}

	/**
		Sends a URL request to a server, but ignores any response.

		To examine the server response, use the `URLLoader.load()` method instead.

		You cannot connect to commonly reserved ports. For a complete list of blocked
		ports, see "Restricting Networking APIs" in the ActionScript 3.0 Developer's Guide.

		You can prevent a SWF file from using this method by setting the `allowNetworking`
		parameter of the the object and embed tags in the HTML page that contains the SWF
		content.

		In Flash Player 10 and later, if you use a multipart Content-Type (for example
		"multipart/form-data") that contains an upload (indicated by a "filename" parameter
		in a "content-disposition" header within the POST body), the POST operation is
		subject to the security rules applied to uploads:

		* The POST operation must be performed in response to a user-initiated action,
		such as a mouse click or key press.
		* If the POST operation is cross-domain (the POST target is not on the same server
		as the SWF file that is sending the POST request), the target server must provide
		a URL policy file that permits cross-domain access.

		Also, for any multipart Content-Type, the syntax must be valid (according to the
		RFC2046 standards). If the syntax appears to be invalid, the POST operation is
		subject to the security rules applied to uploads.

		For more information related to security, see the Flash Player Developer Center
		Topic: Security.

		@param	request	A URLRequest object specifying the URL to send data to.
		@throws	SecurityError	Local untrusted SWF files cannot communicate with the
		Internet. You can avoid this situation by reclassifying this SWF file as
		local-with-networking or trusted.
		@throws	SecurityError	You cannot connect to commonly reserved ports. For a
		complete list of blocked ports, see "Restricting Networking APIs" in the
		ActionScript 3.0 Developer's Guide.
	**/
	public static sendToURL(request: URLRequest): void
	{
		var urlLoader = new URLLoader();
		urlLoader.load(request);
	}

	/**
		Runs a at a specified interval (in milliseconds).

		Instead of using the `setInterval()` method, consider creating a Timer object, with
		the specified interval, using 0 as the `repeatCount` parameter (which sets the timer
		to repeat indefinitely).

		If you intend to use the `clearInterval()` method to cancel the `setInterval()`
		call, be sure to assign the `setInterval()` call to a variable (which the
		`clearInterval()` will later reference). If you do not call the
		`clearInterval()` to cancel the `setInterval()` call, the object
		containing the set timeout closure will not be garbage collected.

		@param	closure	The name of the to execute. Do not include quotation
		marks or parentheses, and do not specify parameters of the to call. For
		example, use `functionName`, not `functionName()` or `functionName(param)`.
		@param	delay	The interval, in milliseconds.
		@param	args	An optional list of arguments that are passed to the closure
		function.
		@returns	Unique numeric identifier for the timed process. Use this identifier
		to cancel the process, by calling the `clearInterval()` method.

	**/
	public static setInterval(closure: Function, delay: number, ...args: any[]): number
	{
		return window.setInterval.apply(this, arguments);
	}

	/**
		Runs a specified after a specified delay (in milliseconds).

		Instead of using this method, consider creating a Timer object, with the specified
		interval, using 1 as the `repeatCount` parameter (which sets the timer to run only
		once).

		If you intend to use the `clearTimeout()` method to cancel the `setTimeout()` call,
		be sure to assign the `setTimeout()` call to a variable (which the
		`clearTimeout()` will later reference). If you do not call the
		`clearTimeout()` to cancel the `setTimeout()` call, the object containing
		the set timeout closure will not be garbage collected.

		@param	closure	The name of the to execute. Do not include quotation marks
		or parentheses, and do not specify parameters of the to call. For
		example, use `functionName`, not `functionName()` or `functionName(param)`.
		@param	delay	The delay, in milliseconds, until the is executed.
		@param	args	An optional list of arguments that are passed to the closure
		function.
		@returns	Unique numeric identifier for the timed process. Use this identifier to
		cancel the process, by calling the `clearTimeout()` method.
	**/
	public static setTimeout(closure: Function, delay: number, ...args: any[]): number
	{
		return window.setTimeout.apply(this, arguments);
	}

	public static trace(arg: any): void
	{
		console.log(arg);
	}

	// Get & Set Methods

	public static get current(): MovieClip
	{
		if (InternalLib.current == null) InternalLib.current = new MovieClip();
		return InternalLib.current;
	}
}
