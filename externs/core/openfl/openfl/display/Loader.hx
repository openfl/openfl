package openfl.display; #if (display || !flash)


import openfl.events.UncaughtErrorEvents;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;


/**
 * The Loader class is used to load SWF files or image (JPG, PNG, or GIF)
 * files. Use the `load()` method to initiate loading. The loaded
 * display object is added as a child of the Loader object.
 *
 * Use the URLLoader class to load text or binary data.
 *
 * The Loader class overrides the following methods that it inherits,
 * because a Loader object can only have one child display object - the
 * display object that it loads. Calling the following methods throws an
 * exception: `addChild()`, `addChildAt()`,
 * `removeChild()`, `removeChildAt()`, and
 * `setChildIndex()`. To remove a loaded display object, you must
 * remove the _Loader_ object from its parent DisplayObjectContainer
 * child array. 
 *
 * **Note:** The ActionScript 2.0 MovieClipLoader and LoadVars classes
 * are not used in ActionScript 3.0. The Loader and URLLoader classes replace
 * them.
 *
 * When you use the Loader class, consider the Flash Player and Adobe AIR
 * security model: 
 * 
 *  * You can load content from any accessible source. 
 *  * Loading is not allowed if the calling SWF file is in a network
 * sandbox and the file to be loaded is local. 
 *  * If the loaded content is a SWF file written with ActionScript 3.0, it
 * cannot be cross-scripted by a SWF file in another security sandbox unless
 * that cross-scripting arrangement was approved through a call to the
 * `System.allowDomain()` or the
 * `System.allowInsecureDomain()` method in the loaded content
 * file.
 *  * If the loaded content is an AVM1 SWF file(written using ActionScript
 * 1.0 or 2.0), it cannot be cross-scripted by an AVM2 SWF file(written using
 * ActionScript 3.0). However, you can communicate between the two SWF files
 * by using the LocalConnection class.
 *  * If the loaded content is an image, its data cannot be accessed by a
 * SWF file outside of the security sandbox, unless the domain of that SWF
 * file was included in a URL policy file at the origin domain of the
 * image.
 *  * Movie clips in the local-with-file-system sandbox cannot script movie
 * clips in the local-with-networking sandbox, and the reverse is also
 * prevented. 
 *  * You cannot connect to commonly reserved ports. For a complete list of
 * blocked ports, see "Restricting Networking APIs" in the _ActionScript 3.0
 * Developer's Guide_. 
 * 
 * However, in AIR, content in the `application` security
 * sandbox(content installed with the AIR application) are not restricted by
 * these security limitations.
 *
 * For more information related to security, see the Flash Player Developer
 * Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
 *
 * When loading a SWF file from an untrusted source(such as a domain other
 * than that of the Loader object's root SWF file), you may want to define a
 * mask for the Loader object, to prevent the loaded content(which is a child
 * of the Loader object) from drawing to portions of the Stage outside of that
 * mask, as shown in the following code:
 */
