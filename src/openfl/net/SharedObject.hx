package openfl.net;

#if !flash
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
#if lime
import lime.app.Application;
import lime.system.System;
#end
#if (js && html5)
import js.Browser;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
	The SharedObject class is used to read and store limited amounts of data on
	a user's computer or on a server. Shared objects offer real-time data
	sharing between multiple client SWF files and objects that are persistent
	on the local computer or remote server. Local shared objects are similar to
	browser cookies and remote shared objects are similar to real-time data
	transfer devices. To use remote shared objects, you need Adobe Flash Media
	Server.

	Use shared objects to do the following:


	* **Maintain local persistence**. This is the simplest way to use a
	shared object, and does not require Flash Media Server. For example, you
	can call `SharedObject.getLocal()` to create a shared object in
	an application, such as a calculator with memory. When the user closes the
	calculator, Flash Player saves the last value in a shared object on the
	user's computer. The next time the calculator is run, it contains the
	values it had previously. Alternatively, if you set the shared object's
	properties to `null` before the calculator application is
	closed, the next time the application runs, it opens without any values.
	Another example of maintaining local persistence is tracking user
	preferences or other data for a complex website, such as a record of which
	articles a user read on a news site. Tracking this information allows you
	to display articles that have already been read differently from new,
	unread articles. Storing this information on the user's computer reduces
	server load.
	* **Store and share data on Flash Media Server**. A shared object
	can store data on the server for other clients to retrieve. For example,
	call `SharedObject.getRemote()` to create a remote shared
	object, such as a phone list, that is persistent on the server. Whenever a
	client makes changes to the shared object, the revised data is available to
	all clients currently connected to the object or who later connect to it.
	If the object is also persistent locally, and a client changes data while
	not connected to the server, the data is copied to the remote shared object
	the next time the client connects to the object.
	* **Share data in real time**. A shared object can share data among
	multiple clients in real time. For example, you can open a remote shared
	object that stores a list of users connected to a chat room that is visible
	to all clients connected to the object. When a user enters or leaves the
	chat room, the object is updated and all clients that are connected to the
	object see the revised list of chat room users.


	 To create a local shared object, call
	`SharedObject.getLocal()`. To create a remote shared object,
	call `SharedObject.getRemote()`.

	 When an application closes, shared objects are _flushed_, or
	written to a disk. You can also call the `flush()` method to
	explicitly write data to a disk.

	**Local disk space considerations.** Local shared objects have some
	limitations that are important to consider as you design your application.
	Sometimes SWF files may not be allowed to write local shared objects, and
	sometimes the data stored in local shared objects can be deleted without
	your knowledge. Flash Player users can manage the disk space that is
	available to individual domains or to all domains. When users decrease the
	amount of disk space available, some local shared objects may be deleted.
	Flash Player users also have privacy controls that can prevent third-party
	domains(domains other than the domain in the current browser address bar)
	from reading or writing local shared objects.

	**Note**: SWF files that are stored and run on a local computer, not
	from a remote server, can always write third-party shared objects to disk.
	For more information about third-party shared objects, see the
	[Global Storage Settings panel](http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager03.html)
	in Flash Player Help.

	It's a good idea to check for failures related to the amount of disk
	space and to user privacy controls. Perform these checks when you call
	`getLocal()` and `flush()`:

	* `SharedObject.getLocal()`  -  Flash Player throws an
	exception when a call to this method fails, such as when the user has
	disabled third-party shared objects and the domain of your SWF file does
	not match the domain in the browser address bar.
	* `SharedObject.flush()`  -  Flash Player throws an
	exception when a call to this method fails. It returns
	`SharedObjectFlushStatus.FLUSHED` when it succeeds. It returns
	`SharedObjectFlushStatus.PENDING` when additional storage space
	is needed. Flash Player prompts the user to allow an increase in storage
	space for locally saved information. Thereafter, the `netStatus`
	event is dispatched with an information object indicating whether the flush
	failed or succeeded.



	If your SWF file attempts to create or modify local shared objects, make
	sure that your SWF file is at least 215 pixels wide and at least 138 pixels
	high(the minimum dimensions for displaying the dialog box that prompts
	users to increase their local shared object storage limit). If your SWF
	file is smaller than these dimensions and an increase in the storage limit
	is required, `SharedObject.flush()` fails, returning
	`SharedObjectFlushedStatus.PENDING` and dispatching the
	`netStatus` event.

	**Remote shared objects.** With Flash Media Server, you can create
	and use remote shared objects, that are shared in real-time by all clients
	connected to your application. When one client changes a property of a
	remote shared object, the property is changed for all connected clients.
	You can use remote shared objects to synchronize clients, for example,
	users in a multi-player game.

	 Each remote shared object has a `data` property which is an
	Object with properties that store data. Call `setProperty()` to
	change an property of the data object. The server updates the properties,
	dispatches a `sync` event, and sends the properties back to the
	connected clients.

	 You can choose to make remote shared objects persistent on the client,
	the server, or both. By default, Flash Player saves locally persistent
	remote shared objects up to 100K in size. When you try to save a larger
	object, Flash Player displays the Local Storage dialog box, which lets the
	user allow or deny local storage for the shared object. Make sure your
	Stage size is at least 215 by 138 pixels; this is the minimum size Flash
	requires to display the dialog box.

	 If the user selects Allow, the server saves the shared object and
	dispatches a `netStatus` event with a `code` property
	of `SharedObject.Flush.Success`. If the user select Deny, the
	server does not save the shared object and dispatches a
	`netStatus` event with a `code` property of
	`SharedObject.Flush.Failed`.

	@event asyncError Dispatched when an exception is thrown asynchronously  -
					  that is, from native asynchronous code.
	@event netStatus  Dispatched when a SharedObject instance is reporting its
					  status or error condition. The `netStatus`
					  event contains an `info` property, which is an
					  information object that contains specific information
					  about the event, such as whether a connection attempt
					  succeeded or whether the shared object was successfully
					  written to the local disk.
	@event sync       Dispatched when a remote shared object has been updated
					  by the server.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SharedObject extends EventDispatcher
{
	/**
		The default object encoding (AMF version) for all local shared objects created in
		the SWF file. When local shared objects are written to disk, the
		`SharedObject.defaultObjectEncoding` property indicates which Action Message
		Format version should be used: the ActionScript 3.0 format (AMF3) or the
		ActionScript 1.0 or 2.0 format (AMF0).

		For more information about object encoding, including the difference between
		encoding in local and remote shared objects, see the description of the
		`objectEncoding` property.

		The default value of `SharedObject.defaultObjectEncoding` is set to use the
		ActionScript 3.0 format, AMF3. If you need to write local shared objects that
		ActionScript 2.0 or 1.0 SWF files can read, set
		`SharedObject.defaultObjectEncoding` to use the ActionScript 1.0 or ActionScript
		2.0 format, `openfl.net.ObjectEncoding.AMF0`, at the beginning of your script,
		before you create any local shared objects. All local shared objects created
		thereafter will use AMF0 encoding and can interact with older content. You cannot
		change the `objectEncoding` value of existing local shared objects by setting
		`SharedObject.defaultObjectEncoding` after the local shared objects have been
		created.

		To set the object encoding on a per-object basis, rather than for all shared
		objects created by the SWF file, set the objectEncoding property of the local
		shared object instead.
	**/
	public static var defaultObjectEncoding:ObjectEncoding = ObjectEncoding.DEFAULT;

	// @:noCompletion @:dox(hide) @:require(flash11_7) public static var preventBackup:Bool;

	/**
		Indicates the object on which callback methods are invoked. The
		default object is `this`. You can set the client property to another
		object, and callback methods will be invoked on that other object.

		@throws TypeError The `client` property must be set to a non-null
						  object.
	**/
	public var client:Dynamic;

	/**
		The collection of attributes assigned to the `data` property of
		the object; these attributes can be shared and stored. Each attribute can
		be an object of any ActionScript or JavaScript type  -  Array, Number,
		Boolean, ByteArray, XML, and so on. For example, the following lines
		assign values to various aspects of a shared object:

		 For remote shared objects used with a server, all attributes of the
		`data` property are available to all clients connected to the
		shared object, and all attributes are saved if the object is persistent.
		If one client changes the value of an attribute, all clients now see the
		new value.
	**/
	public var data(default, null):Dynamic;

	/**
		Specifies the number of times per second that a client's changes to a
		shared object are sent to the server.
		Use this method when you want to control the amount of traffic between
		the client and the server. For example, if the connection between the
		client and server is relatively slow, you may want to set `fps` to a
		relatively low value. Conversely, if the client is connected to a
		multiuser application in which timing is important, you may want to
		set `fps` to a relatively high value.

		Setting `fps` will trigger a `sync` event and update all changes to
		the server. If you only want to update the server manually, set `fps`
		to 0.

		Changes are not sent to the server until the `sync` event has been
		dispatched. That is, if the response time from the server is slow,
		updates may be sent to the server less frequently than the value
		specified in this property.
	**/
	public var fps(null, default):Float;

	/**
		The object encoding (AMF version) for this shared object. When a local
		shared object is written to disk, the `objectEncoding` property
		indicates which Action Message Format version should be used: the
		ActionScript 3.0 format (AMF3) or the ActionScript 1.0 or 2.0 format
		(AMF0).
		Object encoding is handled differently depending if the shared object
		is local or remote.

		* **Local shared objects**. You can get or set the value of the
		`objectEncoding` property for local shared objects. The value of
		`objectEncoding` affects what formatting is used for _writing_ this
		local shared object. If this local shared object must be readable by
		ActionScript 2.0 or 1.0 SWF files, set `objectEncoding` to
		`ObjectEncoding.AMF0`. Even if object encoding is set to write AMF3,
		Flash Player can still read AMF0 local shared objects. That is, if you
		use the default value of this property, `ObjectEncoding.AMF3`, your
		SWF file can still read shared objects created by ActionScript 2.0 or
		1.0 SWF files.
		* **Remote shared objects**. When connected to the server, a remote
		shared object inherits its `objectEncoding` setting from the
		associated NetConnection instance (the instance used to connect to the
		remote shared object). When not connected to the server, a remote
		shared object inherits the `defaultObjectEncoding` setting from the
		associated NetConnection instance. Because the value of a remote
		shared object's `objectEncoding` property is determined by the
		NetConnection instance, this property is read-only for remote shared
		objects.

		@throws ReferenceError You attempted to set the value of the
							   `objectEncoding` property on a remote shared
							   object. This property is read-only for remote
							   shared objects because its value is determined
							   by the associated NetConnection instance.
	**/
	public var objectEncoding:ObjectEncoding;

	/**
		The current size of the shared object, in bytes.

		Flash calculates the size of a shared object by stepping through all of
		its data properties; the more data properties the object has, the longer
		it takes to estimate its size. Estimating object size can take significant
		processing time, so you may want to avoid using this method unless you
		have a specific need for it.
	**/
	public var size(get, never):Int;

	@:noCompletion private static var __sharedObjects:Map<String, SharedObject>;

	@:noCompletion private var __localPath:String;
	@:noCompletion private var __name:String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped global.Object.defineProperty(SharedObject.prototype, "size", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_size (); }")
		});
	}
	#end

	@:noCompletion private function new()
	{
		super();

		client = this;
		objectEncoding = defaultObjectEncoding;
	}

	/**
		For local shared objects, purges all of the data and deletes the shared
		object from the disk. The reference to the shared object is still active,
		but its data properties are deleted.

		 For remote shared objects used with Flash Media Server,
		`clear()` disconnects the object and purges all of the data. If
		the shared object is locally persistent, this method also deletes the
		shared object from the disk. The reference to the shared object is still
		active, but its data properties are deleted.

	**/
	public function clear():Void
	{
		data = {};

		try
		{
			#if (js && html5)
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(__localPath + ":" + __name);
			}
			#else
			var path = __getPath(__localPath, __name);

			if (FileSystem.exists(path))
			{
				FileSystem.deleteFile(path);
			}
			#end
		}
		catch (e:Dynamic) {}
	}

	/**
		Closes the connection between a remote shared object and the server.
		If a remote shared object is locally persistent, the user can make
		changes to the local copy of the object after this method is called.
		Any changes made to the local object are sent to the server the next
		time the user connects to the remote shared object.

	**/
	public function close():Void {}

	#if !openfl_strict
	/**
		Connects to a remote shared object on a server through a specified
		NetConnection object. Use this method after calling `getRemote()`.
		When a connection is successful, the `sync` event is dispatched.
		Before attempting to work with a remote shared object, first check for
		any errors using a `try..catch..finally` statement. Then, listen for
		and handle the `sync` event before you make changes to the shared
		object. Any changes made locally — before the `sync` event is
		dispatched — might be lost.

		Call the `connect()` method to connect to a remote shared object, for
		example:

		```as3
		var myRemoteSO:SharedObject = SharedObject.getRemote("mo", myNC.uri, false);
		myRemoteSO.connect(myNC);
		```

		@param myConnection A NetConnection object that uses the Real-Time
							Messaging Protocol (RTMP), such as a NetConnection
							object used to communicate with Flash Media
							Server.
		@param params       A string defining a message to pass to the remote
							shared object on the server. Cannot be used with
							Flash Media Server.
		@throws Error Flash Player could not connect to the specified remote
					  shared object. Verify that the NetConnection instance is
					  valid and connected and that the remote shared object
					  was successfully created on the server.
	**/
	public function connect(myConnection:NetConnection, params:String = null):Void
	{
		openfl.utils._internal.Lib.notImplemented();
	}
	#end

	// @:noCompletion @:dox(hide) public static function deleteAll (url:String):Int;

	/**
		Immediately writes a locally persistent shared object to a local file. If
		you don't use this method, Flash Player writes the shared object to a file
		when the shared object session ends  -  that is, when the SWF file is
		closed, when the shared object is garbage-collected because it no longer
		has any references to it, or when you call
		`SharedObject.clear()` or `SharedObject.close()`.

		If this method returns `SharedObjectFlushStatus.PENDING`,
		Flash Player displays a dialog box asking the user to increase the amount
		of disk space available to objects from this domain. To allow space for
		the shared object to grow when it is saved in the future, which avoids
		return values of `PENDING`, pass a value for
		`minDiskSpace`. When Flash Player tries to write the file, it
		looks for the number of bytes passed to `minDiskSpace`, instead
		of looking for enough space to save the shared object at its current size.


		For example, if you expect a shared object to grow to a maximum size of
		500 bytes, even though it might start out much smaller, pass 500 for
		`minDiskSpace`. If Flash asks the user to allot disk space for
		the shared object, it asks for 500 bytes. After the user allots the
		requested amount of space, Flash won't have to ask for more space on
		future attempts to flush the object(as long as its size doesn't exceed
		500 bytes).

		After the user responds to the dialog box, this method is called again.
		A `netStatus` event is dispatched with a `code`
		property of `SharedObject.Flush.Success` or
		`SharedObject.Flush.Failed`.

		@param minDiskSpace The minimum disk space, in bytes, that must be
							allotted for this object.
		@return Either of the following values:

				 * `SharedObjectFlushStatus.PENDING`: The user has
				permitted local information storage for objects from this domain,
				but the amount of space allotted is not sufficient to store the
				object. Flash Player prompts the user to allow more space. To
				allow space for the shared object to grow when it is saved, thus
				avoiding a `SharedObjectFlushStatus.PENDING` return
				value, pass a value for `minDiskSpace`.
				 * `SharedObjectFlushStatus.FLUSHED`: The shared
				object has been successfully written to a file on the local
				disk.

		@throws Error Flash Player cannot write the shared object to disk. This
					  error might occur if the user has permanently disallowed
					  local information storage for objects from this domain.

					  **Note:** Local content can always write shared
					  objects from third-party domains(domains other than the
					  domain in the current browser address bar) to disk, even if
					  writing of third-party shared objects to disk is
					  disallowed.
	**/
	public function flush(minDiskSpace:Int = 0):SharedObjectFlushStatus
	{
		if (Reflect.fields(data).length == 0)
		{
			return SharedObjectFlushStatus.FLUSHED;
		}

		var encodedData = Serializer.run(data);

		try
		{
			#if (js && html5)
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(__localPath + ":" + __name);
				storage.setItem(__localPath + ":" + __name, encodedData);
			}
			#else
			var path = __getPath(__localPath, __name);
			var directory = Path.directory(path);

			if (!FileSystem.exists(directory))
			{
				__mkdir(directory);
			}

			var output = File.write(path, false);
			output.writeString(encodedData);
			output.close();
			#end
		}
		catch (e:Dynamic)
		{
			return SharedObjectFlushStatus.PENDING;
		}

		return SharedObjectFlushStatus.FLUSHED;
	}

	// @:noCompletion @:dox(hide) public static function getDiskUsage (url:String):Int;

	/**
		Returns a reference to a locally persistent shared object that is only
		available to the current client. If the shared object does not already
		exist, this method creates one. If any values passed to
		`getLocal()` are invalid or if the call fails, Flash Player
		throws an exception.

		The following code shows how you assign the returned shared object
		reference to a variable:

		`var so:SharedObject =
		SharedObject.getLocal("savedData");`

		**Note:** If the user has chosen to never allow local storage for
		this domain, the object is not saved locally, even if a value for
		`localPath` is specified. The exception to this rule is local
		content. Local content can always write shared objects from third-party
		domains(domains other than the domain in the current browser address bar)
		to disk, even if writing of third-party shared objects to disk is
		disallowed.

		To avoid name conflicts, Flash looks at the location of the SWF file
		creating the shared object. For example, if a SWF file at
		www.myCompany.com/apps/stockwatcher.swf creates a shared object named
		`portfolio`, that shared object does not conflict with another
		object named `portfolio` that was created by a SWF file at
		www.yourCompany.com/photoshoot.swf because the SWF files originate from
		different directories.

		Although the `localPath` parameter is optional, you should
		give some thought to its use, especially if other SWF files need to access
		the shared object. If the data in the shared object is specific to one SWF
		file that will not be moved to another location, then use of the default
		value makes sense. If other SWF files need access to the shared object, or
		if the SWF file that creates the shared object will later be moved, then
		the value of this parameter affects how accessible the shared object will
		be. For example, if you create a shared object with `localPath`
		set to the default value of the full path to the SWF file, no other SWF
		file can access that shared object. If you later move the original SWF
		file to another location, not even that SWF file can access the data
		already stored in the shared object.

		To avoid inadvertently restricting access to a shared object, use the
		`localpath` parameter. The most permissive approach is to set
		`localPath` to `/`(slash), which makes the shared
		object available to all SWF files in the domain, but increases the
		likelihood of name conflicts with other shared objects in the domain. A
		more restrictive approach is to append `localPath` with folder
		names that are in the full path to the SWF file. For example, for a
		`portfolio` shared object created by the SWF file at
		www.myCompany.com/apps/stockwatcher.swf, you could set the
		`localPath` parameter to `/`, `/apps`, or
		`/apps/stockwatcher.swf`. You must determine which approach
		provides optimal flexibility for your application.

		When using this method, consider the following security model:

		* You cannot access shared objects across sandbox boundaries.
		* Users can restrict shared object access by using the Flash Player
		Settings dialog box or the Settings Manager. By default, an application
		can create shared objects of up 100 KB of data per domain. Administrators
		and users can also place restrictions on the ability to write to the file
		system.

		Suppose you publish SWF file content to be played back as local files
		(either locally installed SWF files or EXE files), and you need to access
		a specific shared object from more than one local SWF file. In this
		situation, be aware that for local files, two different locations might be
		used to store shared objects. The domain that is used depends on the
		security permissions granted to the local file that created the shared
		object. Local files can have three different levels of permissions:

		 1. Access to the local filesystem only.
		 2. Access to the network only.
		 3. Access to both the network and the local filesystem.

		Local files with access to the local filesystem(level 1 or 3) store
		their shared objects in one location. Local files without access to the
		local filesystem(level 2) store their shared objects in another
		location.

		You can prevent a SWF file from using this method by setting the
		`allowNetworking` parameter of the the `object` and
		`embed` tags in the HTML page that contains the SWF
		content.

		For more information, see the Flash Player Developer Center Topic:
		[Security](http://www.adobe.com/go/devnet_security_en).

		@param name      The name of the object. The name can include forward
						 slashes(`/`); for example,
						 `work/addresses` is a legal name. Spaces are
						 not allowed in a shared object name, nor are the
						 following characters: `~ % & \
						 ; : " ' , < > ? #`
		@param localPath The full or partial path to the SWF file that created the
						 shared object, and that determines where the shared
						 object will be stored locally. If you do not specify this
						 parameter, the full path is used.
		@param secure    Determines whether access to this shared object is
						 restricted to SWF files that are delivered over an HTTPS
						 connection. If your SWF file is delivered over HTTPS,
						 this parameter's value has the following effects:

						  * If this parameter is set to `true`,
						 Flash Player creates a new secure shared object or gets a
						 reference to an existing secure shared object. This
						 secure shared object can be read from or written to only
						 by SWF files delivered over HTTPS that call
						 `SharedObject.getLocal()` with the
						 `secure` parameter set to
						 `true`.
						  * If this parameter is set to `false`,
						 Flash Player creates a new shared object or gets a
						 reference to an existing shared object that can be read
						 from or written to by SWF files delivered over non-HTTPS
						 connections.


						 If your SWF file is delivered over a non-HTTPS
						 connection and you try to set this parameter to
						 `true`, the creation of a new shared object
						(or the access of a previously created secure shared
						 object) fails and `null` is returned.
						 Regardless of the value of this parameter, the created
						 shared objects count toward the total amount of disk
						 space allowed for a domain.

						 The following diagram shows the use of the
						 `secure` parameter:
		@return A reference to a shared object that is persistent locally and is
				available only to the current client. If Flash Player can't create
				or find the shared object(for example, if `localPath`
				was specified but no such directory exists), this method throws an
				exception.
		@throws Error Flash Player cannot create the shared object for whatever
					  reason. This error might occur is if persistent shared
					  object creation and storage by third-party Flash content is
					  prohibited(does not apply to local content). Users can
					  prohibit third-party persistent shared objects on the Global
					  Storage Settings panel of the Settings Manager, located at
					  [http://www.adobe.com/support/documentation/en/flashplayer/help/settings_manager03.html](http://www.adobe.com/support/documentation/en/flashplayer/help/settings_manager03.html).
	**/
	public static function getLocal(name:String, localPath:String = null, secure:Bool = false /* note: unsupported**/):SharedObject
	{
		var illegalValues = [" ", "~", "%", "&", "\\", ";", ":", "\"", "'", ",", "<", ">", "?", "#"];
		var allowed = true;

		if (name == null || name == "")
		{
			allowed = false;
		}
		else
		{
			for (value in illegalValues)
			{
				if (name.indexOf(value) > -1)
				{
					allowed = false;
					break;
				}
			}
		}

		if (!allowed)
		{
			throw new Error("Error #2134: Cannot create SharedObject.");
			return null;
		}

		if (__sharedObjects == null)
		{
			__sharedObjects = new Map();
			// Lib.application.onExit.add (application_onExit);
			#if lime
			if (Application.current != null)
			{
				Application.current.onExit.add(application_onExit);
			}
			#end
		}

		var id = localPath + "/" + name;

		if (!__sharedObjects.exists(id))
		{
			var encodedData = null;

			try
			{
				#if (js && html5)
				var storage = Browser.getLocalStorage();

				if (localPath == null)
				{
					// Check old default path, first
					if (storage != null)
					{
						encodedData = storage.getItem(Browser.window.location.href + ":" + name);
						storage.removeItem(Browser.window.location.href + ":" + name);
					}

					localPath = Browser.window.location.pathname;
				}

				if (storage != null && encodedData == null)
				{
					encodedData = storage.getItem(localPath + ":" + name);
				}
				#else
				if (localPath == null) localPath = "";

				var path = __getPath(localPath, name);

				if (FileSystem.exists(path))
				{
					encodedData = File.getContent(path);
				}
				#end
			}
			catch (e:Dynamic) {}

			var sharedObject = new SharedObject();
			sharedObject.data = {};
			sharedObject.__localPath = localPath;
			sharedObject.__name = name;

			if (encodedData != null && encodedData != "")
			{
				try
				{
					var unserializer = new Unserializer(encodedData);
					unserializer.setResolver(cast {resolveEnum: Type.resolveEnum, resolveClass: __resolveClass});
					sharedObject.data = unserializer.unserialize();
				}
				catch (e:Dynamic) {}
			}

			__sharedObjects.set(id, sharedObject);
		}

		return __sharedObjects.get(id);
	}

	#if !openfl_strict
	/**
		Returns a reference to a shared object on Flash Media Server that
		multiple clients can access. If the remote shared object does not
		already exist, this method creates one.
		To create a remote shared object, call `getRemote()` the call
		`connect()` to connect the remote shared object to the server, as in
		the following:

		```as3
		var nc:NetConnection = new NetConnection();
		nc.connect("rtmp://somedomain.com/applicationName");
		var myRemoteSO:SharedObject = SharedObject.getRemote("mo", nc.uri, false);
		myRemoteSO.connect(nc);
		```

		To confirm that the local and remote copies of the shared object are
		synchronized, listen for and handle the `sync` event. All clients that
		want to share this object must pass the same values for the `name` and
		`remotePath` parameters.

		To create a shared object that is available only to the current
		client, use `SharedObject.getLocal()`.

		@param name        The name of the remote shared object. The name can
						   include forward slashes (/); for example,
						   work/addresses is a legal name. Spaces are not
						   allowed in a shared object name, nor are the
						   following characters: `~ % & \ ; :  " ' , > ? ? #`
		@param remotePath  The URI of the server on which the shared object
						   will be stored. This URI must be identical to the
						   URI of the NetConnection object passed to the
						   `connect()` method.
		@param persistence Specifies whether the attributes of the shared
						   object's data property are persistent locally,
						   remotely, or both. This parameter can also specify
						   where the shared object will be stored locally.
						   Acceptable values are as follows:
						   * A value of `false` specifies that the shared
						   object is not persistent on the client or server.
						   * A value of `true` specifies that the shared
						   object is persistent only on the server.
						   * A full or partial local path to the shared object
						   indicates that the shared object is persistent on
						   the client and the server. On the client, it is
						   stored in the specified path; on the server, it is
						   stored in a subdirectory within the application
						   directory.

						   **Note:** If the user has chosen to never allow
						   local storage for this domain, the object will not
						   be saved locally, even if a local path is specified
						   for persistence. For more information, see the
						   class description.
		@param secure      Determines whether access to this shared object is
						   restricted to SWF files that are delivered over an
						   HTTPS connection. For more information, see the
						   description of the `secure` parameter in the
						   `getLocal` method entry.
		@return A reference to an object that can be shared across multiple
				clients.
		@throws Error Flash Player can't create or find the shared object.
					  This might occur if nonexistent paths were specified for
					  the `remotePath` and `persistence` parameters.
	**/
	public static function getRemote(name:String, remotePath:String = null, persistence:Dynamic = false, secure:Bool = false):SharedObject
	{
		openfl.utils._internal.Lib.notImplemented();

		return null;
	}
	#end

	#if !openfl_strict
	/**
		Broadcasts a message to all clients connected to a remote shared
		object, including the client that sent the message. To process and
		respond to the message, create a callback function attached to the
		shared object.

	**/
	public function send(args:Array<Dynamic>):Void
	{
		openfl.utils._internal.Lib.notImplemented();
	}
	#end

	/**
		Indicates to the server that the value of a property in the shared
		object has changed. This method marks properties as _dirty_, which
		means changed.
		Call the `SharedObject.setProperty()` to create properties for a
		shared object.

		The `SharedObject.setProperty()` method implements `setDirty()`. In
		most cases, such as when the value of a property is a primitive type
		like String or Number, you can call `setProperty()` instead of calling
		`setDirty()`. However, when the value of a property is an object that
		contains its own properties, call `setDirty()` to indicate when a
		value within the object has changed.

		@param propertyName The name of the property that has changed.
	**/
	public function setDirty(propertyName:String):Void {}

	/**
		Updates the value of a property in a shared object and indicates to
		the server that the value of the property has changed. The
		`setProperty()` method explicitly marks properties as changed, or
		dirty.
		For more information about remote shared objects see the <a
		href="http://www.adobe.com/go/learn_fms_docs_en"> Flash Media Server
		documentation</a>.

		**Note:** The `SharedObject.setProperty()` method implements the
		`setDirty()` method. In most cases, such as when the value of a
		property is a primitive type like String or Number, you would use
		`setProperty()` instead of `setDirty`. However, when the value of a
		property is an object that contains its own properties, use
		`setDirty()` to indicate when a value within the object has changed.
		In general, it is a good idea to call `setProperty()` rather than
		`setDirty()`, because `setProperty()` updates a property value only
		when that value has changed, whereas `setDirty()` forces
		synchronization on all subscribed clients.

		@param propertyName The name of the property in the shared object.
		@param value        The value of the property (an ActionScript
							object), or `null` to delete the property.
	**/
	public function setProperty(propertyName:String, value:Object = null):Void
	{
		if (data != null)
		{
			Reflect.setField(data, propertyName, value);
		}
	}

	@:noCompletion private static function __getPath(localPath:String, name:String):String
	{
		#if lime
		var path = System.applicationStorageDirectory + "/" + localPath + "/";

		name = StringTools.replace(name, "//", "/");
		name = StringTools.replace(name, "//", "/");

		if (StringTools.startsWith(name, "/"))
		{
			name = name.substr(1);
		}

		if (StringTools.endsWith(name, "/"))
		{
			name = name.substring(0, name.length - 1);
		}

		if (name.indexOf("/") > -1)
		{
			var split = name.split("/");
			name = "";

			for (i in 0...(split.length - 1))
			{
				name += "#" + split[i] + "/";
			}

			name += split[split.length - 1];
		}

		return path + name + ".sol";
		#else
		return name + ".sol";
		#end
	}

	@:noCompletion private static function __mkdir(directory:String):Void
	{
		// TODO: Move this to Lime somewhere?

		#if sys
		directory = StringTools.replace(directory, "\\", "/");
		var total = "";

		if (directory.substr(0, 1) == "/")
		{
			total = "/";
		}

		var parts = directory.split("/");
		var oldPath = "";

		if (parts.length > 0 && parts[0].indexOf(":") > -1)
		{
			oldPath = Sys.getCwd();
			Sys.setCwd(parts[0] + "\\");
			parts.shift();
		}

		for (part in parts)
		{
			if (part != "." && part != "")
			{
				if (total != "" && total != "/")
				{
					total += "/";
				}

				total += part;

				if (!FileSystem.exists(total))
				{
					FileSystem.createDirectory(total);
				}
			}
		}

		if (oldPath != "")
		{
			Sys.setCwd(oldPath);
		}
		#end
	}

	@:noCompletion private static function __resolveClass(name:String):Class<Dynamic>
	{
		if (name != null)
		{
			if (StringTools.startsWith(name, "neash."))
			{
				name = StringTools.replace(name, "neash.", "openfl.");
			}

			if (StringTools.startsWith(name, "native."))
			{
				name = StringTools.replace(name, "native.", "openfl.");
			}

			if (StringTools.startsWith(name, "flash."))
			{
				name = StringTools.replace(name, "flash.", "openfl.");
			}

			if (StringTools.startsWith(name, "openfl._v2."))
			{
				name = StringTools.replace(name, "openfl._v2.", "openfl.");
			}

			if (StringTools.startsWith(name, "openfl._legacy."))
			{
				name = StringTools.replace(name, "openfl._legacy.", "openfl.");
			}

			return Type.resolveClass(name);
		}

		return null;
	}

	// Event Handlers
	@:noCompletion private static function application_onExit(_):Void
	{
		for (sharedObject in __sharedObjects)
		{
			sharedObject.flush();
		}
	}

	// Getters & Setters
	@:noCompletion private function get_size():Int
	{
		try
		{
			var d = Serializer.run(data);
			return Bytes.ofString(d).length;
		}
		catch (e:Dynamic)
		{
			return 0;
		}
	}
}
#else
typedef SharedObject = flash.net.SharedObject;
#end
