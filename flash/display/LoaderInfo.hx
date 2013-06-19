package flash.display;
#if (flash || display)


/**
 * The LoaderInfo class provides information about a loaded SWF file or a
 * loaded image file(JPEG, GIF, or PNG). LoaderInfo objects are available for
 * any display object. The information provided includes load progress, the
 * URLs of the loader and loaded content, the number of bytes total for the
 * media, and the nominal height and width of the media.
 *
 * <p>You can access LoaderInfo objects in two ways: </p>
 *
 * <ul>
 *   <li>The <code>contentLoaderInfo</code> property of a flash.display.Loader
 * object -  The <code>contentLoaderInfo</code> property is always available
 * for any Loader object. For a Loader object that has not called the
 * <code>load()</code> or <code>loadBytes()</code> method, or that has not
 * sufficiently loaded, attempting to access many of the properties of the
 * <code>contentLoaderInfo</code> property throws an error.</li>
 *   <li>The <code>loaderInfo</code> property of a display object. </li>
 * </ul>
 *
 * <p>The <code>contentLoaderInfo</code> property of a Loader object provides
 * information about the content that the Loader object is loading, whereas
 * the <code>loaderInfo</code> property of a DisplayObject provides
 * information about the root SWF file for that display object. </p>
 *
 * <p>When you use a Loader object to load a display object(such as a SWF
 * file or a bitmap), the <code>loaderInfo</code> property of the display
 * object is the same as the <code>contentLoaderInfo</code> property of the
 * Loader object(<code>DisplayObject.loaderInfo =
 * Loader.contentLoaderInfo</code>). Because the instance of the main class of
 * the SWF file has no Loader object, the <code>loaderInfo</code> property is
 * the only way to access the LoaderInfo for the instance of the main class of
 * the SWF file.</p>
 *
 * <p>The following diagram shows the different uses of the LoaderInfo
 * object - for the instance of the main class of the SWF file, for the
 * <code>contentLoaderInfo</code> property of a Loader object, and for the
 * <code>loaderInfo</code> property of a loaded object:</p>
 *
 * <p>When a loading operation is not complete, some properties of the
 * <code>contentLoaderInfo</code> property of a Loader object are not
 * available. You can obtain some properties, such as
 * <code>bytesLoaded</code>, <code>bytesTotal</code>, <code>url</code>,
 * <code>loaderURL</code>, and <code>applicationDomain</code>. When the
 * <code>loaderInfo</code> object dispatches the <code>init</code> event, you
 * can access all properties of the <code>loaderInfo</code> object and the
 * loaded image or SWF file.</p>
 *
 * <p><b>Note:</b> All properties of LoaderInfo objects are read-only.</p>
 *
 * <p>The <code>EventDispatcher.dispatchEvent()</code> method is not
 * applicable to LoaderInfo objects. If you call <code>dispatchEvent()</code>
 * on a LoaderInfo object, an IllegalOperationError exception is thrown.</p>
 * 
 * @event complete   Dispatched when data has loaded successfully. In other
 *                   words, it is dispatched when all the content has been
 *                   downloaded and the loading has finished. The
 *                   <code>complete</code> event is always dispatched after
 *                   the <code>init</code> event. The <code>init</code> event
 *                   is dispatched when the object is ready to access, though
 *                   the content may still be downloading.
 * @event httpStatus Dispatched when a network request is made over HTTP and
 *                   an HTTP status code can be detected.
 * @event init       Dispatched when the properties and methods of a loaded
 *                   SWF file are accessible and ready for use. The content,
 *                   however, can still be downloading. A LoaderInfo object
 *                   dispatches the <code>init</code> event when the following
 *                   conditions exist:
 *                   <ul>
 *                     <li>All properties and methods associated with the
 *                   loaded object and those associated with the LoaderInfo
 *                   object are accessible.</li>
 *                     <li>The constructors for all child objects have
 *                   completed.</li>
 *                     <li>All ActionScript code in the first frame of the
 *                   loaded SWF's main timeline has been executed.</li>
 *                   </ul>
 *
 *                   <p>For example, an <code>Event.INIT</code> is dispatched
 *                   when the first frame of a movie or animation is loaded.
 *                   The movie is then accessible and can be added to the
 *                   display list. The complete movie, however, can take
 *                   longer to download. The <code>Event.COMPLETE</code> is
 *                   only dispatched once the full movie is loaded.</p>
 *
 *                   <p>The <code>init</code> event always precedes the
 *                   <code>complete</code> event.</p>
 * @event ioError    Dispatched when an input or output error occurs that
 *                   causes a load operation to fail.
 * @event open       Dispatched when a load operation starts.
 * @event progress   Dispatched when data is received as the download
 *                   operation progresses.
 * @event unload     Dispatched by a LoaderInfo object whenever a loaded
 *                   object is removed by using the <code>unload()</code>
 *                   method of the Loader object, or when a second load is
 *                   performed by the same Loader object and the original
 *                   content is removed prior to the load beginning.
 */