extern class Loader extends DisplayObjectContainer {
	
	
	/**
	 * Contains the root display object of the SWF file or image(JPG, PNG, or
	 * GIF) file that was loaded by using the `load()` or
	 * `loadBytes()` methods.
	 * 
	 * @throws SecurityError The loaded SWF file or image file belongs to a
	 *                       security sandbox to which you do not have access.
	 *                       For a loaded SWF file, you can avoid this situation
	 *                       by having the file call the
	 *                       `Security.allowDomain()` method or by
	 *                       having the loading file specify a
	 *                       `loaderContext` parameter with its
	 *                       `securityDomain` property set to
	 *                       `SecurityDomain.currentDomain` when you
	 *                       call the `load()` or
	 *                       `loadBytes()` method.
	 */
	public var content (default, null):DisplayObject;
	
	/**
	 * Returns a LoaderInfo object corresponding to the object being loaded.
	 * LoaderInfo objects are shared between the Loader object and the loaded
	 * content object. The LoaderInfo object supplies loading progress
	 * information and statistics about the loaded file.
	 *
	 * Events related to the load are dispatched by the LoaderInfo object
	 * referenced by the `contentLoaderInfo` property of the Loader
	 * object. The `contentLoaderInfo` property is set to a valid
	 * LoaderInfo object, even before the content is loaded, so that you can add
	 * event listeners to the object prior to the load.
	 *
	 * To detect uncaught errors that happen in a loaded SWF, use the
	 * `Loader.uncaughtErrorEvents` property, not the
	 * `Loader.contentLoaderInfo.uncaughtErrorEvents` property.
	 */
	public var contentLoaderInfo (default, null):LoaderInfo;
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var uncaughtErrorEvents (default, null):UncaughtErrorEvents;
	#end
	
	
	/**
	 * Creates a Loader object that you can use to load files, such as SWF, JPEG,
	 * GIF, or PNG files. Call the `load()` method to load the asset
	 * as a child of the Loader instance. You can then add the Loader object to
	 * the display list(for instance, by using the `addChild()`
	 * method of a DisplayObjectContainer instance). The asset appears on the
	 * Stage as it loads.
	 *
	 * You can also use a Loader instance "offlist," that is without adding it
	 * to a display object container on the display list. In this mode, the
	 * Loader instance might be used to load a SWF file that contains additional
	 * modules of an application. 
	 *
	 * To detect when the SWF file is finished loading, you can use the events
	 * of the LoaderInfo object associated with the
	 * `contentLoaderInfo` property of the Loader object. At that
	 * point, the code in the module SWF file can be executed to initialize and
	 * start the module. In the offlist mode, a Loader instance might also be
	 * used to load a SWF file that contains components or media assets. Again,
	 * you can use the LoaderInfo object event notifications to detect when the
	 * components are finished loading. At that point, the application can start
	 * using the components and media assets in the library of the SWF file by
	 * instantiating the ActionScript 3.0 classes that represent those components
	 * and assets.
	 *
	 * To determine the status of a Loader object, monitor the following
	 * events that the LoaderInfo object associated with the
	 * `contentLoaderInfo` property of the Loader object:
	 *
	 * 
	 *  * The `open` event is dispatched when loading begins.
	 *  * The `ioError` or `securityError` event is
	 * dispatched if the file cannot be loaded or if an error occured during the
	 * load process. 
	 *  * The `progress` event fires continuously while the file is
	 * being loaded.
	 *  * The `complete` event is dispatched when a file completes
	 * downloading, but before the loaded movie clip's methods and properties are
	 * available. 
	 *  * The `init` event is dispatched after the properties and
	 * methods of the loaded SWF file are accessible, so you can begin
	 * manipulating the loaded SWF file. This event is dispatched before the
	 * `complete` handler. In streaming SWF files, the
	 * `init` event can occur significantly earlier than the
	 * `complete` event. For most purposes, use the `init`
	 * handler.
	 * 
	 */
	public function new ();
	
	
	/**
	 * Cancels a `load()` method operation that is currently in
	 * progress for the Loader instance.
	 * 
	 */
	public function close ():Void;
	
	
	/**
	 * Loads a SWF, JPEG, progressive JPEG, unanimated GIF, or PNG file into an
	 * object that is a child of this Loader object. If you load an animated GIF
	 * file, only the first frame is displayed. As the Loader object can contain
	 * only a single child, issuing a subsequent `load()` request
	 * terminates the previous request, if still pending, and commences a new
	 * load.
	 *
	 * **Note**: In AIR 1.5 and Flash Player 10, the maximum size for a
	 * loaded image is 8,191 pixels in width or height, and the total number of
	 * pixels cannot exceed 16,777,215 pixels.(So, if an loaded image is 8,191
	 * pixels wide, it can only be 2,048 pixels high.) In Flash Player 9 and
	 * earlier and AIR 1.1 and earlier, the limitation is 2,880 pixels in height
	 * and 2,880 pixels in width.
	 *
	 * A SWF file or image loaded into a Loader object inherits the position,
	 * rotation, and scale properties of the parent display objects of the Loader
	 * object. 
	 *
	 * Use the `unload()` method to remove movies or images loaded
	 * with this method, or to cancel a load operation that is in progress.
	 *
	 * You can prevent a SWF file from using this method by setting the
	 * `allowNetworking` parameter of the the `object` and
	 * `embed` tags in the HTML page that contains the SWF
	 * content.
	 *
	 * When you use this method, consider the Flash Player security model,
	 * which is described in the Loader class description. 
	 *
	 *  In Flash Player 10 and later, if you use a multipart Content-Type(for
	 * example "multipart/form-data") that contains an upload(indicated by a
	 * "filename" parameter in a "content-disposition" header within the POST
	 * body), the POST operation is subject to the security rules applied to
	 * uploads:
	 *
	 * 
	 *  * The POST operation must be performed in response to a user-initiated
	 * action, such as a mouse click or key press.
	 *  * If the POST operation is cross-domain(the POST target is not on the
	 * same server as the SWF file that is sending the POST request), the target
	 * server must provide a URL policy file that permits cross-domain
	 * access.
	 * 
	 *
	 * Also, for any multipart Content-Type, the syntax must be valid
	 * (according to the RFC2046 standard). If the syntax appears to be invalid,
	 * the POST operation is subject to the security rules applied to
	 * uploads.
	 *
	 * For more information related to security, see the Flash Player
	 * Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
	 * 
	 * @param request The absolute or relative URL of the SWF, JPEG, GIF, or PNG
	 *                file to be loaded. A relative path must be relative to the
	 *                main SWF file. Absolute URLs must include the protocol
	 *                reference, such as http:// or file:///. Filenames cannot
	 *                include disk drive specifications.
	 * @param context A LoaderContext object, which has properties that define
	 *                the following:
	 *                
	 *                 * Whether or not to check for the existence of a policy
	 *                file upon loading the object
	 *                 * The ApplicationDomain for the loaded object
	 *                 * The SecurityDomain for the loaded object
	 *                 * The ImageDecodingPolicy for the loaded image
	 *                object
	 *                
	 *                If the `context` parameter is not specified
	 *                or refers to a null object, the loaded content remains in
	 *                its own security domain.
	 *
	 *                For complete details, see the description of the
	 *                properties in the [LoaderContext](../system/LoaderContext.html)
	 *                class.
	 * @throws IOError               The `digest` property of the
	 *                               `request` object is not
	 *                               `null`. You should only set the
	 *                               `digest` property of a URLRequest
	 *                               object when calling the
	 *                               `URLLoader.load()` method when
	 *                               loading a SWZ file(an Adobe platform
	 *                               component).
	 * @throws IllegalOperationError If the `requestedContentParent`
	 *                               property of the `context`
	 *                               parameter is a `Loader`.
	 * @throws IllegalOperationError If the `LoaderContext.parameters`
	 *                               parameter is set to non-null and has some
	 *                               values which are not Strings.
	 * @throws SecurityError         The value of
	 *                               `LoaderContext.securityDomain`
	 *                               must be either `null` or
	 *                               `SecurityDomain.currentDomain`.
	 *                               This reflects the fact that you can only
	 *                               place the loaded media in its natural
	 *                               security sandbox or your own(the latter
	 *                               requires a policy file).
	 * @throws SecurityError         Local SWF files may not set
	 *                               LoaderContext.securityDomain to anything
	 *                               other than `null`. It is not
	 *                               permitted to import non-local media into a
	 *                               local sandbox, or to place other local media
	 *                               in anything other than its natural sandbox.
	 * @throws SecurityError         You cannot connect to commonly reserved
	 *                               ports. For a complete list of blocked ports,
	 *                               see "Restricting Networking APIs" in the
	 *                               _ActionScript 3.0 Developer's Guide_.
	 * @throws SecurityError         If the `applicationDomain` or
	 *                               `securityDomain` properties of
	 *                               the `context` parameter are from
	 *                               a disallowed domain.
	 * @throws SecurityError         If a local SWF file is attempting to use the
	 *                               `securityDomain` property of the
	 *                               `context` parameter.
	 * @event asyncError    Dispatched by the `contentLoaderInfo`
	 *                      object if the
	 *                      `LoaderContext.requestedContentParent`
	 *                      property has been specified and it is not possible to
	 *                      add the loaded content as a child to the specified
	 *                      DisplayObjectContainer. This could happen if the
	 *                      loaded content is a
	 *                      `openfl.display.AVM1Movie` or if the
	 *                      `addChild()` call to the
	 *                      requestedContentParent throws an error.
	 * @event complete      Dispatched by the `contentLoaderInfo`
	 *                      object when the file has completed loading. The
	 *                      `complete` event is always dispatched
	 *                      after the `init` event.
	 * @event httpStatus    Dispatched by the `contentLoaderInfo`
	 *                      object when a network request is made over HTTP and
	 *                      Flash Player can detect the HTTP status code.
	 * @event init          Dispatched by the `contentLoaderInfo`
	 *                      object when the properties and methods of the loaded
	 *                      SWF file are accessible. The `init` event
	 *                      always precedes the `complete` event.
	 * @event ioError       Dispatched by the `contentLoaderInfo`
	 *                      object when an input or output error occurs that
	 *                      causes a load operation to fail.
	 * @event open          Dispatched by the `contentLoaderInfo`
	 *                      object when the loading operation starts.
	 * @event progress      Dispatched by the `contentLoaderInfo`
	 *                      object as data is received while load operation
	 *                      progresses.
	 * @event securityError Dispatched by the `contentLoaderInfo`
	 *                      object if a SWF file in the local-with-filesystem
	 *                      sandbox attempts to load content in the
	 *                      local-with-networking sandbox, or vice versa.
	 * @event securityError Dispatched by the `contentLoaderInfo`
	 *                      object if the
	 *                      `LoaderContext.requestedContentParent`
	 *                      property has been specified and the security sandbox
	 *                      of the
	 *                      `LoaderContext.requestedContentParent`
	 *                      does not have access to the loaded SWF.
	 * @event unload        Dispatched by the `contentLoaderInfo`
	 *                      object when a loaded object is removed.
	 */
	public function load (request:URLRequest, context:LoaderContext = null):Void;
	
	
	/**
	 * Loads from binary data stored in a ByteArray object.
	 *
	 * The `loadBytes()` method is asynchronous. You must wait for
	 * the "init" event before accessing the properties of a loaded object.
	 *
	 * When you use this method, consider the Flash Player security model,
	 * which is described in the Loader class description. 
	 * 
	 * @param bytes   A ByteArray object. The contents of the ByteArray can be
	 *                any of the file formats supported by the Loader class: SWF,
	 *                GIF, JPEG, or PNG.
	 * @param context A LoaderContext object. Only the
	 *                `applicationDomain` property of the
	 *                LoaderContext object applies; the
	 *                `checkPolicyFile` and
	 *                `securityDomain` properties of the LoaderContext
	 *                object do not apply.
	 *
	 *                If the `context` parameter is not specified
	 *                or refers to a null object, the content is loaded into the
	 *                current security domain -  a process referred to as "import
	 *                loading" in Flash Player security documentation.
	 *                Specifically, if the loading SWF file trusts the remote SWF
	 *                by incorporating the remote SWF into its code, then the
	 *                loading SWF can import it directly into its own security
	 *                domain.
	 *
	 *                For more information related to security, see the Flash
	 *                Player Developer Center Topic: [Security](http://www.adobe.com/go/devnet_security_en).
	 * @throws ArgumentError         If the `length` property of the
	 *                               ByteArray object is not greater than 0.
	 * @throws IllegalOperationError If the `checkPolicyFile` or
	 *                               `securityDomain` property of the
	 *                               `context` parameter are non-null.
	 * @throws IllegalOperationError If the `requestedContentParent`
	 *                               property of the `context`
	 *                               parameter is a `Loader`.
	 * @throws IllegalOperationError If the `LoaderContext.parameters`
	 *                               parameter is set to non-null and has some
	 *                               values which are not Strings.
	 * @throws SecurityError         If the provided
	 *                               `applicationDomain` property of
	 *                               the `context` property is from a
	 *                               disallowed domain.
	 * @throws SecurityError         You cannot connect to commonly reserved
	 *                               ports. For a complete list of blocked ports,
	 *                               see "Restricting Networking APIs" in the
	 *                               _ActionScript 3.0 Developer's Guide_.
	 * @event asyncError    Dispatched by the `contentLoaderInfo`
	 *                      object if the
	 *                      `LoaderContext.requestedContentParent`
	 *                      property has been specified and it is not possible to
	 *                      add the loaded content as a child to the specified
	 *                      DisplayObjectContainer. This could happen if the
	 *                      loaded content is a
	 *                      `openfl.display.AVM1Movie` or if the
	 *                      `addChild()` call to the
	 *                      requestedContentParent throws an error.
	 * @event complete      Dispatched by the `contentLoaderInfo`
	 *                      object when the operation is complete. The
	 *                      `complete` event is always dispatched
	 *                      after the `init` event.
	 * @event init          Dispatched by the `contentLoaderInfo`
	 *                      object when the properties and methods of the loaded
	 *                      data are accessible. The `init` event
	 *                      always precedes the `complete` event.
	 * @event ioError       Dispatched by the `contentLoaderInfo`
	 *                      object when the runtime cannot parse the data in the
	 *                      byte array.
	 * @event open          Dispatched by the `contentLoaderInfo`
	 *                      object when the operation starts.
	 * @event progress      Dispatched by the `contentLoaderInfo`
	 *                      object as data is transfered in memory.
	 * @event securityError Dispatched by the `contentLoaderInfo`
	 *                      object if the
	 *                      `LoaderContext.requestedContentParent`
	 *                      property has been specified and the security sandbox
	 *                      of the
	 *                      `LoaderContext.requestedContentParent`
	 *                      does not have access to the loaded SWF.
	 * @event unload        Dispatched by the `contentLoaderInfo`
	 *                      object when a loaded object is removed.
	 */
	public function loadBytes (buffer:ByteArray, context:LoaderContext = null):Void;
	
	
	/**
	 * Removes a child of this Loader object that was loaded by using the
	 * `load()` method. The `property` of the associated
	 * LoaderInfo object is reset to `null`. The child is not
	 * necessarily destroyed because other objects might have references to it;
	 * however, it is no longer a child of the Loader object.
	 *
	 * As a best practice, before you unload a child SWF file, you should
	 * explicitly close any streams in the child SWF file's objects, such as
	 * LocalConnection, NetConnection, NetStream, and Sound objects. Otherwise,
	 * audio in the child SWF file might continue to play, even though the child
	 * SWF file was unloaded. To close streams in the child SWF file, add an
	 * event listener to the child that listens for the `unload`
	 * event. When the parent calls `Loader.unload()`, the
	 * `unload` event is dispatched to the child. The following code
	 * shows how you might do this:
	 *
	 * ```
	 * function closeAllStreams(evt:Event) {
	 *     myNetStream.close();
	 *     mySound.close();
	 *     myNetConnection.close();
	 *     myLocalConnection.close();
	 * }
	 * myMovieClip.loaderInfo.addEventListener(Event.UNLOAD,
	 * closeAllStreams);
	 * ```
	 */
	public function unload ():Void;
	
	
	/**
	 * Attempts to unload child SWF file contents and stops the execution of
	 * commands from loaded SWF files. This method attempts to unload SWF files
	 * that were loaded using `Loader.load()` or
	 * `Loader.loadBytes()` by removing references to EventDispatcher,
	 * NetConnection, Timer, Sound, or Video objects of the child SWF file. As a
	 * result, the following occurs for the child SWF file and the child SWF
	 * file's display list:
	 * 
	 *  * Sounds are stopped.
	 *  * Stage event listeners are removed.
	 *  * Event listeners for `enterFrame`,
	 * `frameConstructed`, `exitFrame`,
	 * `activate` and `deactivate` are removed.
	 *  * Timers are stopped.
	 *  * Camera and Microphone instances are detached
	 *  * Movie clips are stopped.
	 * 
	 * 
	 * @param gc Provides a hint to the garbage collector to run on the child SWF
	 *           objects(`true`) or not(`false`). If you
	 *           are unloading many objects asynchronously, setting the
	 *           `gc` paramter to `false` might improve
	 *           application performance. However, if the parameter is set to
	 *           `false`, media and display objects of the child SWF
	 *           file might persist in memory after running the
	 *           `unloadAndStop()` command.
	 */
	public function unloadAndStop (gc:Bool = true):Void;
	
	
}


#else
typedef Loader = flash.display.Loader;
#end