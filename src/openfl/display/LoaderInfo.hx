package openfl.display;

#if !flash
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;
#if (js && html5)
import js.Browser;
#end

/**
	The LoaderInfo class provides information about a loaded SWF file or a
	loaded image file(JPEG, GIF, or PNG). LoaderInfo objects are available for
	any display object. The information provided includes load progress, the
	URLs of the loader and loaded content, the number of bytes total for the
	media, and the nominal height and width of the media.

	You can access LoaderInfo objects in two ways:

	* The `contentLoaderInfo` property of a openfl.display.Loader
	object -  The `contentLoaderInfo` property is always available
	for any Loader object. For a Loader object that has not called the
	`load()` or `loadBytes()` method, or that has not
	sufficiently loaded, attempting to access many of the properties of the
	`contentLoaderInfo` property throws an error.
	* The `loaderInfo` property of a display object.

	The `contentLoaderInfo` property of a Loader object provides
	information about the content that the Loader object is loading, whereas
	the `loaderInfo` property of a DisplayObject provides
	information about the root SWF file for that display object.

	When you use a Loader object to load a display object(such as a SWF
	file or a bitmap), the `loaderInfo` property of the display
	object is the same as the `contentLoaderInfo` property of the
	Loader object(`DisplayObject.loaderInfo =
	Loader.contentLoaderInfo`). Because the instance of the main class of
	the SWF file has no Loader object, the `loaderInfo` property is
	the only way to access the LoaderInfo for the instance of the main class of
	the SWF file.

	The following diagram shows the different uses of the LoaderInfo
	object - for the instance of the main class of the SWF file, for the
	`contentLoaderInfo` property of a Loader object, and for the
	`loaderInfo` property of a loaded object:

	When a loading operation is not complete, some properties of the
	`contentLoaderInfo` property of a Loader object are not
	available. You can obtain some properties, such as
	`bytesLoaded`, `bytesTotal`, `url`,
	`loaderURL`, and `applicationDomain`. When the
	`loaderInfo` object dispatches the `init` event, you
	can access all properties of the `loaderInfo` object and the
	loaded image or SWF file.

	**Note:** All properties of LoaderInfo objects are read-only.

	The `EventDispatcher.dispatchEvent()` method is not
	applicable to LoaderInfo objects. If you call `dispatchEvent()`
	on a LoaderInfo object, an IllegalOperationError exception is thrown.

	@event complete   Dispatched when data has loaded successfully. In other
					  words, it is dispatched when all the content has been
					  downloaded and the loading has finished. The
					  `complete` event is always dispatched after
					  the `init` event. The `init` event
					  is dispatched when the object is ready to access, though
					  the content may still be downloading.
	@event httpStatus Dispatched when a network request is made over HTTP and
					  an HTTP status code can be detected.
	@event init       Dispatched when the properties and methods of a loaded
					  SWF file are accessible and ready for use. The content,
					  however, can still be downloading. A LoaderInfo object
					  dispatches the `init` event when the following
					  conditions exist:

					   * All properties and methods associated with the
					  loaded object and those associated with the LoaderInfo
					  object are accessible.
					   * The constructors for all child objects have
					  completed.
					   * All ActionScript code in the first frame of the
					  loaded SWF's main timeline has been executed.

					  For example, an `Event.INIT` is dispatched
					  when the first frame of a movie or animation is loaded.
					  The movie is then accessible and can be added to the
					  display list. The complete movie, however, can take
					  longer to download. The `Event.COMPLETE` is
					  only dispatched once the full movie is loaded.

					  The `init` event always precedes the
					  `complete` event.
	@event ioError    Dispatched when an input or output error occurs that
					  causes a load operation to fail.
	@event open       Dispatched when a load operation starts.
	@event progress   Dispatched when data is received as the download
					  operation progresses.
	@event unload     Dispatched by a LoaderInfo object whenever a loaded
					  object is removed by using the `unload()`
					  method of the Loader object, or when a second load is
					  performed by the same Loader object and the original
					  content is removed prior to the load beginning.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LoaderInfo extends EventDispatcher
{
	@:noCompletion private static var __rootURL:String = #if (js && html5) (Browser.supported ? Browser.document.URL : "") #else "" #end;

	// @:noCompletion @:dox(hide) public var actionScriptVersion (default, never):openfl.display.ActionScriptVersion;

	/**
		When an external SWF file is loaded, all ActionScript 3.0 definitions
		contained in the loaded class are stored in the
		`applicationDomain` property.

		All code in a SWF file is defined to exist in an application domain.
		The current application domain is where your main application runs. The
		system domain contains all application domains, including the current
		domain and all classes used by Flash Player or Adobe AIR.

		All application domains, except the system domain, have an associated
		parent domain. The parent domain of your main application's
		`applicationDomain` is the system domain. Loaded classes are
		defined only when their parent doesn't already define them. You cannot
		override a loaded class definition with a newer definition.

		For usage examples of application domains, see the "Client System
		Environment" chapter in the _ActionScript 3.0 Developer's Guide_.

		@throws SecurityError This security sandbox of the caller is not allowed
							  to access this ApplicationDomain.
	**/
	public var applicationDomain(default, null):ApplicationDomain;

	/**
		The bytes associated with a LoaderInfo object.

		@throws SecurityError If the object accessing this API is prevented from
							  accessing the loaded object due to security
							  restrictions. This situation can occur, for
							  instance, when a Loader object attempts to access
							  the `contentLoaderInfo.content` property
							  and it is not granted security permission to access
							  the loaded content.

							  For more information related to security, see the
							  Flash Player Developer Center Topic:
							  [Security](http://www.adobe.com/go/devnet_security_en).
	**/
	public var bytes(default, null):ByteArray;

	/**
		The number of bytes that are loaded for the media. When this number equals
		the value of `bytesTotal`, all of the bytes are loaded.
	**/
	public var bytesLoaded(default, null):Int;

	/**
		The number of compressed bytes in the entire media file.

		Before the first `progress` event is dispatched by this
		LoaderInfo object's corresponding Loader object, `bytesTotal`
		is 0. After the first `progress` event from the Loader object,
		`bytesTotal` reflects the actual number of bytes to be
		downloaded.
	**/
	public var bytesTotal(default, null):Int;

	/**
		Expresses the trust relationship from content(child) to the Loader
		(parent). If the child has allowed the parent access, `true`;
		otherwise, `false`. This property is set to `true`
		if the child object has called the `allowDomain()` method to
		grant permission to the parent domain or if a URL policy is loaded at the
		child domain that grants permission to the parent domain. If child and
		parent are in the same domain, this property is set to `true`.

		For more information related to security, see the Flash Player
		Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		@throws Error Thrown if the file is not downloaded sufficiently to
					  retrieve the requested information.
	**/
	public var childAllowsParent(default, null):Bool;

	// @:noCompletion @:dox(hide) @:require(flash11_4) public var childSandboxBridge:Dynamic;

	/**
		The loaded object associated with this LoaderInfo object.

		@throws SecurityError If the object accessing this API is prevented from
							  accessing the loaded object due to security
							  restrictions. This situation can occur, for
							  instance, when a Loader object attempts to access
							  the `contentLoaderInfo.content` property
							  and it is not granted security permission to access
							  the loaded content.

							  For more information related to security, see the
							  Flash Player Developer Center Topic:
							  [Security](http://www.adobe.com/go/devnet_security_en).
	**/
	public var content(default, null):DisplayObject;

	/**
		The MIME type of the loaded file. The value is `null` if not
		enough of the file has loaded in order to determine the type. The
		following list gives the possible values:

		* `"application/x-shockwave-flash"`
		* `"image/jpeg"`
		* `"image/gif"`
		* `"image/png"`
	**/
	public var contentType(default, null):String;

	/**
		The nominal frame rate, in frames per second, of the loaded SWF file. This
		number is often an integer, but need not be.

		This value may differ from the actual frame rate in use. Flash Player
		or Adobe AIR only uses a single frame rate for all loaded SWF files at any
		one time, and this frame rate is determined by the nominal frame rate of
		the main SWF file. Also, the main frame rate may not be able to be
		achieved, depending on hardware, sound synchronization, and other
		factors.

		@throws Error If the file is not downloaded sufficiently to retrieve the
					  requested information.
		@throws Error If the file is not a SWF file.
	**/
	public var frameRate(default, null):Float;

	/**
		The nominal height of the loaded file. This value might differ from the
		actual height at which the content is displayed, since the loaded content
		or its parent display objects might be scaled.

		@throws Error If the file is not downloaded sufficiently to retrieve the
					  requested information.
	**/
	public var height(default, null):Int;

	// @:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):Bool;

	/**
		The Loader object associated with this LoaderInfo object. If this
		LoaderInfo object is the `loaderInfo` property of the instance
		of the main class of the SWF file, no Loader object is associated.

		@throws SecurityError If the object accessing this API is prevented from
							  accessing the Loader object because of security
							  restrictions. This can occur, for instance, when a
							  loaded SWF file attempts to access its
							  `loaderInfo.loader` property and it is
							  not granted security permission to access the
							  loading SWF file.

							  For more information related to security, see the
							  Flash Player Developer Center Topic:
							  [Security](http://www.adobe.com/go/devnet_security_en).
	**/
	public var loader(default, null):Loader;

	/**
		The URL of the SWF file that initiated the loading of the media described
		by this LoaderInfo object. For the instance of the main class of the SWF
		file, this URL is the same as the SWF file's own URL.
	**/
	public var loaderURL(default, null):String;

	/**
		An object that contains name-value pairs that represent the parameters
		provided to the loaded SWF file.

		You can use a `for-in` loop to extract all the names and
		values from the `parameters` object.

		The two sources of parameters are: the query string in the URL of the
		main SWF file, and the value of the `FlashVars` HTML parameter
		(this affects only the main SWF file).

		The `parameters` property replaces the ActionScript 1.0 and
		2.0 technique of providing SWF file parameters as properties of the main
		timeline.

		The value of the `parameters` property is null for Loader
		objects that contain SWF files that use ActionScript 1.0 or 2.0. It is
		only non-null for Loader objects that contain SWF files that use
		ActionScript 3.0.
	**/
	@SuppressWarnings("checkstyle:Dynamic")
	public var parameters(default, null):Dynamic<String>;

	/**
		Expresses the trust relationship from Loader(parent) to the content
		(child). If the parent has allowed the child access, `true`;
		otherwise, `false`. This property is set to `true`
		if the parent object called the `allowDomain()` method to grant
		permission to the child domain or if a URL policy file is loaded at the
		parent domain granting permission to the child domain. If child and parent
		are in the same domain, this property is set to `true`.

		For more information related to security, see the Flash Player
		Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).

		@throws Error Thrown if the file is not downloaded sufficiently to
					  retrieve the requested information.
	**/
	public var parentAllowsChild(default, null):Bool;

	// @:noCompletion @:dox(hide) @:require(flash11_4) public var parentSandboxBridge:Dynamic;

	/**
		Expresses the domain relationship between the loader and the content:
		`true` if they have the same origin domain; `false`
		otherwise.

		@throws Error Thrown if the file is not downloaded sufficiently to
					  retrieve the requested information.
	**/
	public var sameDomain(default, null):Bool;

	/**
		An EventDispatcher instance that can be used to exchange events across
		security boundaries. Even when the Loader object and the loaded content
		originate from security domains that do not trust one another, both can
		access `sharedEvents` and send and receive events via this
		object.
	**/
	public var sharedEvents(default, null):EventDispatcher;

	// @:noCompletion @:dox(hide) public var swfVersion (default, null):UInt;

	/**
		An object that dispatches an `uncaughtError` event when an
		unhandled error occurs in code in this LoaderInfo object's SWF file. An
		uncaught error happens when an error is thrown outside of any
		`try..catch` blocks or when an ErrorEvent object is dispatched
		with no registered listeners.

		This property is created when the SWF associated with this LoaderInfo
		has finished loading. Until then the `uncaughtErrorEvents`
		property is `null`. In an ActionScript-only project, you can
		access this property during or after the execution of the constructor
		function of the main class of the SWF file. For a Flex project, the
		`uncaughtErrorEvents` property is available after the
		`applicationComplete` event is dispatched.
	**/
	public var uncaughtErrorEvents(default, null):UncaughtErrorEvents;

	/**
		The URL of the media being loaded.

		Before the first `progress` event is dispatched by this
		LoaderInfo object's corresponding Loader object, the value of the
		`url` property might reflect only the initial URL specified in
		the call to the `load()` method of the Loader object. After the
		first `progress` event, the `url` property reflects
		the media's final URL, after any redirects and relative URLs are
		resolved.

		In some cases, the value of the `url` property is truncated;
		see the `isURLInaccessible` property for details.
	**/
	public var url(default, null):String;

	/**
		The nominal width of the loaded content. This value might differ from the
		actual width at which the content is displayed, since the loaded content
		or its parent display objects might be scaled.

		@throws Error If the file is not downloaded sufficiently to retrieve the
					  requested information.
	**/
	public var width(default, null):Int;

	@:noCompletion private var __completed:Bool;

	@:noCompletion private function new()
	{
		super();

		applicationDomain = ApplicationDomain.currentDomain;
		bytesLoaded = 0;
		bytesTotal = 0;
		childAllowsParent = true;
		parameters = {};
	}

	@:noCompletion @:dox(hide)
	@SuppressWarnings("checkstyle:FieldDocComment")
	public static function create(loader:Loader):LoaderInfo
	{
		var loaderInfo = new LoaderInfo();
		loaderInfo.uncaughtErrorEvents = new UncaughtErrorEvents();

		if (loader != null)
		{
			loaderInfo.loader = loader;
		}
		else
		{
			loaderInfo.url = __rootURL;
		}

		return loaderInfo;
	}

	// @:noCompletion @:dox(hide) public static function getLoaderInfoByDefinition (object:Dynamic):LoaderInfo;
	@:noCompletion private function __complete():Void
	{
		if (!__completed)
		{
			if (bytesLoaded < bytesTotal)
			{
				bytesLoaded = bytesTotal;
			}

			__update(bytesLoaded, bytesTotal);
			__completed = true;

			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	@:noCompletion private function __update(bytesLoaded:Int, bytesTotal:Int):Void
	{
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;

		dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
	}
}
#else
typedef LoaderInfo = flash.display.LoaderInfo;
#end
