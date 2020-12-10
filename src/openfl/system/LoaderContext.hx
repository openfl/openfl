package openfl.system;

#if !flash
/**
	The LoaderContext class provides options for loading SWF files and other
	media by using the Loader class. The LoaderContext class is used as the
	`context` parameter in the `load()` and `loadBytes()` methods of the
	Loader class.
	When loading SWF files with the `Loader.load()` method, you have two
	decisions to make: into which security domain the loaded SWF file should
	be placed, and into which application domain within that security domain?
	For more details on these choices, see the `applicationDomain` and
	`securityDomain` properties.

	When loading a SWF file with the `Loader.loadBytes()` method, you have the
	same application domain choice to make as for `Loader.load()`, but it's
	not necessary to specify a security domain, because `Loader.loadBytes()`
	always places its loaded SWF file into the security domain of the loading
	SWF file.

	When loading images (JPEG, GIF, or PNG) instead of SWF files, there is no
	need to specify a SecurityDomain or an application domain, because those
	concepts are meaningful only for SWF files. Instead, you have only one
	decision to make: do you need programmatic access to the pixels of the
	loaded image? If so, see the `checkPolicyFile` property. If you want to
	apply deblocking when loading an image, use the JPEGLoaderContext class
	instead of the LoaderContext class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LoaderContext
{
	/**
		Specifies whether you can use a `Loader` object to import content with
		executable code, such as a SWF file, into the caller's security
		sandbox. There are two affected importing operations: the
		`Loader.loadBytes()` method, and the `Loader.load()` method with
		`LoaderContext.securityDomain = SecurityDomain.currentDomain`. (The
		latter operation is not supported in the AIR application sandbox.)
		With the `allowCodeImport` property set to `false`, these importing
		operations are restricted to safe operations, such as loading images.
		Normal, non-importing SWF file loading with the `Loader.load()` method
		is not affected by the value of this property.
		This property is useful when you want to import image content into
		your sandbox - for example, when you want to replicate or process an
		image from a different domain - but you don't want to take the
		security risk of receiving a SWF file when you expected only an image
		file. Since SWF files may contain ActionScript code, importing a SWF
		file is a much riskier operation than importing an image file.

		In AIR content in the application sandbox, the default value is
		`false`. In non-application content (which includes all content in
		Flash Player), the default value is `true`.

		The `allowCodeImport` property was added in Flash Player 10.1 and AIR
		2.0. However, this property is made available to SWF files and AIR
		applications of all versions when the Flash Runtime supports it.
	**/
	public var allowCodeImport:Bool;

	/**
		Legacy property, replaced by `allowCodeImport`, but still supported
		for compatibility. Previously, the only operation affected by
		`allowLoadBytesCodeExecution` was the `Loader.loadBytes()` method, but
		as of Flash Player 10.1 and AIR 2.0, the import-loading operation of
		`Loader.load()` with `LoaderContext.securityDomain =
		SecurityDomain.currentDomain` is affected as well. (The latter
		operation is not supported in the AIR application sandbox.) This dual
		effect made the property name `allowLoadBytesCodeExecution` overly
		specific, so now `allowCodeImport` is the preferred property name.
		Setting either of `allowCodeImport` or `allowLoadBytesCodeExecution`
		will affect the value of both.
		Specifies whether you can use a `Loader` object to import content with
		executable code, such as a SWF file, into the caller's security
		sandbox. With this property set to `false`, these importing operations
		are restricted to safe operations, such as loading images.

		In AIR content in the application sandbox, the default value is
		`false`. In non-application content, the default value is `true`.
	**/
	public var allowLoadBytesCodeExecution:Bool;

	/**
		Specifies the application domain to use for the `Loader.load()` or
		`Loader.loadBytes()` method. Use this property only when loading a SWF
		file written in ActionScript 3.0 (not an image or a SWF file written
		in ActionScript 1.0 or ActionScript 2.0).
		Every security domain is divided into one or more application domains,
		represented by ApplicationDomain objects. Application domains are not
		for security purposes; they are for managing cooperating units of
		ActionScript code. If you are loading a SWF file from another domain,
		and allowing it to be placed in a separate security domain, then you
		cannot control the choice of application domain into which the loaded
		SWF file is placed; and if you have specified a choice of application
		domain, it will be ignored. However, if you are loading a SWF file
		into your own security domain � either because the SWF file comes
		from your own domain, or because you are importing it into your
		security domain � then you can control the choice of application
		domain for the loaded SWF file.

		You can pass an application domain only from your own security domain
		in `LoaderContext.applicationDomain`. Attempting to pass an
		application domain from any other security domain results in a
		`SecurityError` exception.

		You have four choices for what kind of `ApplicationDomain` property to
		use:

		* **Child of loader's ApplicationDomain.** The default. You can
		explicitly represent this choice with the syntax `new
		ApplicationDomain(ApplicationDomain.currentDomain)`. This allows the
		loaded SWF file to use the parent's classes directly, for example by
		writing `new MyClassDefinedInParent()`. The parent, however, cannot
		use this syntax; if the parent wishes to use the child's classes, it
		must call `ApplicationDomain.getDefinition()` to retrieve them. The
		advantage of this choice is that, if the child defines a class with
		the same name as a class already defined by the parent, no error
		results; the child simply inherits the parent's definition of that
		class, and the child's conflicting definition goes unused unless
		either child or parent calls the `ApplicationDomain.getDefinition()`
		method to retrieve it.
		* **Loader's own ApplicationDomain.** You use this application domain
		when using `ApplicationDomain.currentDomain`. When the load is
		complete, parent and child can use each other's classes directly. If
		the child attempts to define a class with the same name as a class
		already defined by the parent, the parent class is used and the child
		class is ignored.
		* **Child of the system ApplicationDomain.** You use this application
		domain when using `new ApplicationDomain(null)`. This separates loader
		and loadee entirely, allowing them to define separate versions of
		classes with the same name without conflict or overshadowing. The only
		way either side sees the other's classes is by calling the
		`ApplicationDomain.getDefinition()` method.
		* **Child of some other ApplicationDomain.** Occasionally you may have
		a more complex ApplicationDomain hierarchy. You can load a SWF file
		into any ApplicationDomain from your own SecurityDomain. For example,
		`new
		ApplicationDomain(ApplicationDomain.currentDomain.parentDomain.parentDomain)`
		loads a SWF file into a new child of the current domain's parent's
		parent.

		When a load is complete, either side (loading or loaded) may need to
		find its own ApplicationDomain, or the other side's ApplicationDomain,
		for the purpose of calling `ApplicationDomain.getDefinition()`. Either
		side can retrieve a reference to its own application domain by using
		`ApplicationDomain.currentDomain`. The loading SWF file can retrieve a
		reference to the loaded SWF file's ApplicationDomain via
		`Loader.contentLoaderInfo.applicationDomain`. If the loaded SWF file
		knows how it was loaded, it can find its way to the loading SWF file's
		ApplicationDomain object. For example, if the child was loaded in the
		default way, it can find the loading SWF file's application domain by
		using `ApplicationDomain.currentDomain.parentDomain`.

		For more information, see the "ApplicationDomain class" section of the
		"Client System Environment" chapter of the _ActionScript 3.0
		Developer's Guide_.
	**/
	public var applicationDomain:ApplicationDomain;

	/**
		Specifies whether the application should attempt to download a URL
		policy file from the loaded object's server before beginning to load
		the object itself. This flag is applicable to the `Loader.load()`
		method, but not to the `Loader.loadBytes()` method.
		Set this flag to `true` when you are loading an image (JPEG, GIF, or
		PNG) from outside the calling SWF file's own domain, and you expect to
		need access to the content of that image from ActionScript. Examples
		of accessing image content include referencing the `Loader.content`
		property to obtain a Bitmap object, and calling the
		`BitmapData.draw()` method to obtain a copy of the loaded image's
		pixels. If you attempt one of these operations without having
		specified `checkPolicyFile` at loading time, you may get a
		`SecurityError` exception because the needed policy file has not been
		downloaded yet.

		When you call the `Loader.load()` method with
		`LoaderContext.checkPolicyFile` set to `true`, the application does
		not begin downloading the specified object in `URLRequest.url` until
		it has either successfully downloaded a relevant URL policy file or
		discovered that no such policy file exists. Flash Player or AIR first
		considers policy files that have already been downloaded, then
		attempts to download any pending policy files specified in calls to
		the `Security.loadPolicyFile()` method, then attempts to download a
		policy file from the default location that corresponds to
		`URLRequest.url`, which is `/crossdomain.xml` on the same server as
		`URLRequest.url`. In all cases, the given policy file is required to
		exist at `URLRequest.url` by virtue of the policy file's location, and
		the file must permit access by virtue of one or more
		`<allow-access-from>` tags.

		If you set `checkPolicyFile` to `true`, the main download that
		specified in the `Loader.load()` method does not load until the policy
		file has been completely processed. Therefore, as long as the policy
		file that you need exists, as soon as you have received any
		`ProgressEvent.PROGRESS` or `Event.COMPLETE` events from the
		`contentLoaderInfo` property of your Loader object, the policy file
		download is complete, and you can safely begin performing operations
		that require the policy file.

		If you set `checkPolicyFile` to `true`, and no relevant policy file is
		found, you will not receive any error indication until you attempt an
		operation that throws a `SecurityError` exception. However, once the
		LoaderInfo object dispatches a `ProgressEvent.PROGRESS` or
		`Event.COMPLETE` event, you can test whether a relevant policy file
		was found by checking the value of the `LoaderInfo.childAllowsParent`
		property.

		If you will not need pixel-level access to the image that you are
		loading, you should not set the `checkPolicyFile` property to `true`.
		Checking for a policy file in this case is wasteful, because it may
		delay the start of your download, and it may consume network bandwidth
		unnecessarily.

		Also try to avoid setting `checkPolicyFile` to `true` if you are using
		the `Loader.load()` method to download a SWF file. This is because
		SWF-to-SWF permissions are not controlled by policy files, but rather
		by the `Security.allowDomain()` method, and thus `checkPolicyFile` has
		no effect when you load a SWF file. Checking for a policy file in this
		case is wasteful, because it may delay the download of the SWF file,
		and it may consume network bandwidth unnecessarily. (Flash Player or
		AIR cannot tell whether your main download will be a SWF file or an
		image, because the policy file download occurs before the main
		download.)

		Be careful with `checkPolicyFile` if you are downloading an object
		from a URL that may use server-side HTTP redirects. Policy files are
		always retrieved from the corresponding initial URL that you specify
		in `URLRequest.url`. If the final object comes from a different URL
		because of HTTP redirects, then the initially downloaded policy files
		might not be applicable to the object's final URL, which is the URL
		that matters in security decisions. If you find yourself in this
		situation, you can examine the value of `LoaderInfo.url` after you
		have received a `ProgressEvent.PROGRESS` or `Event.COMPLETE` event,
		which tells you the object's final URL. Then call the
		`Security.loadPolicyFile()` method with a policy file URL based on the
		object's final URL. Then poll the value of
		`LoaderInfo.childAllowsParent` until it becomes `true`.

		You do not need to set this property for AIR content running in the
		application sandbox. Content in the AIR application sandbox can call
		the `BitmapData.draw()` method using any loaded image content as the
		source.
	**/
	public var checkPolicyFile:Bool;

	#if false
	/**
		Specifies whether to decode image data when it is used or when it is
		loaded.
		Under the default policy, `ImageDecodingPolicy.ON_DEMAND`, the runtime
		decodes the image data when the data is needed for display or other
		purpose. This policy maintains the decoding behavior used by previous
		versions of the runtime.

		Under the `ImageDecodingPolicy.ON_LOAD` policy, the runtime decodes
		the image immediately after it is loaded and before dispatching the
		complete event. Decoding images on load rather than on demand can
		improve animation and UI performance when several loaded images are
		displayed in quick succession, such as in a scrolling list or a cover
		flow control. On the other hand, using the onLoad policy
		indiscriminately can increase the peak memory usage of your
		application since more decoded image data might be in memory at one
		time than would be the case under the onDemand policy.

		Under both policies, the runtime uses the same cache and flush
		behavior after the image is decoded. The runtime can flush the decoded
		data at any time and re-decode the image the next time it is required.
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public var imageDecodingPolicy:openfl.system.ImageDecodingPolicy;
	#end

	#if false
	/**
		An Object containing the parameters to pass to the LoaderInfo object
		of the content.
		Normally, the value of the `contentLoaderInfo.parameters` property is
		obtained by parsing the requesting URL. If the `parameters` var is
		set, the `contentLoaderInfo.parameters` gets its value from the
		LoaderContext object, instead of from the requesting URL. The
		`parameters` var accepts only objects containing name-value string
		pairs, similar to URL parameters. If the object does not contain
		name-value string pairs, an `IllegalOperationError` is thrown.

		The intent of this API is to enable the loading SWF file to forward
		its parameters to a loaded SWF file. This functionality is especially
		helpful when you use the `loadBytes()` method, since `LoadBytes` does
		not provide a means of passing parameters through the URL. Parameters
		can be forwarded successfully only to another AS3 SWF file; an AS1 or
		AS2 SWF file cannot receive the parameters in an accessible form,
		although the AVM1Movie's AS3 loaderInfo.parameters object will be the
		forwarded object.

		For example, consider the following URL:

		`http://yourdomain/users/jdoe/test01/child.swf?foo=bar;`

		The following code uses the LoaderContext.parameters property to
		replicate a parameter passed to this URL:

		```haxe
		import openfl.system.LoaderContext;
		import openfl.display.Loader;

		var l = new Loader();
		var lc = new LoaderContext;
		lc.parameters = { "foo": "bar" };
		l.load(new URLRequest("child.swf"), lc);
		```
		To verify that the parameter passed properly, use the following trace
		statement after you run this code:

		```haxe
		trace(loaderInfo.parameters.foo);
		```

		If the content loaded successfully, this trace prints "bar".
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public var parameters:Dynamic;
	#end

	#if false
	/**
		The parent to which the Loader will attempt to add the loaded content.

		When content is completely loaded, the Loader object normally becomes
		the parent of the content. If `requestedContentParent` is set, the
		object that it specifies becomes the parent, unless a runtime error
		prevents the assignment. This reparenting can also be done after the
		`complete` event without use of this property. However, specifying the
		parent with `LoaderContext.requestedContentParent` eliminates extra
		events.

		`LoaderContext.requestedContentParent` sets the desired parent before
		frame one scripts in the loaded content execute, but after the
		constructor has run. If `requestedContentParent` is null (the
		default), the Loader object becomes the content's parent.

		If the loaded content is an AVM1Movie object, or if an error is thrown
		when `addChild()` is called on the `requestedContentParent` object,
		then the following actions occur:
		* The Loader object becomes the parent of the loaded content.
		* The runtime dispatches an `AsyncErrorEvent`.

		If the requested parent and the loaded content are in different
		security sandboxes, and if the requested parent does not have access
		to the loaded content, then the following actions occur:
		* The Loader becomes the parent of the loaded content.
		* The runtime dispatches a `SecurityErrorEvent`.

		The following code uses `requestedContentParent` to place the loaded
		content into a Sprite object:

		```haxe
		import openfl.system.LoaderContext;
		import openfl.display.Loader;
		import openfl.display.Sprite;

		var lc = new LoaderContext();
		var l = new Loader();
		var s = new Sprite();
		lc.requestedContentParent = s;
		addChild(s);
		l.load(new URLRequest("child.swf"), lc);
		```

		When this code runs, the child SWF file appears on stage. This fact
		confirms that the Sprite object you added to the stage is the parent
		of the loaded child.swf file.
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public var requestedContentParent:DisplayObjectContainer;
	#end

	/**
		Specifies the security domain to use for a `Loader.load()` operation.
		Use this property only when loading a SWF file (not an image).
		The choice of security domain is meaningful only if you are loading a
		SWF file that might come from a different domain (a different server)
		than the loading SWF file. When you load a SWF file from your own
		domain, it is always placed into your security domain. But when you
		load a SWF file from a different domain, you have two options. You can
		allow the loaded SWF file to be placed in its "natural" security
		domain, which is different from that of the loading SWF file; this is
		the default. The other option is to specify that you want to place the
		loaded SWF file placed into the same security domain as the loading
		SWF file, by setting `myLoaderContext.securityDomain` to be equal to
		`SecurityDomain.currentDomain`. This is called _import loading_, and
		it is equivalent, for security purposes, to copying the loaded SWF
		file to your own server and loading it from there. In order for import
		loading to succeed, the loaded SWF file's server must have a policy
		file trusting the domain of the loading SWF file.

		You can pass your own security domain only in
		`LoaderContext.securityDomain`. Attempting to pass any other security
		domain results in a `SecurityError` exception.

		Content in the AIR application security sandbox cannot load content
		from other sandboxes into its SecurityDomain.

		For more information, see the "Security" chapter in the _ActionScript
		3.0 Developer's Guide_.
	**/
	public var securityDomain:SecurityDomain;

	/**
		Creates a new LoaderContext object, with the specified settings. For
		complete details on these settings, see the descriptions of the
		properties of this class.

		@param checkPolicyFile   Specifies whether a check should be made for
								 the existence of a URL policy file before
								 loading the object.
		@param applicationDomain Specifies the ApplicationDomain object to use
								 for a Loader object.
		@param securityDomain    Specifies the SecurityDomain object to use
								 for a Loader object.
								 _Note:_ Content in the air application
								 security sandbox cannot load content from
								 other sandboxes into its SecurityDomain.
	**/
	public function new(checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void
	{
		this.checkPolicyFile = checkPolicyFile;
		this.securityDomain = securityDomain;
		this.applicationDomain = applicationDomain;

		allowCodeImport = true;
		allowLoadBytesCodeExecution = true;
	}
}
#else
typedef LoaderContext = flash.system.LoaderContext;
#end
