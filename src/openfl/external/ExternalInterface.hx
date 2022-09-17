package openfl.external;

#if !flash
import openfl.utils._internal.Lib;

/**
	The ExternalInterface class is an application programming interface that
	enables straightforward communication between ActionScript and the SWF
	container� for example, an HTML page with JavaScript or a desktop
	application that uses Flash Player to display a SWF file.

	Using the ExternalInterface class, you can call an ActionScript function
	in the Flash runtime, using JavaScript in the HTML page. The ActionScript
	function can return a value, and JavaScript receives it immediately as the
	return value of the call.

	This functionality replaces the `fscommand()` method.

	Use the ExternalInterface class in the following combinations of browser
	and operating system:

	The ExternalInterface class requires the user's web browser to support
	either ActiveX<sup>®</sup> or the NPRuntime API that is exposed by some
	browsers for plug-in scripting. Even if a browser and operating system
	combination are not listed above, they should support the ExternalInterface
	class if they support the NPRuntime API. See
	[http://www.mozilla.org/projects/plugins/npruntime.html](http://www.mozilla.org/projects/plugins/npruntime.html)..

	**Note:** When embedding SWF files within an HTML page, make sure
	that the `id` attribute is set and the `id` and
	`name` attributes of the `object` and
	`embed` tags do not include the following characters:
	`. - + * / \`

	**Note for Flash Player applications:** Flash Player version
	9.0.115.0 and later allows the `.`(period) character within the
	`id` and `name` attributes.

	**Note for Flash Player applications:** In Flash Player 10 and later
	running in a browser, using this class programmatically to open a pop-up
	window may not be successful. Various browsers(and browser configurations)
	may block pop-up windows at any time; it is not possible to guarantee any
	pop-up window will appear. However, for the best chance of success, use
	this class to open a pop-up window only in code that executes as a direct
	result of a user action(for example, in an event handler for a mouse click
	or key-press event.)

	From ActionScript, you can do the following on the HTML page:

	* Call any JavaScript function.
	* Pass any number of arguments, with any names.
	* Pass various data types(Boolean, Number, String, and so on).
	* Receive a return value from the JavaScript function.



	From JavaScript on the HTML page, you can:

	* Call an ActionScript function.
	* Pass arguments using standard function call notation.
	* Return a value to the JavaScript function.



	**Note for Flash Player applications:** Flash Player does not
	currently support SWF files embedded within HTML forms.

	**Note for AIR applications:** In Adobe AIR, the ExternalInterface
	class can be used to communicate between JavaScript in an HTML page loaded
	in the HTMLLoader control and ActionScript in SWF content embedded in that
	HTML page.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage)
@:access(lime.ui.Window)
@:final class ExternalInterface
{
	/**
		Indicates whether this player is in a container that offers an external
		interface. If the external interface is available, this property is
		`true`; otherwise, it is `false`.

		**Note:** When using the External API with HTML, always check that
		the HTML has finished loading before you attempt to call any JavaScript
		methods.
	**/
	public static var available(default, null) = #if (js && html5) true #else false #end;

	/**
		Indicates whether the external interface should attempt to pass
		ActionScript exceptions to the current browser and JavaScript exceptions
		to the player. You must explicitly set this property to `true`
		to catch JavaScript exceptions in ActionScript and to catch ActionScript
		exceptions in JavaScript.
	**/
	public static var marshallExceptions:Bool = false;

	/**
		Returns the `id` attribute of the `object` tag in
		Internet Explorer, or the `name` attribute of the
		`embed` tag in Netscape.
	**/
	public static var objectID(get, null):String;

	/**
		Registers an ActionScript method as callable from the container. After a
		successful invocation of `addCallBack()`, the registered
		function in the player can be called by JavaScript or ActiveX code in the
		container.

		**Note:** For _local_ content running in a browser, calls to
		the `ExternalInterface.addCallback()` method work only if the
		SWF file and the containing web page are in the local-trusted security
		sandbox. For more information, see the Flash Player Developer Center
		Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		@param functionName The name by which the container can invoke the
							function.
		@param closure      The function closure to invoke. This could be a
							free-standing function, or it could be a method
							closure referencing a method of an object instance. By
							passing a method closure, you can direct the callback
							at a method of a particular object instance.

							**Note:** Repeating `addCallback()`
							on an existing callback function with a
							`null` closure value removes the
							callback.
		@throws Error         The container does not support incoming calls.
							  Incoming calls are supported only in Internet
							  Explorer for Windows and browsers that use the
							  NPRuntime API such as Mozilla 1.7.5 and later or
							  Firefox 1.0 and later.
		@throws SecurityError A callback with the specified name has already been
							  added by ActionScript in a sandbox to which you do
							  not have access; you cannot overwrite that callback.
							  To work around this problem, rewrite the
							  ActionScript that originally called the
							  `addCallback()` method so that it also
							  calls the `Security.allowDomain()`
							  method.
		@throws SecurityError The containing environment belongs to a security
							  sandbox to which the calling code does not have
							  access. To fix this problem, follow these steps:

							   1. In the `object` tag for the SWF
							  file in the containing HTML page, set the following
							  parameter:

							  `<param name="allowScriptAccess"
							  value="always" />`

							   2. In the SWF file, add the following
							  ActionScript:


							  `openfl.system.Security.allowDomain(_sourceDomain_)`
	**/
	public static function addCallback(functionName:String, closure:Dynamic):Void
	{
		#if (js && html5)
		if (Lib.application.window.element != null)
		{
			untyped Lib.application.window.element[functionName] = closure;
		}
		#end
	}

	/**
		Calls a function exposed by the SWF container, passing zero or more
		arguments. If the function is not available, the call returns
		`null`; otherwise it returns the value provided by the
		function. Recursion is _not_ permitted on Opera or Netscape browsers;
		on these browsers a recursive call produces a `null` response.
		(Recursion is supported on Internet Explorer and Firefox browsers.)

		If the container is an HTML page, this method invokes a JavaScript
		function in a `script` element.

		If the container is another ActiveX container, this method dispatches
		the FlashCall ActiveX event with the specified name, and the container
		processes the event.

		If the container is hosting the Netscape plug-in, you can either write
		custom support for the new NPRuntime interface or embed an HTML control
		and embed the player within the HTML control. If you embed an HTML
		control, you can communicate with the player through a JavaScript
		interface to the native container application.

		**Note:** For _local_ content running in a browser, calls to
		the `ExternalInterface.call()` method are permitted only if the
		SWF file and the containing web page(if there is one) are in the
		local-trusted security sandbox. Also, you can prevent a SWF file from
		using this method by setting the `allowNetworking` parameter of
		the `object` and `embed` tags in the HTML page that
		contains the SWF content. For more information, see the Flash Player
		Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		**Note for Flash Player applications:** In Flash Player 10 and Flash
		Player 9 Update 5, some web browsers restrict this method if a pop-up
		blocker is enabled. In this scenario, you can only call this method
		successfully in response to a user event(for example, in an event handler
		for a mouse click or keypress event).

		@param functionName The alphanumeric name of the function to call in the
							container. Using a non-alphanumeric function name
							causes a runtime error(error 2155). You can use a
							`try..catch` block to handle the error.
		@return The response received from the container. If the call failed�
				for example, if there is no such function in the container, the
				interface is not available, a recursion occurred(with a Netscape
				or Opera browser), or there is a security issue�
				`null` is returned and an error is thrown.
		@throws Error         The container does not support outgoing calls.
							  Outgoing calls are supported only in Internet
							  Explorer for Windows and browsers that use the
							  NPRuntime API such as Mozilla 1.7.5 and later or
							  Firefox 1.0 and later.
		@throws SecurityError The containing environment belongs to a security
							  sandbox to which the calling code does not have
							  access. To fix this problem, follow these steps:

							   1. In the `object` tag for the SWF
							  file in the containing HTML page, set the following
							  parameter:

							  `<param name="allowScriptAccess"
							  value="always" />`

							   2. In the SWF file, add the following
							  ActionScript:


							  `openfl.system.Security.allowDomain(_sourceDomain_)`
	**/
	public static function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		#if (js && html5)
		var callResponse:Dynamic = null;

		if (!~/^\(.+\)$/.match(functionName))
		{
			var thisArg = functionName.split(".").slice(0, -1).join(".");
			if (thisArg.length > 0)
			{
				functionName += '.bind(${thisArg})';
			}
		}

		// Flash does not throw an error or attempt to execute
		// if the function does not exist.
		var fn:Dynamic;
		try
		{
			fn = js.Lib.eval(functionName);
		}
		catch (e:Dynamic)
		{
			return null;
		}

		if (Type.typeof(fn) != Type.ValueType.TFunction)
		{
			return null;
		}

		if (p1 == null)
		{
			callResponse = fn();
		}
		else if (p2 == null)
		{
			callResponse = fn(p1);
		}
		else if (p3 == null)
		{
			callResponse = fn(p1, p2);
		}
		else if (p4 == null)
		{
			callResponse = fn(p1, p2, p3);
		}
		else if (p5 == null)
		{
			callResponse = fn(p1, p2, p3, p4);
		}
		else
		{
			callResponse = fn(p1, p2, p3, p4, p5);
		}

		return callResponse;
		#else
		return null;
		#end
	}

	private static function get_objectID():String
	{
		#if (js && html5)
		if (Lib.application != null && Lib.application.window != null && Lib.application.window.element != null)
		{
			return Lib.application.window.element.id;
		}
		#end

		return null;
	}
}
#else
typedef ExternalInterface = flash.external.ExternalInterface;
#end