extern class LoaderInfo extends flash.events.EventDispatcher {

	/**
	 * The ActionScript version of the loaded SWF file. The language version is
	 * specified by using the enumerations in the ActionScriptVersion class, such
	 * as <code>ActionScriptVersion.ACTIONSCRIPT2</code> and
	 * <code>ActionScriptVersion.ACTIONSCRIPT3</code>.
	 *
	 * <p><b>Note:</b> This property always has a value of either
	 * <code>ActionScriptVersion.ACTIONSCRIPT2</code> or
	 * <code>ActionScriptVersion.ACTIONSCRIPT3</code>. ActionScript 1.0 and 2.0
	 * are both reported as <code>ActionScriptVersion.ACTIONSCRIPT2</code>
	 * (version 2.0). This property only distinguishes ActionScript 1.0 and 2.0
	 * from ActionScript 3.0.</p>
	 * 
	 * @throws Error If the file is not downloaded sufficiently to retrieve the
	 *               requested information.
	 * @throws Error If the file is not a SWF file.
	 */
	#if !display
	var actionScriptVersion(default, null) : ActionScriptVersion;
	#end

	/**
	 * When an external SWF file is loaded, all ActionScript 3.0 definitions
	 * contained in the loaded class are stored in the
	 * <code>applicationDomain</code> property.
	 *
	 * <p>All code in a SWF file is defined to exist in an application domain.
	 * The current application domain is where your main application runs. The
	 * system domain contains all application domains, including the current
	 * domain and all classes used by Flash Player or Adobe AIR.</p>
	 *
	 * <p>All application domains, except the system domain, have an associated
	 * parent domain. The parent domain of your main application's
	 * <code>applicationDomain</code> is the system domain. Loaded classes are
	 * defined only when their parent doesn't already define them. You cannot
	 * override a loaded class definition with a newer definition.</p>
	 *
	 * <p>For usage examples of application domains, see the "Client System
	 * Environment" chapter in the <i>ActionScript 3.0 Developer's Guide</i>.</p>
	 * 
	 * @throws SecurityError This security sandbox of the caller is not allowed
	 *                       to access this ApplicationDomain.
	 */
	var applicationDomain(default, null) : flash.system.ApplicationDomain;

	/**
	 * The bytes associated with a LoaderInfo object.
	 * 
	 * @throws SecurityError If the object accessing this API is prevented from
	 *                       accessing the loaded object due to security
	 *                       restrictions. This situation can occur, for
	 *                       instance, when a Loader object attempts to access
	 *                       the <code>contentLoaderInfo.content</code> property
	 *                       and it is not granted security permission to access
	 *                       the loaded content.
	 *
	 *                       <p>For more information related to security, see the
	 *                       Flash Player Developer Center Topic: <a
	 *                       href="http://www.adobe.com/go/devnet_security_en"
	 *                       scope="external">Security</a>.</p>
	 */
	var bytes(default,null) : flash.utils.ByteArray;

	/**
	 * The number of bytes that are loaded for the media. When this number equals
	 * the value of <code>bytesTotal</code>, all of the bytes are loaded.
	 */
	var bytesLoaded(default,null) : Int;

	/**
	 * The number of compressed bytes in the entire media file.
	 *
	 * <p>Before the first <code>progress</code> event is dispatched by this
	 * LoaderInfo object's corresponding Loader object, <code>bytesTotal</code>
	 * is 0. After the first <code>progress</code> event from the Loader object,
	 * <code>bytesTotal</code> reflects the actual number of bytes to be
	 * downloaded.</p>
	 */
	var bytesTotal(default,null) : Int;

	/**
	 * Expresses the trust relationship from content(child) to the Loader
	 * (parent). If the child has allowed the parent access, <code>true</code>;
	 * otherwise, <code>false</code>. This property is set to <code>true</code>
	 * if the child object has called the <code>allowDomain()</code> method to
	 * grant permission to the parent domain or if a URL policy is loaded at the
	 * child domain that grants permission to the parent domain. If child and
	 * parent are in the same domain, this property is set to <code>true</code>.
	 *
	 * <p>For more information related to security, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @throws Error Thrown if the file is not downloaded sufficiently to
	 *               retrieve the requested information.
	 */
	#if !display
	var childAllowsParent(default, null) : Bool;
	@:require(flash11_4) var childSandboxBridge : Dynamic;
	#end

	/**
	 * The loaded object associated with this LoaderInfo object.
	 * 
	 * @throws SecurityError If the object accessing this API is prevented from
	 *                       accessing the loaded object due to security
	 *                       restrictions. This situation can occur, for
	 *                       instance, when a Loader object attempts to access
	 *                       the <code>contentLoaderInfo.content</code> property
	 *                       and it is not granted security permission to access
	 *                       the loaded content.
	 *
	 *                       <p>For more information related to security, see the
	 *                       Flash Player Developer Center Topic: <a
	 *                       href="http://www.adobe.com/go/devnet_security_en"
	 *                       scope="external">Security</a>.</p>
	 */
	var content(default,null) : DisplayObject;

	/**
	 * The MIME type of the loaded file. The value is <code>null</code> if not
	 * enough of the file has loaded in order to determine the type. The
	 * following list gives the possible values:
	 * <ul>
	 *   <li><code>"application/x-shockwave-flash"</code></li>
	 *   <li><code>"image/jpeg"</code></li>
	 *   <li><code>"image/gif"</code></li>
	 *   <li><code>"image/png"</code></li>
	 * </ul>
	 */
	var contentType(default,null) : String;

	/**
	 * The nominal frame rate, in frames per second, of the loaded SWF file. This
	 * number is often an integer, but need not be.
	 *
	 * <p>This value may differ from the actual frame rate in use. Flash Player
	 * or Adobe AIR only uses a single frame rate for all loaded SWF files at any
	 * one time, and this frame rate is determined by the nominal frame rate of
	 * the main SWF file. Also, the main frame rate may not be able to be
	 * achieved, depending on hardware, sound synchronization, and other
	 * factors.</p>
	 * 
	 * @throws Error If the file is not downloaded sufficiently to retrieve the
	 *               requested information.
	 * @throws Error If the file is not a SWF file.
	 */
	var frameRate(default,null) : Float;

	/**
	 * The nominal height of the loaded file. This value might differ from the
	 * actual height at which the content is displayed, since the loaded content
	 * or its parent display objects might be scaled.
	 * 
	 * @throws Error If the file is not downloaded sufficiently to retrieve the
	 *               requested information.
	 */
	var height(default,null) : Int;

	/**
	 * Indicates if the <code>LoaderInfo.url</code> property has been truncated.
	 * When the <code>isURLInaccessible</code> value is <code>true</code> the
	 * <code>LoaderInfo.url</code> value is only the domain of the final URL from
	 * which the content loaded. For example, the property is truncated if the
	 * content is loaded from <code>http://www.adobe.com/assets/hello.swf</code>,
	 * and the <code>LoaderInfo.url</code> property has the value
	 * <code>http://www.adobe.com</code>. The <code>isURLInaccessible</code>
	 * value is <code>true</code> only when all of the following are also true:
	 * <ul>
	 *   <li>An HTTP redirect occurred while loading the content.</li>
	 *   <li>The SWF file calling <code>Loader.load()</code> is from a different
	 * domain than the content's final URL.</li>
	 *   <li>The SWF file calling <code>Loader.load()</code> does not have
	 * permission to access the content. Permission is granted to access the
	 * content the same way permission is granted for
	 * <code>BitmapData.draw()</code>: call <code>Security.allowDomain()</code>
	 * to access a SWF file(or for non-SWF file content, establish a policy file
	 * and use the <code>LoaderContext.checkPolicyFile</code> property).</li>
	 * </ul>
	 *
	 * <p><b>Note:</b> The <code>isURLInaccessible</code> property was added for
	 * Flash Player 10.1 and AIR 2.0. However, this property is made available to
	 * SWF files of all versions when the Flash runtime supports it. So, using
	 * some authoring tools in "strict mode" causes a compilation error. To work
	 * around the error use the indirect syntax
	 * <code>myLoaderInfo["isURLInaccessible"]</code>, or disable strict mode. If
	 * you are using Flash Professional CS5 or Flex SDK 4.1, you can use and
	 * compile this API for runtimes released before Flash Player 10.1 and AIR
	 * 2.</p>
	 *
	 * <p>For application content in AIR, the value of this property is always
	 * <code>false</code>.</p>
	 */
	#if !display
	@:require(flash10_1) var isURLInaccessible(default, null) : Bool;
	#end

	/**
	 * The Loader object associated with this LoaderInfo object. If this
	 * LoaderInfo object is the <code>loaderInfo</code> property of the instance
	 * of the main class of the SWF file, no Loader object is associated.
	 * 
	 * @throws SecurityError If the object accessing this API is prevented from
	 *                       accessing the Loader object because of security
	 *                       restrictions. This can occur, for instance, when a
	 *                       loaded SWF file attempts to access its
	 *                       <code>loaderInfo.loader</code> property and it is
	 *                       not granted security permission to access the
	 *                       loading SWF file.
	 *
	 *                       <p>For more information related to security, see the
	 *                       Flash Player Developer Center Topic: <a
	 *                       href="http://www.adobe.com/go/devnet_security_en"
	 *                       scope="external">Security</a>.</p>
	 */
	var loader(default,null) : Loader;

	/**
	 * The URL of the SWF file that initiated the loading of the media described
	 * by this LoaderInfo object. For the instance of the main class of the SWF
	 * file, this URL is the same as the SWF file's own URL.
	 */
	var loaderURL(default,null) : String;

	/**
	 * An object that contains name-value pairs that represent the parameters
	 * provided to the loaded SWF file.
	 *
	 * <p>You can use a <code>for-in</code> loop to extract all the names and
	 * values from the <code>parameters</code> object.</p>
	 *
	 * <p>The two sources of parameters are: the query string in the URL of the
	 * main SWF file, and the value of the <code>FlashVars</code> HTML parameter
	 * (this affects only the main SWF file).</p>
	 *
	 * <p>The <code>parameters</code> property replaces the ActionScript 1.0 and
	 * 2.0 technique of providing SWF file parameters as properties of the main
	 * timeline.</p>
	 *
	 * <p>The value of the <code>parameters</code> property is null for Loader
	 * objects that contain SWF files that use ActionScript 1.0 or 2.0. It is
	 * only non-null for Loader objects that contain SWF files that use
	 * ActionScript 3.0.</p>
	 */
	var parameters(default,null) : Dynamic<String>;

	/**
	 * Expresses the trust relationship from Loader(parent) to the content
	 * (child). If the parent has allowed the child access, <code>true</code>;
	 * otherwise, <code>false</code>. This property is set to <code>true</code>
	 * if the parent object called the <code>allowDomain()</code> method to grant
	 * permission to the child domain or if a URL policy file is loaded at the
	 * parent domain granting permission to the child domain. If child and parent
	 * are in the same domain, this property is set to <code>true</code>.
	 *
	 * <p>For more information related to security, see the Flash Player
	 * Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @throws Error Thrown if the file is not downloaded sufficiently to
	 *               retrieve the requested information.
	 */
	var parentAllowsChild(default, null) : Bool;
	
	#if !display
	@:require(flash11_4) var parentSandboxBridge : Dynamic;
	#end

	/**
	 * Expresses the domain relationship between the loader and the content:
	 * <code>true</code> if they have the same origin domain; <code>false</code>
	 * otherwise.
	 * 
	 * @throws Error Thrown if the file is not downloaded sufficiently to
	 *               retrieve the requested information.
	 */
	var sameDomain(default,null) : Bool;

	/**
	 * An EventDispatcher instance that can be used to exchange events across
	 * security boundaries. Even when the Loader object and the loaded content
	 * originate from security domains that do not trust one another, both can
	 * access <code>sharedEvents</code> and send and receive events via this
	 * object.
	 */
	var sharedEvents(default,null) : flash.events.EventDispatcher;

	/**
	 * The file format version of the loaded SWF file. The file format is
	 * specified using the enumerations in the SWFVersion class, such as
	 * <code>SWFVersion.FLASH7</code> and <code>SWFVersion.FLASH9</code>.
	 * 
	 * @throws Error If the file is not downloaded sufficiently to retrieve the
	 *               requested information.
	 * @throws Error If the file is not a SWF file.
	 */
	#if !display
	var swfVersion(default, null) : Int;
	#end

	/**
	 * An object that dispatches an <code>uncaughtError</code> event when an
	 * unhandled error occurs in code in this LoaderInfo object's SWF file. An
	 * uncaught error happens when an error is thrown outside of any
	 * <code>try..catch</code> blocks or when an ErrorEvent object is dispatched
	 * with no registered listeners.
	 *
	 * <p>This property is created when the SWF associated with this LoaderInfo
	 * has finished loading. Until then the <code>uncaughtErrorEvents</code>
	 * property is <code>null</code>. In an ActionScript-only project, you can
	 * access this property during or after the execution of the constructor
	 * function of the main class of the SWF file. For a Flex project, the
	 * <code>uncaughtErrorEvents</code> property is available after the
	 * <code>applicationComplete</code> event is dispatched.</p>
	 */
	#if !display
	@:require(flash10_1) var uncaughtErrorEvents(default, null) : flash.events.UncaughtErrorEvents;
	#end

	/**
	 * The URL of the media being loaded.
	 *
	 * <p>Before the first <code>progress</code> event is dispatched by this
	 * LoaderInfo object's corresponding Loader object, the value of the
	 * <code>url</code> property might reflect only the initial URL specified in
	 * the call to the <code>load()</code> method of the Loader object. After the
	 * first <code>progress</code> event, the <code>url</code> property reflects
	 * the media's final URL, after any redirects and relative URLs are
	 * resolved.</p>
	 *
	 * <p>In some cases, the value of the <code>url</code> property is truncated;
	 * see the <code>isURLInaccessible</code> property for details.</p>
	 */
	var url(default,null) : String;

	/**
	 * The nominal width of the loaded content. This value might differ from the
	 * actual width at which the content is displayed, since the loaded content
	 * or its parent display objects might be scaled.
	 * 
	 * @throws Error If the file is not downloaded sufficiently to retrieve the
	 *               requested information.
	 */
	var width(default,null) : Int;

	/**
	 * Returns the LoaderInfo object associated with a SWF file defined as an
	 * object.
	 * 
	 * @param object The object for which you want to get an associated
	 *               LoaderInfo object.
	 * @return The associated LoaderInfo object. Returns <code>null</code> when
	 *         called in non-debugger builds(or when debugging is not enabled)
	 *         or if the referenced <code>object</code> does not have an
	 *         associated LoaderInfo object(such as some objects used by the AIR
	 *         runtime).
	 * @throws SecurityError The caller is not running in the local trusted
	 *                       sandbox.
	 */
	#if !display
	static function getLoaderInfoByDefinition(object : Dynamic) : LoaderInfo;
	#end
}


#end
