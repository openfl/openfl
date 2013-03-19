package flash.external;
#if (flash || display)


/**
 * The ExternalInterface class is an application programming interface that
 * enables straightforward communication between ActionScript and the SWF
 * container– for example, an HTML page with JavaScript or a desktop
 * application that uses Flash Player to display a SWF file.
 *
 * <p>Using the ExternalInterface class, you can call an ActionScript function
 * in the Flash runtime, using JavaScript in the HTML page. The ActionScript
 * function can return a value, and JavaScript receives it immediately as the
 * return value of the call.</p>
 *
 * <p>This functionality replaces the <code>fscommand()</code> method.</p>
 *
 * <p>Use the ExternalInterface class in the following combinations of browser
 * and operating system:</p>
 *
 * <p>The ExternalInterface class requires the user's web browser to support
 * either ActiveX<sup>®</sup> or the NPRuntime API that is exposed by some
 * browsers for plug-in scripting. Even if a browser and operating system
 * combination are not listed above, they should support the ExternalInterface
 * class if they support the NPRuntime API. See <a
 * href="http://www.mozilla.org/projects/plugins/npruntime.html"
 * scope="external">http://www.mozilla.org/projects/plugins/npruntime.html</a>.</p>
 *
 * <p><b>Note:</b> When embedding SWF files within an HTML page, make sure
 * that the <code>id</code> attribute is set and the <code>id</code> and
 * <code>name</code> attributes of the <code>object</code> and
 * <code>embed</code> tags do not include the following characters:</p>
 * <pre xml:space="preserve"> . - + ~~ / \ </pre>
 *
 * <p><b>Note for Flash Player applications:</b> Flash Player version
 * 9.0.115.0 and later allows the <code>.</code>(period) character within the
 * <code>id</code> and <code>name</code> attributes.</p>
 *
 * <p><b>Note for Flash Player applications:</b> In Flash Player 10 and later
 * running in a browser, using this class programmatically to open a pop-up
 * window may not be successful. Various browsers(and browser configurations)
 * may block pop-up windows at any time; it is not possible to guarantee any
 * pop-up window will appear. However, for the best chance of success, use
 * this class to open a pop-up window only in code that executes as a direct
 * result of a user action(for example, in an event handler for a mouse click
 * or key-press event.)</p>
 *
 * <p>From ActionScript, you can do the following on the HTML page:
 * <ul>
 *   <li>Call any JavaScript function.</li>
 *   <li>Pass any number of arguments, with any names.</li>
 *   <li>Pass various data types(Boolean, Number, String, and so on).</li>
 *   <li>Receive a return value from the JavaScript function.</li>
 * </ul>
 * </p>
 *
 * <p>From JavaScript on the HTML page, you can:
 * <ul>
 *   <li>Call an ActionScript function.</li>
 *   <li>Pass arguments using standard function call notation.</li>
 *   <li>Return a value to the JavaScript function.</li>
 * </ul>
 * </p>
 *
 * <p><b>Note for Flash Player applications:</b> Flash Player does not
 * currently support SWF files embedded within HTML forms.</p>
 *
 * <p><b>Note for AIR applications:</b> In Adobe AIR, the ExternalInterface
 * class can be used to communicate between JavaScript in an HTML page loaded
 * in the HTMLLoader control and ActionScript in SWF content embedded in that
 * HTML page.</p>
 */
