package openfl.net; #if !flash #if !lime_legacy


import haxe.io.Bytes;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.net.SharedObjectFlushStatus;
import openfl.Lib;

#if js
import js.html.Storage;
import js.Browser;
#end


/**
 * The SharedObject class is used to read and store limited amounts of data on
 * a user's computer or on a server. Shared objects offer real-time data
 * sharing between multiple client SWF files and objects that are persistent
 * on the local computer or remote server. Local shared objects are similar to
 * browser cookies and remote shared objects are similar to real-time data
 * transfer devices. To use remote shared objects, you need Adobe Flash Media
 * Server.
 *
 * <p>Use shared objects to do the following:</p>
 *
 * <ul>
 *   <li><b>Maintain local persistence</b>. This is the simplest way to use a
 * shared object, and does not require Flash Media Server. For example, you
 * can call <code>SharedObject.getLocal()</code> to create a shared object in
 * an application, such as a calculator with memory. When the user closes the
 * calculator, Flash Player saves the last value in a shared object on the
 * user's computer. The next time the calculator is run, it contains the
 * values it had previously. Alternatively, if you set the shared object's
 * properties to <code>null</code> before the calculator application is
 * closed, the next time the application runs, it opens without any values.
 * Another example of maintaining local persistence is tracking user
 * preferences or other data for a complex website, such as a record of which
 * articles a user read on a news site. Tracking this information allows you
 * to display articles that have already been read differently from new,
 * unread articles. Storing this information on the user's computer reduces
 * server load.</li>
 *   <li><b>Store and share data on Flash Media Server</b>. A shared object
 * can store data on the server for other clients to retrieve. For example,
 * call <code>SharedObject.getRemote()</code> to create a remote shared
 * object, such as a phone list, that is persistent on the server. Whenever a
 * client makes changes to the shared object, the revised data is available to
 * all clients currently connected to the object or who later connect to it.
 * If the object is also persistent locally, and a client changes data while
 * not connected to the server, the data is copied to the remote shared object
 * the next time the client connects to the object.</li>
 *   <li><b>Share data in real time</b>. A shared object can share data among
 * multiple clients in real time. For example, you can open a remote shared
 * object that stores a list of users connected to a chat room that is visible
 * to all clients connected to the object. When a user enters or leaves the
 * chat room, the object is updated and all clients that are connected to the
 * object see the revised list of chat room users.</li>
 * </ul>
 *
 * <p> To create a local shared object, call
 * <code>SharedObject.getLocal()</code>. To create a remote shared object,
 * call <code>SharedObject.getRemote()</code>.</p>
 *
 * <p> When an application closes, shared objects are <i>flushed</i>, or
 * written to a disk. You can also call the <code>flush()</code> method to
 * explicitly write data to a disk.</p>
 *
 * <p><b>Local disk space considerations.</b> Local shared objects have some
 * limitations that are important to consider as you design your application.
 * Sometimes SWF files may not be allowed to write local shared objects, and
 * sometimes the data stored in local shared objects can be deleted without
 * your knowledge. Flash Player users can manage the disk space that is
 * available to individual domains or to all domains. When users decrease the
 * amount of disk space available, some local shared objects may be deleted.
 * Flash Player users also have privacy controls that can prevent third-party
 * domains(domains other than the domain in the current browser address bar)
 * from reading or writing local shared objects.</p>
 *
 * <p><b>Note</b>: SWF files that are stored and run on a local computer, not
 * from a remote server, can always write third-party shared objects to disk.
 * For more information about third-party shared objects, see the <a
 * href="http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager03.html"
 * scope="external">Global Storage Settings panel</a> in Flash Player
 * Help.</p>
 *
 * <p>It's a good idea to check for failures related to the amount of disk
 * space and to user privacy controls. Perform these checks when you call
 * <code>getLocal()</code> and <code>flush()</code>:
 * <ul>
 *   <li><code>SharedObject.getLocal()</code>  -  Flash Player throws an
 * exception when a call to this method fails, such as when the user has
 * disabled third-party shared objects and the domain of your SWF file does
 * not match the domain in the browser address bar.</li>
 *   <li><code>SharedObject.flush()</code>  -  Flash Player throws an
 * exception when a call to this method fails. It returns
 * <code>SharedObjectFlushStatus.FLUSHED</code> when it succeeds. It returns
 * <code>SharedObjectFlushStatus.PENDING</code> when additional storage space
 * is needed. Flash Player prompts the user to allow an increase in storage
 * space for locally saved information. Thereafter, the <code>netStatus</code>
 * event is dispatched with an information object indicating whether the flush
 * failed or succeeded.</li>
 * </ul>
 * </p>
 *
 * <p>If your SWF file attempts to create or modify local shared objects, make
 * sure that your SWF file is at least 215 pixels wide and at least 138 pixels
 * high(the minimum dimensions for displaying the dialog box that prompts
 * users to increase their local shared object storage limit). If your SWF
 * file is smaller than these dimensions and an increase in the storage limit
 * is required, <code>SharedObject.flush()</code> fails, returning
 * <code>SharedObjectFlushedStatus.PENDING</code> and dispatching the
 * <code>netStatus</code> event.</p>
 *
 * <p> <b>Remote shared objects.</b> With Flash Media Server, you can create
 * and use remote shared objects, that are shared in real-time by all clients
 * connected to your application. When one client changes a property of a
 * remote shared object, the property is changed for all connected clients.
 * You can use remote shared objects to synchronize clients, for example,
 * users in a multi-player game. </p>
 *
 * <p> Each remote shared object has a <code>data</code> property which is an
 * Object with properties that store data. Call <code>setProperty()</code> to
 * change an property of the data object. The server updates the properties,
 * dispatches a <code>sync</code> event, and sends the properties back to the
 * connected clients. </p>
 *
 * <p> You can choose to make remote shared objects persistent on the client,
 * the server, or both. By default, Flash Player saves locally persistent
 * remote shared objects up to 100K in size. When you try to save a larger
 * object, Flash Player displays the Local Storage dialog box, which lets the
 * user allow or deny local storage for the shared object. Make sure your
 * Stage size is at least 215 by 138 pixels; this is the minimum size Flash
 * requires to display the dialog box. </p>
 *
 * <p> If the user selects Allow, the server saves the shared object and
 * dispatches a <code>netStatus</code> event with a <code>code</code> property
 * of <code>SharedObject.Flush.Success</code>. If the user select Deny, the
 * server does not save the shared object and dispatches a
 * <code>netStatus</code> event with a <code>code</code> property of
 * <code>SharedObject.Flush.Failed</code>. </p>
 * 
 * @event asyncError Dispatched when an exception is thrown asynchronously  - 
 *                   that is, from native asynchronous code.
 * @event netStatus  Dispatched when a SharedObject instance is reporting its
 *                   status or error condition. The <code>netStatus</code>
 *                   event contains an <code>info</code> property, which is an
 *                   information object that contains specific information
 *                   about the event, such as whether a connection attempt
 *                   succeeded or whether the shared object was successfully
 *                   written to the local disk.
 * @event sync       Dispatched when a remote shared object has been updated
 *                   by the server.
 */
