package openfl.net;

#if !flash
import haxe.io.Path;
import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;
#if lime
import lime.ui.FileDialog;
import lime.utils.Bytes;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if (js && html5)
import js.html.FileReader;
import js.html.InputElement;
import js.Browser;
#end

/**
	The FileReference class provides a means to upload and download files
	between a user's computer and a server. An operating-system dialog box
	prompts the user to select a file to upload or a location for download.
	Each FileReference object refers to a single file on the user's disk and
	has properties that contain information about the file's size, type, name,
	creation date, modification date, and creator type (Macintosh only).
	**Note:** In Adobe AIR, the File class, which extends the FileReference
	class, provides more capabilities and has less security restrictions than
	the FileReference class.

	FileReference instances are created in the following ways:

	* When you use the `new` operator with the FileReference constructor: `var
	myFileReference = new FileReference();`
	* When you call the `FileReferenceList.browse()` method, which creates an
	array of FileReference objects.

	During an upload operation, all the properties of a FileReference object
	are populated by calls to the `FileReference.browse()` or
	`FileReferenceList.browse()` methods. During a download operation, the
	`name` property is populated when the `select` event is dispatched; all
	other properties are populated when the `complete` event is dispatched.

	The `browse()` method opens an operating-system dialog box that prompts
	the user to select a file for upload. The `FileReference.browse()` method
	lets the user select a single file; the `FileReferenceList.browse()`
	method lets the user select multiple files. After a successful call to the
	`browse()` method, call the `FileReference.upload()` method to upload one
	file at a time. The `FileReference.download()` method prompts the user for
	a location to save the file and initiates downloading from a remote URL.

	The FileReference and FileReferenceList classes do not let you set the
	default file location for the dialog box that the `browse()` or
	`download()` methods generate. The default location shown in the dialog
	box is the most recently browsed folder, if that location can be
	determined, or the desktop. The classes do not allow you to read from or
	write to the transferred file. They do not allow the SWF file that
	initiated the upload or download to access the uploaded or downloaded file
	or the file's location on the user's disk.

	The FileReference and FileReferenceList classes also do not provide
	methods for authentication. With servers that require authentication, you
	can download files with the Flash<sup>?/sup> Player browser plug-in, but
	uploading (on all players) and downloading (on the stand-alone or external
	player) fails. Listen for FileReference events to determine whether
	operations complete successfully and to handle errors.

	For content running in Flash Player or for content running in Adobe AIR
	outside of the application security sandbox, uploading and downloading
	operations can access files only within its own domain and within any
	domains that a URL policy file specifies. Put a policy file on the file
	server if the content initiating the upload or download doesn't come from
	the same domain as the file server.

	Note that because of new functionality added to the Flash Player, when
	publishing to Flash Player 10, you can have only one of the following
	operations active at one time: `FileReference.browse()`,
	`FileReference.upload()`, `FileReference.download()`,
	`FileReference.load()`, `FileReference.save()`. Otherwise, Flash Player
	throws a runtime error (code 2174). Use `FileReference.cancel()` to stop
	an operation in progress. This restriction applies only to Flash Player
	10. Previous versions of Flash Player are unaffected by this restriction
	on simultaneous multiple operations.

	While calls to the `FileReference.browse()`, `FileReferenceList.browse()`,
	or `FileReference.download()` methods are executing, SWF file playback
	pauses in stand-alone and external versions of Flash Player and in AIR for
	Linux and Mac OS X 10.1 and earlier

	The following sample HTTP `POST` request is sent from Flash Player to a
	server-side script if no parameters are specified:

	```
	POST /handler.cfm HTTP/1.1
	Accept: text/*
	Content-Type: multipart/form-data;
	boundary=----------Ij5ae0ae0KM7GI3KM7
	User-Agent: Shockwave Flash
	Host: www.example.com
	Content-Length: 421
	Connection: Keep-Alive
	Cache-Control: no-cache

	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filename"

	MyFile.jpg
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filedata"; filename="MyFile.jpg"
	Content-Type: application/octet-stream

	FileDataHere
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Upload"

	Submit Query
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7--
	```

	Flash Player sends the following HTTP `POST` request if the user specifies
	the parameters `"api_sig"`, `"api_key"`, and `"auth_token"`:

	```
	POST /handler.cfm HTTP/1.1
	Accept: text/*
	Content-Type: multipart/form-data;
	boundary=----------Ij5ae0ae0KM7GI3KM7
	User-Agent: Shockwave Flash
	Host: www.example.com
	Content-Length: 421
	Connection: Keep-Alive
	Cache-Control: no-cache

	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filename"

	MyFile.jpg
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="api_sig"

	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="api_key"

	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="auth_token"

	XXXXXXXXXXXXXXXXXXXXXX
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Filedata"; filename="MyFile.jpg"
	Content-Type: application/octet-stream

	FileDataHere
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7
	Content-Disposition: form-data; name="Upload"

	Submit Query
	------------Ij5GI3GI3ei4GI3ei4KM7GI3KM7KM7--
	```

	@event cancel             Dispatched when a file upload or download is
							  canceled through the file-browsing dialog box by
							  the user. Flash Player does not dispatch this
							  event if the user cancels an upload or download
							  through other means (closing the browser or
							  stopping the current application).
	@event complete           Dispatched when download is complete or when
							  upload generates an HTTP status code of 200. For
							  file download, this event is dispatched when
							  Flash Player or Adobe AIR finishes downloading
							  the entire file to disk. For file upload, this
							  event is dispatched after the Flash Player or
							  Adobe AIR receives an HTTP status code of 200
							  from the server receiving the transmission.
	@event httpResponseStatus Dispatched if a call to the `upload()` or
							  `uploadUnencoded()` method attempts to access
							  data over HTTP and Adobe AIR is able to detect
							  and return the status code for the request.
	@event httpStatus         Dispatched when an upload fails and an HTTP
							  status code is available to describe the
							  failure. The `httpStatus` event is dispatched,
							  followed by an `ioError` event.
							  The `httpStatus` event is dispatched only for
							  upload failures. For content running in Flash
							  Player this event is not applicable for download
							  failures. If a download fails because of an HTTP
							  error, the error is reported as an I/O error.
	@event ioError            Dispatched when the upload or download fails. A
							  file transfer can fail for one of the following
							  reasons:
							  * An input/output error occurs while the player
							  is reading, writing, or transmitting the file.
							  * The SWF file tries to upload a file to a
							  server that requires authentication (such as a
							  user name and password). During upload, Flash
							  Player or Adobe AIR does not provide a means for
							  users to enter passwords. If a SWF file tries to
							  upload a file to a server that requires
							  authentication, the upload fails.
							  * The SWF file tries to download a file from a
							  server that requires authentication, within the
							  stand-alone or external player. During download,
							  the stand-alone and external players do not
							  provide a means for users to enter passwords. If
							  a SWF file in these players tries to download a
							  file from a server that requires authentication,
							  the download fails. File download can succeed
							  only in the ActiveX control, browser plug-in
							  players, and the Adobe AIR runtime.
							  * The value passed to the `url` parameter in the
							  `upload()` method contains an invalid protocol.
							  Valid protocols are HTTP and HTTPS.

							  **Important:** Only applications running in a
							  browser ?that is, using the browser plug-in
							  or ActiveX control ?and content running in
							  Adobe AIR can provide a dialog box to prompt the
							  user to enter a user name and password for
							  authentication, and then only for downloads. For
							  uploads using the plug-in or ActiveX control
							  version of Flash Player, or for upload or
							  download using either the stand-alone or the
							  external player, the file transfer fails.
	@event open               Dispatched when an upload or download operation
							  starts.
	@event progress           Dispatched periodically during the file upload
							  or download operation. The `progress` event is
							  dispatched while Flash Player transmits bytes to
							  a server, and it is periodically dispatched
							  during the transmission, even if the
							  transmission is ultimately not successful. To
							  determine if and when the file transmission is
							  actually successful and complete, listen for the
							  `complete` event.
							  In some cases, `progress` events are not
							  received. For example, when the file being
							  transmitted is very small or the upload or
							  download happens very quickly a `progress` event
							  might not be dispatched.

							  File upload progress cannot be determined on
							  Macintosh platforms earlier than OS X 10.3. The
							  `progress` event is called during the upload
							  operation, but the value of the `bytesLoaded`
							  property of the progress event is -1, indicating
							  that the progress cannot be determined.
	@event securityError      Dispatched when a call to the
							  `FileReference.upload()` or
							  `FileReference.download()` method tries to
							  upload a file to a server or get a file from a
							  server that is outside the caller's security
							  sandbox. The value of the text property that
							  describes the specific error that occurred is
							  normally `"securitySandboxError"`. The calling
							  SWF file may have tried to access a SWF file
							  outside its domain and does not have permission
							  to do so. You can try to remedy this error by
							  using a URL policy file.
							  In Adobe AIR, these security restrictions do not
							  apply to content in the application security
							  sandbox.

							  In Adobe AIR, these security restrictions do not
							  apply to content in the application security
							  sandbox.
	@event select             Dispatched when the user selects a file for
							  upload or download from the file-browsing dialog
							  box. (This dialog box opens when you call the
							  `FileReference.browse()`,
							  `FileReferenceList.browse()`, or
							  `FileReference.download()` method.) When the
							  user selects a file and confirms the operation
							  (for example, by clicking OK), the properties of
							  the FileReference object are populated.
							  For content running in Flash Player or outside
							  of the application security sandbox in the Adobe
							  AIR runtime, the `select` event acts slightly
							  differently depending on what method invokes it.
							  When the `select` event is dispatched after a
							  `browse()` call, Flash Player or the AIR
							  application can read all the FileReference
							  object's properties, because the file selected
							  by the user is on the local file system. When
							  the `select` event occurs after a `download()`
							  call, Flash Player or the AIR application can
							  read only the `name` property, because the file
							  hasn't yet been downloaded to the local file
							  system at the moment the `select` event is
							  dispatched. When the file is downloaded and the
							  `complete` event dispatched, Flash Player or the
							  AIR application can read all other properties of
							  the FileReference object.
	@event uploadCompleteData Dispatched after data is received from the
							  server after a successful upload. This event is
							  not dispatched if data is not returned from the
							  server.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FileReference extends EventDispatcher
{
	/**
		The creation date of the file on the local disk. If the object is was
		not populated, a call to get the value of this property returns
		`null`.

		@throws IOError               If the file information cannot be
									  accessed, an exception is thrown with a
									  message indicating a file I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `creationDate` property is `null`.
	**/
	public var creationDate(default, null):Date;

	/**
		The Macintosh creator type of the file, which is only used in Mac OS
		versions prior to Mac OS X. In Windows or Linux, this property is
		`null`. If the FileReference object was not populated, a call to get
		the value of this property returns `null`.

		@throws IllegalOperationError On Macintosh, if the
									  `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `creator` property is `null`.
	**/
	public var creator(default, null):String;

	/**
		The ByteArray object representing the data from the loaded file after
		a successful call to the `load()` method.

		@throws IOError               If the file cannot be opened or read, or
									  if a similar error is encountered in
									  accessing the file, an exception is
									  thrown with a message indicating a file
									  I/O error. In this case, the value of
									  the `data` property is `null`.
		@throws IllegalOperationError If the `load()` method was not called
									  successfully, an exception is thrown
									  with a message indicating that functions
									  were called in the incorrect sequence or
									  an earlier call was unsuccessful. In
									  this case, the value of the `data`
									  property is `null`.
	**/
	public var data(default, null):ByteArray;

	/**
		The date that the file on the local disk was last modified. If the
		FileReference object was not populated, a call to get the value of
		this property returns `null`.

		@throws IOError               If the file information cannot be
									  accessed, an exception is thrown with a
									  message indicating a file I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `modificationDate` property is
									  `null`.
	**/
	public var modificationDate(default, null):Date;

	/**
		The name of the file on the local disk. If the FileReference object
		was not populated (by a valid call to `FileReference.download()` or `
		FileReference.browse()`), Flash Player throws an error when you try to
		get the value of this property.
		All the properties of a FileReference object are populated by calling
		the `browse()` method. Unlike other FileReference properties, if you
		call the `download()` method, the `name` property is populated when
		the `select` event is dispatched.

		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful.
	**/
	public var name(default, null):String;

	/**
		The size of the file on the local disk in bytes. If `size` is 0, an
		exception is thrown.
		_Note:_ In the initial version of ActionScript 3.0, the `size`
		property was defined as a uint object, which supported files with
		sizes up to about 4 GB. It is now implemented as a Number object to
		support larger files.

		@throws IOError               If the file cannot be opened or read, or
									  if a similar error is encountered in
									  accessing the file, an exception is
									  thrown with a message indicating a file
									  I/O error.
		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful.
	**/
	public var size(default, null):Int;

	/**
		The file type.
		In Windows or Linux, this property is the file extension. On the
		Macintosh, this property is the four-character file type, which is
		only used in Mac OS versions prior to Mac OS X. If the FileReference
		object was not populated, a call to get the value of this property
		returns `null`.

		For Windows, Linux, and Mac OS X, the file extension ?the portion
		of the `name` property that follows the last occurrence of the dot (.)
		character ?identifies the file type.

		@throws IllegalOperationError If the `FileReference.browse()`,
									  `FileReferenceList.browse()`, or
									  `FileReference.download()` method was
									  not called successfully, an exception is
									  thrown with a message indicating that
									  functions were called in the incorrect
									  sequence or an earlier call was
									  unsuccessful. In this case, the value of
									  the `type` property is `null`.
	**/
	public var type(default, null):String;

	@:noCompletion private var __data:ByteArray;
	@:noCompletion private var __path:String;
	@:noCompletion private var __urlLoader:URLLoader;
	#if (js && html5)
	@:noCompletion private var __inputControl:InputElement;
	#end

	/**
		Creates a new FileReference object. When populated, a FileReference
		object represents a file on the user's local disk.
	**/
	public function new()
	{
		super();
		#if (js && html5)
		__inputControl = cast Browser.document.createElement("input");
		__inputControl.setAttribute("type", "file");
		__inputControl.onclick = function(e)
		{
			e.cancelBubble = true;
			e.stopPropagation();
		}
		#end
	}

	/**
		Displays a file-browsing dialog box that lets the user select a file
		to upload. The dialog box is native to the user's operating system.
		The user can select a file on the local computer or from other
		systems, for example, through a UNC path on Windows.
		**Note:** The File class, available in Adobe AIR, includes methods for
		accessing more specific system file selection dialog boxes. These
		methods are `File.browseForDirectory()`, `File.browseForOpen()`,
		`File.browseForOpenMultiple()`, and `File.browseForSave()`.

		When you call this method and the user successfully selects a file,
		the properties of this FileReference object are populated with the
		properties of that file. Each subsequent time that the
		`FileReference.browse()` method is called, the FileReference object's
		properties are reset to the file that the user selects in the dialog
		box. Only one `browse()` or `download()` session can be performed at a
		time (because only one dialog box can be invoked at a time).

		Using the `typeFilter` parameter, you can determine which files the
		dialog box displays.

		In Flash Player 10 and Flash Player 9 Update 5, you can only call this
		method successfully in response to a user event (for example, in an
		event handler for a mouse click or keypress event). Otherwise, calling
		this method results in Flash Player throwing an Error exception.

		Note that because of new functionality added to the Flash Player, when
		publishing to Flash Player 10, you can have only one of the following
		operations active at one time: `FileReference.browse()`,
		`FileReference.upload()`, `FileReference.download()`,
		`FileReference.load()`, `FileReference.save()`. Otherwise, Flash
		Player throws a runtime error (code 2174). Use
		`FileReference.cancel()` to stop an operation in progress. This
		restriction applies only to Flash Player 10. Previous versions of
		Flash Player are unaffected by this restriction on simultaneous
		multiple operations.

		In Adobe AIR, the file-browsing dialog is not always displayed in
		front of windows that are "owned" by another window (windows that have
		a non-null `owner` property). To avoid window ordering issues, hide
		owned windows before calling this method.

		@return Returns `true` if the parameters are valid and the
				file-browsing dialog box opens.
		@throws ArgumentError         If the `typeFilter` array contains
									  FileFilter objects that are incorrectly
									  formatted, an exception is thrown. For
									  information on the correct format for
									  FileFilter objects, see the <a
									  href="FileFilter.html">FileFilter</a>
									  class.
		@throws Error                 If the method is not called in response
									  to a user action, such as a mouse event
									  or keypress event.
		@throws IllegalOperationError Thrown in the following situations: 1)
									  Another FileReference or
									  FileReferenceList browse session is in
									  progress; only one file browsing session
									  may be performed at a time. 2) A setting
									  in the user's mms.cfg file prohibits
									  this operation.
		@event cancel Dispatched when the user cancels the file upload Browse
					  window.
		@event select Dispatched when the user successfully selects an item
					  from the Browse file chooser.
	**/
	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		__data = null;
		__path = null;

		#if desktop
		var filter = null;

		if (typeFilter != null)
		{
			var filters = [];

			for (type in typeFilter)
			{
				filters.push(StringTools.replace(StringTools.replace(type.extension, "*.", ""), ";", ","));
			}

			filter = filters.join(";");
		}

		var openFileDialog = new FileDialog();
		openFileDialog.onCancel.add(openFileDialog_onCancel);
		openFileDialog.onSelect.add(openFileDialog_onSelect);
		openFileDialog.browse(OPEN, filter);
		return true;
		#elseif (js && html5)
		var filter = null;
		if (typeFilter != null)
		{
			var filters = [];
			for (type in typeFilter)
			{
				filters.push(StringTools.replace(StringTools.replace(type.extension, "*.", "."), ";", ","));
			}
			filter = filters.join(",");
		}
		if (filter != null)
		{
			__inputControl.setAttribute("accept", filter);
		}
		__inputControl.onchange = function()
		{
			var file = __inputControl.files[0];
			modificationDate = Date.fromTime(file.lastModified);
			creationDate = modificationDate;
			size = file.size;
			type = "." + Path.extension(file.name);
			name = Path.withoutDirectory(file.name);
			__path = file.name;
			dispatchEvent(new Event(Event.SELECT));
		}
		__inputControl.click();
		return true;
		#end

		return false;
	}

	/**
		Cancels any ongoing upload or download operation on this FileReference
		object. Calling this method does not dispatch the `cancel` event; that
		event is dispatched only when the user cancels the operation by
		dismissing the file upload or download dialog box.

	**/
	public function cancel():Void
	{
		if (__urlLoader != null)
		{
			__urlLoader.close();
		}
	}

	/**
		Opens a dialog box that lets the user download a file from a remote
		server. Although Flash Player has no restriction on the size of files
		you can upload or download, the player officially supports uploads or
		downloads of up to 100 MB.
		The `download()` method first opens an operating-system dialog box
		that asks the user to enter a filename and select a location on the
		local computer to save the file. When the user selects a location and
		confirms the download operation (for example, by clicking Save), the
		download from the remote server begins. Listeners receive events to
		indicate the progress, success, or failure of the download. To
		ascertain the status of the dialog box and the download operation
		after calling `download()`, your code must listen for events such as
		`cancel`, `open`, `progress`, and `complete`.

		The `FileReference.upload()` and `FileReference.download()` functions
		are nonblocking. These functions return after they are called, before
		the file transmission is complete. In addition, if the FileReference
		object goes out of scope, any upload or download that is not yet
		completed on that object is canceled upon leaving the scope. Be sure
		that your FileReference object remains in scope for as long as the
		upload or download is expected to continue.

		When the file is downloaded successfully, the properties of the
		FileReference object are populated with the properties of the local
		file. The `complete` event is dispatched if the download is
		successful.

		Only one `browse()` or `download()` session can be performed at a time
		(because only one dialog box can be invoked at a time).

		This method supports downloading of any file type, with either HTTP or
		HTTPS.

		You cannot connect to commonly reserved ports. For a complete list of
		blocked ports, see "Restricting Networking APIs" in the _ActionScript
		3.0 Developer's Guide_.

		**Note**: If your server requires user authentication, only SWF files
		running in a browser ?that is, using the browser plug-in or ActiveX
		control ?can provide a dialog box to prompt the user for a user
		name and password for authentication, and only for downloads. For
		uploads using the plug-in or ActiveX control, or for uploads and
		downloads using the stand-alone or external player, the file transfer
		fails.

		When you use this method , consider the Flash Player security model:

		* Loading operations are not allowed if the calling SWF file is in an
		untrusted local sandbox.
		* The default behavior is to deny access between sandboxes. A website
		can enable access to a resource by adding a URL policy file.
		* You can prevent a SWF file from using this method by setting the
		`allowNetworking` parameter of the the `object` and `embed` tags in
		the HTML page that contains the SWF content.
		* In Flash Player 10 and Flash Player 9 Update 5, you can only call
		this method successfully in response to a user event (for example, in
		an event handler for a mouse click or keypress event). Otherwise,
		calling this method results in Flash Player throwing an Error
		exception.

		However, in Adobe AIR, content in the `application` security sandbox
		(content installed with the AIR application) is not restricted by
		these security limitations.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		When you download a file using this method, it is flagged as
		downloaded on operating systems that flag downloaded files:

		* Windows XP service pack 2 and later, and on Windows Vista
		* Mac OS 10.5 and later

		Some operating systems, such as Linux, do not flag downloaded files.

		Note that because of new functionality added to the Flash Player, when
		publishing to Flash Player 10, you can have only one of the following
		operations active at one time: `FileReference.browse()`,
		`FileReference.upload()`, `FileReference.download()`,
		`FileReference.load()`, `FileReference.save()`. Otherwise, Flash
		Player throws a runtime error (code 2174). Use
		`FileReference.cancel()` to stop an operation in progress. This
		restriction applies only to Flash Player 10. Previous versions of
		Flash Player are unaffected by this restriction on simultaneous
		multiple operations.

		In Adobe AIR, the download dialog is not always displayed in front of
		windows that are "owned" by another window (windows that have a
		non-null `owner` property). To avoid window ordering issues, hide
		owned windows before calling this method.

		@param request         The URLRequest object. The `url` property of
							   the URLRequest object should contain the URL of
							   the file to download to the local computer. If
							   this parameter is `null`, an exception is
							   thrown. The `requestHeaders` property of the
							   URLRequest object is ignored; custom HTTP
							   request headers are not supported in uploads or
							   downloads. To send `POST` or GET parameters to
							   the server, set the value of `URLRequest.data`
							   to your parameters, and set `URLRequest.method`
							   to either `URLRequestMethod.POST` or
							   `URLRequestMethod.GET`.
							   On some browsers, URL strings are limited in
							   length. Lengths greater than 256 characters may
							   fail on some browsers or servers.
		@param defaultFileName The default filename displayed in the dialog
							   box for the file to be downloaded. This string
							   must not contain the following characters: `/ \ : * ? " < > | %`
							   If you omit this parameter, the filename of the
							   remote URL is parsed and used as the default.
		@throws ArgumentError         If `url.data` is of type ByteArray, an
									  exception is thrown. For use with the
									  `FileReference.upload()` and
									  `FileReference.download()` methods,
									  `url.data` can only be of type
									  URLVariables or String.
		@throws Error                 If the method is not called in response
									  to a user action, such as a mouse event
									  or keypress event.
		@throws IllegalOperationError Thrown in the following situations: 1)
									  Another browse session is in progress;
									  only one file browsing session can be
									  performed at a time. 2) The value passed
									  to `request` does not contain a valid
									  path or protocol. 3) The filename to
									  download contains prohibited characters.
									  4) A setting in the user's mms.cfg file
									  prohibits this operation.
		@throws MemoryError           This error can occur for the following
									  reasons: 1) Flash Player cannot convert
									  the `URLRequest.data` parameter from
									  UTF8 to MBCS. This error is applicable
									  if the URLRequest object passed to the
									  `FileReference.download()` method is set
									  to perform a GET operation and if
									  `System.useCodePage` is set to `true`.
									  2) Flash Player cannot allocate memory
									  for the `POST` data. This error is
									  applicable if the URLRequest object
									  passed to the `FileReference.download()`
									  method is set to perform a `POST`
									  operation.
		@throws SecurityError         Local untrusted content may not
									  communicate with the Internet. To avoid
									  this situation, reclassify this SWF file
									  as local-with-networking or trusted.
									  This exception is thrown with a message
									  indicating the filename and the URL that
									  may not be accessed because of local
									  file security restrictions.
		@throws SecurityError         You cannot connect to commonly reserved
									  ports. For a complete list of blocked
									  ports, see "Restricting Networking APIs"
									  in the _ActionScript 3.0 Developer's
									  Guide_.
		@event cancel        Dispatched when the user dismisses the dialog
							 box.
		@event complete      Dispatched when the file download operation
							 successfully completes.
		@event ioError       Dispatched for any of the following reasons:
							 * An input/output error occurs while the file is
							 being read or transmitted.
							 * SWF content running in the stand-alone or
							 external versions of Flash Player tries to
							 download a file from a server that requires
							 authentication. During download, the standalone
							 and external players do not provide a means for
							 users to enter passwords. If a SWF file in these
							 players tries to download a file from a server
							 that requires authentication, the download fails.
							 File download can succeed only in the ActiveX
							 control and browser plug-in players.
		@event open          Dispatched when a download operation starts.
		@event progress      Dispatched periodically during the file download
							 operation.
		@event securityError Dispatched when a download fails because of a
							 security error.
		@event select        Dispatched when the user selects a file for
							 download from the dialog box.
	**/
	public function download(request:URLRequest, defaultFileName:String = null):Void
	{
		__data = null;
		__path = null;

		__urlLoader = new URLLoader();
		__urlLoader.addEventListener(Event.COMPLETE, urlLoader_onComplete);
		__urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_onIOError);
		__urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoader_onProgress);
		__urlLoader.load(request);

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
	}

	/**
		Starts the load of a local file selected by a user. Although Flash
		Player has no restriction on the size of files you can upload,
		download, load or save, it officially supports sizes of up to 100 MB.
		For content running in Flash Player, you must call the
		`FileReference.browse()` or `FileReferenceList.browse()` method before
		you call the `load()` method. However, content running in AIR in the
		application sandbox can call the `load()` method of a File object
		without first calling the `browse()` method. (The AIR File class
		extends the FileReference class.)
		Listeners receive events to indicate the progress, success, or failure
		of the load. Although you can use the FileReferenceList object to let
		users select multiple files to load, you must load the files one by
		one. To load the files one by one, iterate through the
		`FileReferenceList.fileList` array of FileReference objects.

		Adobe AIR also includes the FileStream class which provides more
		options for reading files.

		The `FileReference.upload()`, `FileReference.download()`,
		`FileReference.load()` and `FileReference.save()` functions are
		nonblocking. These functions return after they are called, before the
		file transmission is complete. In addition, if the FileReference
		object goes out of scope, any transaction that is not yet completed on
		that object is canceled upon leaving the scope. Be sure that your
		FileReference object remains in scope for as long as the upload,
		download, load or save is expected to continue.

		If the file finishes loading successfully, its contents are stored as
		a byte array in the `data` property of the FileReference object.

		The following security considerations apply:

		* Loading operations are not allowed if the calling SWF file is in an
		untrusted local sandbox.
		* The default behavior is to deny access between sandboxes. A website
		can enable access to a resource by adding a cross-domain policy file.
		* You can prevent a file from using this method by setting the
		`allowNetworking` parameter of the the `object` and `embed` tags in
		the HTML page that contains the SWF content.

		However, these considerations do not apply to AIR content in the
		application sandbox.

		Note that when publishing to Flash Player 10 or AIR 1.5, you can have
		only one of the following operations active at one time:
		`FileReference.browse()`, `FileReference.upload()`,
		`FileReference.download()`, `FileReference.load()`,
		`FileReference.save()`. Otherwise, the application throws a runtime
		error (code 2174). Use `FileReference.cancel()` to stop an operation
		in progress. This restriction applies only to Flash Player 10 and AIR
		1.5. Previous versions of Flash Player or AIR are unaffected by this
		restriction on simultaneous multiple operations.

		In Adobe AIR, the file-browsing dialog is not always displayed in
		front of windows that are "owned" by another window (windows that have
		a non-null `owner` property). To avoid window ordering issues, hide
		owned windows before calling this method.

		@throws IllegalOperationError Thrown in the following situations: 1)
									  Another FileReference or
									  FileReferenceList browse session is in
									  progress; only one file browsing session
									  may be performed at a time. 2) A setting
									  in the user's mms.cfg file prohibits
									  this operation.
		@throws MemoryError           This error can occur if the application
									  cannot allocate memory for the file. The
									  file may be too large or available
									  memory may be too low.
		@event complete Dispatched when the file load operation completes
						successfully.
		@event ioError  Invoked if the load fails because of an input/output
						error while the application is reading or writing the
						file.
		@event open     Dispatched when an load operation starts.
		@event progress Dispatched periodically during the file load
						operation.
	**/
	public function load():Void
	{
		#if sys
		if (__path != null)
		{
			data = Bytes.fromFile(__path);
			openFileDialog_onComplete();
		}
		#elseif (js && html5)
		var file = __inputControl.files[0];
		var reader = new FileReader();
		reader.onload = function(evt)
		{
			data = ByteArray.fromArrayBuffer(cast evt.target.result);
			openFileDialog_onComplete();
		}
		reader.readAsArrayBuffer(file);
		#end
	}

	/**
		Opens a dialog box that lets the user save a file to the local
		filesystem. Although Flash Player has no restriction on the size of
		files you can upload, download, load or save, the player officially
		supports sizes of up to 100 MB.
		The `save()` method first opens an operating-system dialog box that
		asks the user to enter a filename and select a location on the local
		computer to save the file. When the user selects a location and
		confirms the save operation (for example, by clicking Save), the save
		process begins. Listeners receive events to indicate the progress,
		success, or failure of the save operation. To ascertain the status of
		the dialog box and the save operation after calling `save()`, your
		code must listen for events such as `cancel`, `open`, `progress`, and
		`complete`.

		Adobe AIR also includes the FileStream class which provides more
		options for saving files locally.

		The `FileReference.upload()`, `FileReference.download()`,
		`FileReference.load()` and `FileReference.save()` functions are
		nonblocking. These functions return after they are called, before the
		file transmission is complete. In addition, if the FileReference
		object goes out of scope, any transaction that is not yet completed on
		that object is canceled upon leaving the scope. Be sure that your
		FileReference object remains in scope for as long as the upload,
		download, load or save is expected to continue.

		When the file is saved successfully, the properties of the
		FileReference object are populated with the properties of the local
		file. The `complete` event is dispatched if the save is successful.

		Only one `browse()` or `save()` session can be performed at a time
		(because only one dialog box can be invoked at a time).

		In Flash Player, you can only call this method successfully in
		response to a user event (for example, in an event handler for a mouse
		click or keypress event). Otherwise, calling this method results in
		Flash Player throwing an Error exception. This limitation does not
		apply to AIR content in the application sandbox.

		In Adobe AIR, the save dialog is not always displayed in front of
		windows that are "owned" by another window (windows that have a
		non-null `owner` property). To avoid window ordering issues, hide
		owned windows before calling this method.

		@param data            The data to be saved. The data can be in one of
							   several formats, and will be treated
							   appropriately:
							   * If the value is `null`, the application
							   throws an ArgumentError exception.
							   * If the value is a String, it is saved as a
							   UTF-8 text file.
							   * If the value is XML, it is written to a text
							   file in XML format, with all formatting
							   preserved.
							   * If the value is a ByteArray object, it is
							   written to a data file verbatim.
							   * If the value is none of the above, the
							   `save()` method calls the `toString()` method
							   of the object to convert the data to a string,
							   and it then saves the data as a text file. If
							   that fails, the application throws an
							   ArgumentError exception.
		@param defaultFileName The default filename displayed in the dialog
							   box for the file to be saved. This string must
							   not contain the following characters: `/ \ : * ? " < > | %`
							   If a File object calls this method, the
							   filename will be that of the file the File
							   object references. (The AIR File class extends
							   the FileReference class.)
		@throws ArgumentError         If `data` is not of type ByteArray, and
									  it does not have a `toString()` method,
									  an exception is thrown. If `data` is not
									  of type XML, and it does not have a
									  `toXMLString()` method, an exception is
									  thrown.
		@throws Error                 If the method is not called in response
									  to a user action, such as a mouse event
									  or keypress event.
		@throws IllegalOperationError Thrown in the following situations: 1)
									  Another browse session is in progress;
									  only one file browsing session can be
									  performed at a time. 2) The filename to
									  download contains prohibited characters.
									  3) A setting in the user's mms.cfg file
									  prohibits this operation.
		@throws MemoryError           This error can occur if Flash Player
									  cannot allocate memory for the file. The
									  file may be too large or available
									  memory may be too low.
		@event cancel   Dispatched when the user dismisses the dialog box.
		@event complete Dispatched when the file download operation
						successfully completes.
		@event ioError  Dispatched if an input/output error occurs while the
						file is being read or transmitted.
		@event open     Dispatched when a download operation starts.
		@event progress Dispatched periodically during the file download
						operation.
		@event select   Dispatched when the user selects a file for download
						from the dialog box.
	**/
	public function save(data:Dynamic, defaultFileName:String = null):Void
	{
		__data = null;
		__path = null;

		if (data == null) return;

		#if desktop
		if ((data is ByteArrayData))
		{
			__data = data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(data));
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSelect.add(saveFileDialog_onSelect);
		saveFileDialog.browse(SAVE, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#elseif (js && html5)
		if ((data is ByteArrayData))
		{
			__data = data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(data));
		}

		var saveFileDialog = new FileDialog();
		saveFileDialog.onCancel.add(saveFileDialog_onCancel);
		saveFileDialog.onSave.add(saveFileDialog_onSave);
		saveFileDialog.save(__data, defaultFileName != null ? Path.extension(defaultFileName) : null, defaultFileName);
		#end
	}

	#if !openfl_strict
	/**
		Starts the upload of the file to a remote server. Although Flash
		Player has no restriction on the size of files you can upload or
		download, the player officially supports uploads or downloads of up to
		100 MB. You must call the `FileReference.browse()` or
		`FileReferenceList.browse()` method before you call this method.
		For the Adobe AIR File class, which extends the FileReference class,
		you can use the `upload()` method to upload any file. For the
		FileReference class (used in Flash Player), the user must first select
		a file.

		Listeners receive events to indicate the progress, success, or failure
		of the upload. Although you can use the FileReferenceList object to
		let users select multiple files for upload, you must upload the files
		one by one; to do so, iterate through the `FileReferenceList.fileList`
		array of FileReference objects.

		The `FileReference.upload()` and `FileReference.download()` functions
		are nonblocking. These functions return after they are called, before
		the file transmission is complete. In addition, if the FileReference
		object goes out of scope, any upload or download that is not yet
		completed on that object is canceled upon leaving the scope. Be sure
		that your FileReference object remains in scope for as long as the
		upload or download is expected to continue.

		The file is uploaded to the URL passed in the `url` parameter. The URL
		must be a server script configured to accept uploads. Flash Player
		uploads files by using the HTTP `POST` method. The server script that
		handles the upload should expect a `POST` request with the following
		elements:

		* `Content-Type` of `multipart/form-data`
		* `Content-Disposition` with a `name` attribute set to `"Filedata"` by
		default and a `filename` attribute set to the name of the original
		file
		* The binary contents of the file

		You cannot connect to commonly reserved ports. For a complete list of
		blocked ports, see "Restricting Networking APIs" in the _ActionScript
		3.0 Developer's Guide_.

		For a sample `POST` request, see the description of the
		`uploadDataFieldName` parameter. You can send `POST` or `GET`
		parameters to the server with the `upload()` method; see the
		description of the `request` parameter.

		If the `testUpload` parameter is `true`, and the file to be uploaded
		is bigger than approximately 10 KB, Flash Player on Windows first
		sends a test upload `POST` operation with zero content before
		uploading the actual file, to verify that the transmission is likely
		to succeed. Flash Player then sends a second `POST` operation that
		contains the actual file content. For files smaller than 10 KB, Flash
		Player performs a single upload `POST` with the actual file content to
		be uploaded. Flash Player on Macintosh does not perform test upload
		`POST` operations.

		**Note**: If your server requires user authentication, only SWF files
		running in a browser ?that is, using the browser plug-in or ActiveX
		control ?can provide a dialog box to prompt the user for a username
		and password for authentication, and only for downloads. For uploads
		using the plug-in or ActiveX control, or for uploads and downloads
		using the stand-alone or external player, the file transfer fails.

		When you use this method , consider the Flash Player security model:

		* Loading operations are not allowed if the calling SWF file is in an
		untrusted local sandbox.
		* The default behavior is to deny access between sandboxes. A website
		can enable access to a resource by adding a URL policy file.
		* You can prevent a SWF file from using this method by setting the
		`allowNetworking` parameter of the the `object` and `embed` tags in
		the HTML page that contains the SWF content.

		However, in Adobe AIR, content in the `application` security sandbox
		(content installed with the AIR application) are not restricted by
		these security limitations.

		For more information related to security, see the Flash Player
		Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		Note that because of new functionality added to the Flash Player, when
		publishing to Flash Player 10, you can have only one of the following
		operations active at one time: `FileReference.browse()`,
		`FileReference.upload()`, `FileReference.download()`,
		`FileReference.load()`, `FileReference.save()`. Otherwise, Flash
		Player throws a runtime error (code 2174). Use
		`FileReference.cancel()` to stop an operation in progress. This
		restriction applies only to Flash Player 10. Previous versions of
		Flash Player are unaffected by this restriction on simultaneous
		multiple operations.

		@param request             The URLRequest object; the `url` property
								   of the URLRequest object should contain the
								   URL of the server script configured to
								   handle upload through HTTP `POST` calls. On
								   some browsers, URL strings are limited in
								   length. Lengths greater than 256 characters
								   may fail on some browsers or servers. If
								   this parameter is `null`, an exception is
								   thrown. The `requestHeaders` property of
								   the URLRequest object is ignored; custom
								   HTTP request headers are not supported in
								   uploads or downloads.
								   The URL can be HTTP or, for secure uploads,
								   HTTPS. To use HTTPS, use an HTTPS url in
								   the `url` parameter. If you do not specify
								   a port number in the `url` parameter, port
								   80 is used for HTTP and port 443 us used
								   for HTTPS, by default.

								   To send `POST` or `GET` parameters to the
								   server, set the `data` property of the
								   URLRequest object to your parameters, and
								   set the `method` property to either
								   `URLRequestMethod.POST` or
								   `URLRequestMethod.GET`.
		@param uploadDataFieldName The field name that precedes the file data
								   in the upload `POST` operation. The
								   `uploadDataFieldName` value must be
								   non-null and a non-empty String. By
								   default, the value of `uploadDataFieldName`
								   is `"Filedata"`, as shown in the following
								   sample `POST` request: <pre
								   xml:space="preserve"> Content-Type:
								   multipart/form-data; boundary=AaB03x
								   --AaB03x Content-Disposition: form-data;
								   name="Filedata"; filename="example.jpg"
								   Content-Type: application/octet-stream ...
								   contents of example.jpg ... --AaB03x--
								   </pre>
		@param testUpload          A setting to request a test file upload. If
								   `testUpload` is `true`, for files larger
								   than 10 KB, Flash Player attempts a test
								   file upload `POST` with a Content-Length of
								   0. The test upload checks whether the
								   actual file upload will be successful and
								   that server authentication, if required,
								   will succeed. A test upload is only
								   available for Windows players.
		@throws ArgumentError         Thrown in the following situations: 1)
									  The `uploadDataFieldName` parameter is
									  an empty string. 2) `url.data` is of
									  type ByteArray. For use with the
									  `FileReference.upload()` and
									  `FileReference.download()` methods,
									  `url.data` may only be of type
									  URLVariables or String. 3) In the AIR
									  runtime (in the application security
									  sandbox), the method of the URLRequest
									  is not GET or POST (use
									  `uploadEncoded()` instead).
		@throws IllegalOperationError Thrown in the following situations: 1)
									  Another FileReference or
									  FileReferenceList browse session is in
									  progress; only one file browsing session
									  may be performed at a time. 2) The URL
									  parameter is not a valid path or
									  protocol. File upload must use HTTP, and
									  file download must use FTP or HTTP. 3)
									  The `uploadDataFieldName` parameter is
									  set to `null`. 4) A setting in the
									  user's mms.cfg file prohibits this
									  operation.
		@throws MemoryError           This error can occur for the following
									  reasons: 1) Flash Player cannot convert
									  the `URLRequest.data` parameter from
									  UTF8 to MBCS. This error is applicable
									  if the URLRequest object passed to
									  `FileReference.upload()` is set to
									  perform a GET operation and if
									  `System.useCodePage` is set to `true`.
									  2) Flash Player cannot allocate memory
									  for the `POST` data. This error is
									  applicable if the URLRequest object
									  passed to `FileReference.upload()` is
									  set to perform a `POST` operation.
		@throws SecurityError         Local untrusted SWF files may not
									  communicate with the Internet. To avoid
									  this situation, reclassify this SWF file
									  as local-with-networking or trusted.
									  This exception is thrown with a message
									  indicating the name of the local file
									  and the URL that may not be accessed.
		@throws SecurityError         You cannot connect to commonly reserved
									  ports. For a complete list of blocked
									  ports, see "Restricting Networking APIs"
									  in the _ActionScript 3.0 Developer's
									  Guide_.
		@event complete           Dispatched when the file upload operation
								  completes successfully.
		@event httpResponseStatus The upload operation completes successfully
								  and the server returns a response URL and
								  response headers.
		@event httpStatus         Dispatched when an upload fails because of
								  an HTTP error.
		@event ioError            Invoked in any of the following situations:
								  * The upload fails because of an
								  input/output error while Flash Player or
								  Adobe AIR is reading, writing, or
								  transmitting the file.
								  * The upload fails because an attempt to
								  upload a file to a server that requires
								  authentication (such as a user name and
								  password). During upload, no mean is
								  provided for users to enter passwords.
								  * The upload fails because the `url`
								  parameter contains an invalid protocol.
								  `FileReference.upload()` must use HTTP or
								  HTTPS.
		@event open               Dispatched when an upload operation starts.
		@event progress           Dispatched periodically during the file
								  upload operation.
		@event securityError      Dispatched when an upload fails because of a
								  security violation.
		@event uploadCompleteData Dispatched when data has been received from
								  the server after a successful file upload.
	**/
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void
	{
		openfl.utils._internal.Lib.notImplemented();
	}
	#end

	// Event Handlers
	@:noCompletion private function openFileDialog_onCancel():Void
	{
		dispatchEvent(new Event(Event.CANCEL));
	}

	@:noCompletion private function openFileDialog_onComplete():Void
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}

	@:noCompletion private function openFileDialog_onSelect(path:String):Void
	{
		#if sys
		var fileInfo = FileSystem.stat(path);
		creationDate = fileInfo.ctime;
		modificationDate = fileInfo.mtime;
		size = fileInfo.size;
		type = "." + Path.extension(path);
		#end

		name = Path.withoutDirectory(path);
		__path = path;

		dispatchEvent(new Event(Event.SELECT));
	}

	@:noCompletion private function saveFileDialog_onCancel():Void
	{
		dispatchEvent(new Event(Event.CANCEL));
	}

	@:noCompletion private function saveFileDialog_onSave(path:String):Void
	{
		Timer.delay(function()
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}, 1);
	}

	@:noCompletion private function saveFileDialog_onSelect(path:String):Void
	{
		#if desktop
		name = Path.withoutDirectory(path);

		if (__data != null)
		{
			File.saveBytes(path, __data);

			__data = null;
			__path = null;
		}
		else
		{
			__path = path;
		}
		#end

		dispatchEvent(new Event(Event.SELECT));
	}

	@:noCompletion private function urlLoader_onComplete(event:Event):Void
	{
		#if desktop
		if ((__urlLoader.data is ByteArrayData))
		{
			__data = __urlLoader.data;
		}
		else
		{
			__data = new ByteArray();
			__data.writeUTFBytes(Std.string(__urlLoader.data));
		}

		if (__path != null)
		{
			File.saveBytes(__path, __data);

			__path = null;
			__data = null;
		}
		#end

		dispatchEvent(event);
	}

	@:noCompletion private function urlLoader_onIOError(event:IOErrorEvent):Void
	{
		dispatchEvent(event);
	}

	@:noCompletion private function urlLoader_onProgress(event:ProgressEvent):Void
	{
		dispatchEvent(event);
	}
}
#else
typedef FileReference = flash.net.FileReference;
#end