extern class ExternalInterface {

	/**
	 * Indicates whether this player is in a container that offers an external
	 * interface. If the external interface is available, this property is
	 * <code>true</code>; otherwise, it is <code>false</code>.
	 *
	 * <p><b>Note:</b> When using the External API with HTML, always check that
	 * the HTML has finished loading before you attempt to call any JavaScript
	 * methods.</p>
	 */
	static var available(default,null) : Bool;

	/**
	 * Indicates whether the external interface should attempt to pass
	 * ActionScript exceptions to the current browser and JavaScript exceptions
	 * to the player. You must explicitly set this property to <code>true</code>
	 * to catch JavaScript exceptions in ActionScript and to catch ActionScript
	 * exceptions in JavaScript.
	 */
	static var marshallExceptions : Bool;

	/**
	 * Returns the <code>id</code> attribute of the <code>object</code> tag in
	 * Internet Explorer, or the <code>name</code> attribute of the
	 * <code>embed</code> tag in Netscape.
	 */
	static var objectID(default,null) : String;

	/**
	 * Registers an ActionScript method as callable from the container. After a
	 * successful invocation of <code>addCallBack()</code>, the registered
	 * function in the player can be called by JavaScript or ActiveX code in the
	 * container.
	 *
	 * <p><b>Note:</b> For <i>local</i> content running in a browser, calls to
	 * the <code>ExternalInterface.addCallback()</code> method work only if the
	 * SWF file and the containing web page are in the local-trusted security
	 * sandbox. For more information, see the Flash Player Developer Center
	 * Topic: <a href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @param functionName The name by which the container can invoke the
	 *                     function.
	 * @param closure      The function closure to invoke. This could be a
	 *                     free-standing function, or it could be a method
	 *                     closure referencing a method of an object instance. By
	 *                     passing a method closure, you can direct the callback
	 *                     at a method of a particular object instance.
	 *
	 *                     <p><b>Note:</b> Repeating <code>addCallback()</code>
	 *                     on an existing callback function with a
	 *                     <code>null</code> closure value removes the
	 *                     callback.</p>
	 * @throws Error         The container does not support incoming calls.
	 *                       Incoming calls are supported only in Internet
	 *                       Explorer for Windows and browsers that use the
	 *                       NPRuntime API such as Mozilla 1.7.5 and later or
	 *                       Firefox 1.0 and later.
	 * @throws SecurityError A callback with the specified name has already been
	 *                       added by ActionScript in a sandbox to which you do
	 *                       not have access; you cannot overwrite that callback.
	 *                       To work around this problem, rewrite the
	 *                       ActionScript that originally called the
	 *                       <code>addCallback()</code> method so that it also
	 *                       calls the <code>Security.allowDomain()</code>
	 *                       method.
	 * @throws SecurityError The containing environment belongs to a security
	 *                       sandbox to which the calling code does not have
	 *                       access. To fix this problem, follow these steps:
	 *                       <ol>
	 *                         <li>In the <code>object</code> tag for the SWF
	 *                       file in the containing HTML page, set the following
	 *                       parameter:
	 *
	 *                       <p><code><param name="allowScriptAccess"
	 *                       value="always" /></code></p>
	 *                       </li>
	 *                         <li>In the SWF file, add the following
	 *                       ActionScript:
	 *
	 *
	 *                       <p><code>flash.system.Security.allowDomain(<i>sourceDomain</i>)</code></p>
	 *                       </li>
	 *                       </ol>
	 */
	static function addCallback(functionName : String, closure : Dynamic) : Void;

	/**
	 * Calls a function exposed by the SWF container, passing zero or more
	 * arguments. If the function is not available, the call returns
	 * <code>null</code>; otherwise it returns the value provided by the
	 * function. Recursion is <i>not</i> permitted on Opera or Netscape browsers;
	 * on these browsers a recursive call produces a <code>null</code> response.
	 * (Recursion is supported on Internet Explorer and Firefox browsers.)
	 *
	 * <p>If the container is an HTML page, this method invokes a JavaScript
	 * function in a <code>script</code> element.</p>
	 *
	 * <p>If the container is another ActiveX container, this method dispatches
	 * the FlashCall ActiveX event with the specified name, and the container
	 * processes the event.</p>
	 *
	 * <p>If the container is hosting the Netscape plug-in, you can either write
	 * custom support for the new NPRuntime interface or embed an HTML control
	 * and embed the player within the HTML control. If you embed an HTML
	 * control, you can communicate with the player through a JavaScript
	 * interface to the native container application.</p>
	 *
	 * <p><b>Note:</b> For <i>local</i> content running in a browser, calls to
	 * the <code>ExternalInterface.call()</code> method are permitted only if the
	 * SWF file and the containing web page(if there is one) are in the
	 * local-trusted security sandbox. Also, you can prevent a SWF file from
	 * using this method by setting the <code>allowNetworking</code> parameter of
	 * the <code>object</code> and <code>embed</code> tags in the HTML page that
	 * contains the SWF content. For more information, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 *
	 * <p><b>Note for Flash Player applications:</b> In Flash Player 10 and Flash
	 * Player 9 Update 5, some web browsers restrict this method if a pop-up
	 * blocker is enabled. In this scenario, you can only call this method
	 * successfully in response to a user event(for example, in an event handler
	 * for a mouse click or keypress event).</p>
	 * 
	 * @param functionName The alphanumeric name of the function to call in the
	 *                     container. Using a non-alphanumeric function name
	 *                     causes a runtime error(error 2155). You can use a
	 *                     <code>try..catch</code> block to handle the error.
	 * @return The response received from the container. If the call failed–
	 *         for example, if there is no such function in the container, the
	 *         interface is not available, a recursion occurred(with a Netscape
	 *         or Opera browser), or there is a security issue–
	 *         <code>null</code> is returned and an error is thrown.
	 * @throws Error         The container does not support outgoing calls.
	 *                       Outgoing calls are supported only in Internet
	 *                       Explorer for Windows and browsers that use the
	 *                       NPRuntime API such as Mozilla 1.7.5 and later or
	 *                       Firefox 1.0 and later.
	 * @throws SecurityError The containing environment belongs to a security
	 *                       sandbox to which the calling code does not have
	 *                       access. To fix this problem, follow these steps:
	 *                       <ol>
	 *                         <li>In the <code>object</code> tag for the SWF
	 *                       file in the containing HTML page, set the following
	 *                       parameter:
	 *
	 *                       <p><code><param name="allowScriptAccess"
	 *                       value="always" /></code></p>
	 *                       </li>
	 *                         <li>In the SWF file, add the following
	 *                       ActionScript:
	 *
	 *
	 *                       <p><code>flash.system.Security.allowDomain(<i>sourceDomain</i>)</code></p>
	 *                       </li>
	 *                       </ol>
	 */
	static function call(functionName : String, ?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic) : Dynamic;
}


#end