class SharedObject extends EventDispatcher {
	
	
	/**
	 * The collection of attributes assigned to the <code>data</code> property of
	 * the object; these attributes can be shared and stored. Each attribute can
	 * be an object of any ActionScript or JavaScript type  -  Array, Number,
	 * Boolean, ByteArray, XML, and so on. For example, the following lines
	 * assign values to various aspects of a shared object:
	 *
	 * <p> For remote shared objects used with a server, all attributes of the
	 * <code>data</code> property are available to all clients connected to the
	 * shared object, and all attributes are saved if the object is persistent.
	 * If one client changes the value of an attribute, all clients now see the
	 * new value. </p>
	 */
	public var data (default, null):Dynamic;
	
	/**
	 * The current size of the shared object, in bytes.
	 *
	 * <p>Flash calculates the size of a shared object by stepping through all of
	 * its data properties; the more data properties the object has, the longer
	 * it takes to estimate its size. Estimating object size can take significant
	 * processing time, so you may want to avoid using this method unless you
	 * have a specific need for it.</p>
	 */
	public var size (get, never):Int;
	
	@:noCompletion private var __key:String;
	

	private function new () {
		
		super ();
		
	}
	
	
	/**
	 * For local shared objects, purges all of the data and deletes the shared
	 * object from the disk. The reference to the shared object is still active,
	 * but its data properties are deleted.
	 *
	 * <p> For remote shared objects used with Flash Media Server,
	 * <code>clear()</code> disconnects the object and purges all of the data. If
	 * the shared object is locally persistent, this method also deletes the
	 * shared object from the disk. The reference to the shared object is still
	 * active, but its data properties are deleted. </p>
	 * 
	 */
	public function clear ():Void {
		
		data = { };
		
		#if js
		try {
			
			__getLocalStorage ().removeItem (__key);
			
		} catch (e:Dynamic) {}
		#end
		
		flush ();
		
	}
	
	
	/**
	 * Immediately writes a locally persistent shared object to a local file. If
	 * you don't use this method, Flash Player writes the shared object to a file
	 * when the shared object session ends  -  that is, when the SWF file is
	 * closed, when the shared object is garbage-collected because it no longer
	 * has any references to it, or when you call
	 * <code>SharedObject.clear()</code> or <code>SharedObject.close()</code>.
	 *
	 * <p>If this method returns <code>SharedObjectFlushStatus.PENDING</code>,
	 * Flash Player displays a dialog box asking the user to increase the amount
	 * of disk space available to objects from this domain. To allow space for
	 * the shared object to grow when it is saved in the future, which avoids
	 * return values of <code>PENDING</code>, pass a value for
	 * <code>minDiskSpace</code>. When Flash Player tries to write the file, it
	 * looks for the number of bytes passed to <code>minDiskSpace</code>, instead
	 * of looking for enough space to save the shared object at its current size.
	 * </p>
	 *
	 * <p>For example, if you expect a shared object to grow to a maximum size of
	 * 500 bytes, even though it might start out much smaller, pass 500 for
	 * <code>minDiskSpace</code>. If Flash asks the user to allot disk space for
	 * the shared object, it asks for 500 bytes. After the user allots the
	 * requested amount of space, Flash won't have to ask for more space on
	 * future attempts to flush the object(as long as its size doesn't exceed
	 * 500 bytes). </p>
	 *
	 * <p>After the user responds to the dialog box, this method is called again.
	 * A <code>netStatus</code> event is dispatched with a <code>code</code>
	 * property of <code>SharedObject.Flush.Success</code> or
	 * <code>SharedObject.Flush.Failed</code>. </p>
	 * 
	 * @param minDiskSpace The minimum disk space, in bytes, that must be
	 *                     allotted for this object.
	 * @return Either of the following values:
	 *         <ul>
	 *           <li><code>SharedObjectFlushStatus.PENDING</code>: The user has
	 *         permitted local information storage for objects from this domain,
	 *         but the amount of space allotted is not sufficient to store the
	 *         object. Flash Player prompts the user to allow more space. To
	 *         allow space for the shared object to grow when it is saved, thus
	 *         avoiding a <code>SharedObjectFlushStatus.PENDING</code> return
	 *         value, pass a value for <code>minDiskSpace</code>. </li>
	 *           <li><code>SharedObjectFlushStatus.FLUSHED</code>: The shared
	 *         object has been successfully written to a file on the local
	 *         disk.</li>
	 *         </ul>
	 * @throws Error Flash Player cannot write the shared object to disk. This
	 *               error might occur if the user has permanently disallowed
	 *               local information storage for objects from this domain.
	 *
	 *               <p><b>Note:</b> Local content can always write shared
	 *               objects from third-party domains(domains other than the
	 *               domain in the current browser address bar) to disk, even if
	 *               writing of third-party shared objects to disk is
	 *               disallowed.</p>
	 */
	public function flush (minDiskSpace:Int = 0):SharedObjectFlushStatus {
		
		#if js
		var data = Serializer.run (data);
		
		try {
			
			__getLocalStorage ().removeItem (__key);
			__getLocalStorage ().setItem (__key, data);
			
		} catch (e:Dynamic) {
			
			// user may have privacy settings which prevent writing
			return SharedObjectFlushStatus.PENDING;
			
		}
		#end
		
		return SharedObjectFlushStatus.FLUSHED;
		
	}
	
	
	/**
	 * Returns a reference to a locally persistent shared object that is only
	 * available to the current client. If the shared object does not already
	 * exist, this method creates one. If any values passed to
	 * <code>getLocal()</code> are invalid or if the call fails, Flash Player
	 * throws an exception.
	 *
	 * <p>The following code shows how you assign the returned shared object
	 * reference to a variable:</p>
	 *
	 * <p><code>var so:SharedObject =
	 * SharedObject.getLocal("savedData");</code></p>
	 *
	 * <p><b>Note:</b> If the user has chosen to never allow local storage for
	 * this domain, the object is not saved locally, even if a value for
	 * <code>localPath</code> is specified. The exception to this rule is local
	 * content. Local content can always write shared objects from third-party
	 * domains(domains other than the domain in the current browser address bar)
	 * to disk, even if writing of third-party shared objects to disk is
	 * disallowed. </p>
	 *
	 * <p>To avoid name conflicts, Flash looks at the location of the SWF file
	 * creating the shared object. For example, if a SWF file at
	 * www.myCompany.com/apps/stockwatcher.swf creates a shared object named
	 * <code>portfolio</code>, that shared object does not conflict with another
	 * object named <code>portfolio</code> that was created by a SWF file at
	 * www.yourCompany.com/photoshoot.swf because the SWF files originate from
	 * different directories. </p>
	 *
	 * <p>Although the <code>localPath</code> parameter is optional, you should
	 * give some thought to its use, especially if other SWF files need to access
	 * the shared object. If the data in the shared object is specific to one SWF
	 * file that will not be moved to another location, then use of the default
	 * value makes sense. If other SWF files need access to the shared object, or
	 * if the SWF file that creates the shared object will later be moved, then
	 * the value of this parameter affects how accessible the shared object will
	 * be. For example, if you create a shared object with <code>localPath</code>
	 * set to the default value of the full path to the SWF file, no other SWF
	 * file can access that shared object. If you later move the original SWF
	 * file to another location, not even that SWF file can access the data
	 * already stored in the shared object.</p>
	 *
	 * <p>To avoid inadvertently restricting access to a shared object, use the
	 * <code>localpath</code> parameter. The most permissive approach is to set
	 * <code>localPath</code> to <code>/</code>(slash), which makes the shared
	 * object available to all SWF files in the domain, but increases the
	 * likelihood of name conflicts with other shared objects in the domain. A
	 * more restrictive approach is to append <code>localPath</code> with folder
	 * names that are in the full path to the SWF file. For example, for a
	 * <code>portfolio</code> shared object created by the SWF file at
	 * www.myCompany.com/apps/stockwatcher.swf, you could set the
	 * <code>localPath</code> parameter to <code>/</code>, <code>/apps</code>, or
	 * <code>/apps/stockwatcher.swf</code>. You must determine which approach
	 * provides optimal flexibility for your application.</p>
	 *
	 * <p>When using this method, consider the following security model:
	 * <ul>
	 *   <li>You cannot access shared objects across sandbox boundaries.</li>
	 *   <li>Users can restrict shared object access by using the Flash Player
	 * Settings dialog box or the Settings Manager. By default, an application
	 * can create shared objects of up 100 KB of data per domain. Administrators
	 * and users can also place restrictions on the ability to write to the file
	 * system.</li>
	 * </ul>
	 * </p>
	 *
	 * <p>Suppose you publish SWF file content to be played back as local files
	 * (either locally installed SWF files or EXE files), and you need to access
	 * a specific shared object from more than one local SWF file. In this
	 * situation, be aware that for local files, two different locations might be
	 * used to store shared objects. The domain that is used depends on the
	 * security permissions granted to the local file that created the shared
	 * object. Local files can have three different levels of permissions:
	 * <ol>
	 *   <li>Access to the local filesystem only.</li>
	 *   <li>Access to the network only.</li>
	 *   <li>Access to both the network and the local filesystem.</li>
	 * </ol>
	 * </p>
	 *
	 * <p>Local files with access to the local filesystem(level 1 or 3) store
	 * their shared objects in one location. Local files without access to the
	 * local filesystem(level 2) store their shared objects in another
	 * location.</p>
	 *
	 * <p>You can prevent a SWF file from using this method by setting the
	 * <code>allowNetworking</code> parameter of the the <code>object</code> and
	 * <code>embed</code> tags in the HTML page that contains the SWF
	 * content.</p>
	 *
	 * <p>For more information, see the Flash Player Developer Center Topic: <a
	 * href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.</p>
	 * 
	 * @param name      The name of the object. The name can include forward
	 *                  slashes(<code>/</code>); for example,
	 *                  <code>work/addresses</code> is a legal name. Spaces are
	 *                  not allowed in a shared object name, nor are the
	 *                  following characters: <pre xml:space="preserve"> ~ % & \
	 *                  ; : " ' , < > ? # </pre>
	 * @param localPath The full or partial path to the SWF file that created the
	 *                  shared object, and that determines where the shared
	 *                  object will be stored locally. If you do not specify this
	 *                  parameter, the full path is used.
	 * @param secure    Determines whether access to this shared object is
	 *                  restricted to SWF files that are delivered over an HTTPS
	 *                  connection. If your SWF file is delivered over HTTPS,
	 *                  this parameter's value has the following effects:
	 *                  <ul>
	 *                    <li>If this parameter is set to <code>true</code>,
	 *                  Flash Player creates a new secure shared object or gets a
	 *                  reference to an existing secure shared object. This
	 *                  secure shared object can be read from or written to only
	 *                  by SWF files delivered over HTTPS that call
	 *                  <code>SharedObject.getLocal()</code> with the
	 *                  <code>secure</code> parameter set to
	 *                  <code>true</code>.</li>
	 *                    <li>If this parameter is set to <code>false</code>,
	 *                  Flash Player creates a new shared object or gets a
	 *                  reference to an existing shared object that can be read
	 *                  from or written to by SWF files delivered over non-HTTPS
	 *                  connections.</li>
	 *                  </ul>
	 *
	 *                  <p>If your SWF file is delivered over a non-HTTPS
	 *                  connection and you try to set this parameter to
	 *                  <code>true</code>, the creation of a new shared object
	 *                 (or the access of a previously created secure shared
	 *                  object) fails and <code>null</code> is returned.
	 *                  Regardless of the value of this parameter, the created
	 *                  shared objects count toward the total amount of disk
	 *                  space allowed for a domain.</p>
	 *
	 *                  <p>The following diagram shows the use of the
	 *                  <code>secure</code> parameter:</p>
	 * @return A reference to a shared object that is persistent locally and is
	 *         available only to the current client. If Flash Player can't create
	 *         or find the shared object(for example, if <code>localPath</code>
	 *         was specified but no such directory exists), this method throws an
	 *         exception.
	 * @throws Error Flash Player cannot create the shared object for whatever
	 *               reason. This error might occur is if persistent shared
	 *               object creation and storage by third-party Flash content is
	 *               prohibited(does not apply to local content). Users can
	 *               prohibit third-party persistent shared objects on the Global
	 *               Storage Settings panel of the Settings Manager, located at
	 *               <a
	 *               href="http://www.adobe.com/support/documentation/en/flashplayer/help/settings_manager03.html"
	 *               scope="external">http://www.adobe.com/support/documentation/en/flashplayer/help/settings_manager03.html</a>.
	 */
	public static function getLocal (name:String, localPath:String = null, secure:Bool = false /* note: unsupported */) {
		
		#if js
		if (localPath == null) {
			
			localPath = Browser.window.location.href;
			
		}
		#end
		
		var so = new SharedObject ();
		so.__key = localPath + ":" + name;
		var rawData = null;
		
		#if js
		try {
			
			// user may have privacy settings which prevent reading
			rawData = __getLocalStorage ().getItem (so.__key);
			
		} catch (e:Dynamic) { }
		#end
		
		so.data = { };
		
		if (rawData != null && rawData != "") {
			
			var unserializer = new Unserializer (rawData);
			unserializer.setResolver (cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass } );
			so.data = unserializer.unserialize ();
			
		}
		
		if (so.data == null) {
			
			so.data = { };
			
		}
		
		return so;
		
	}
	
	
	#if js
	@:noCompletion private static function __getLocalStorage ():Storage {
		
		var res = Browser.getLocalStorage ();
		if (res == null) throw new Error ("SharedObject not supported");
		return res;
		
	}
	#end
	
	
	@:noCompletion private static function resolveClass (name:String):Class <Dynamic> {
		
		if (name != null) {
			
			return Type.resolveClass (StringTools.replace (StringTools.replace (name, "jeash.", "flash."), "browser.", "flash."));
			
		}
		
		return null;
		
	}
	
	
	public function setProperty (propertyName:String, ?value:Dynamic):Void {
		
		if (data != null) {
			
			Reflect.setField (data, propertyName, value);
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_size ():Int {
		
		var d = Serializer.run (data);
		return Bytes.ofString (d).length;
		
	}
	
	
}


#else
typedef SharedObject = openfl._v2.net.SharedObject;
#end
#else
typedef SharedObject = flash.net.SharedObject;
#end