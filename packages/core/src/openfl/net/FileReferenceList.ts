import EventDispatcher from "../events/EventDispatcher";
import FileFilter from "../net/FileFilter";
import FileReference from "../net/FileReference";

/**
	The FileReferenceList class provides a means to let users select one or
	more files for uploading. A FileReferenceList object represents a group of
	one or more local files on the user's disk as an array of FileReference
	objects. For detailed information and important considerations about
	FileReference objects and the FileReference class, which you use with
	FileReferenceList, see the FileReference class.
	To work with the FileReferenceList class:

	* Instantiate the class: `var myFileRef = new FileReferenceList();`
	* Call the `FileReferenceList.browse()` method, which opens a dialog box
	that lets the user select one or more files for upload:
	`myFileRef.browse();`
	* After the `browse()` method is called successfully, the `fileList`
	property of the FileReferenceList object is populated with an array of
	FileReference objects.
	* Call `FileReference.upload()` on each element in the `fileList` array.

	The FileReferenceList class includes a `browse()` method and a `fileList`
	property for working with multiple files. While a call to
	`FileReferenceList.browse()` is executing, SWF file playback pauses in
	stand-alone and external versions of Flash Player and in AIR for Linux and
	Mac OS X 10.1 and earlier.

	@event cancel Dispatched when the user dismisses the file-browsing dialog
				  box. (This dialog box opens when you call the
				  `FileReferenceList.browse()`, `FileReference.browse()`, or
				  `FileReference.download()` methods.)
	@event select Dispatched when the user selects one or more files to upload
				  from the file-browsing dialog box. (This dialog box opens
				  when you call the `FileReferenceList.browse()`,
				  `FileReference.browse()`, or `FileReference.download()`
				  methods.) When the user selects a file and confirms the
				  operation (for example, by clicking Save), the
				  `FileReferenceList` object is populated with FileReference
				  objects that represent the files that the user selects.
**/
export default class FileReferenceList extends EventDispatcher
{
	protected __fileList: Array<FileReference>;

	/**
		Creates a new FileReferenceList object. A FileReferenceList object
		contains nothing until you call the `browse()` method on it and the
		user selects one or more files. When you call `browse()` on the
		FileReference object, the `fileList` property of the object is
		populated with an array of `FileReference` objects.
	**/
	public constructor()
	{
		super();

		// __backend = new FileReferenceListBackend(this);
	}

	/**
		Displays a file-browsing dialog box that lets the user select one or
		more local files to upload. The dialog box is native to the user's
		operating system.
		In Flash Player 10 and later, you can call this method successfully
		only in response to a user event (for example, in an event handler for
		a mouse click or keypress event). Otherwise, calling this method
		results in Flash Player throwing an Error.

		When you call this method and the user successfully selects files, the
		`fileList` property of this FileReferenceList object is populated with
		an array of FileReference objects, one for each file that the user
		selects. Each subsequent time that the FileReferenceList.browse()
		method is called, the `FileReferenceList.fileList` property is reset
		to the file(s) that the user selects in the dialog box.

		Using the `typeFilter` parameter, you can determine which files the
		dialog box displays.

		Only one `FileReference.browse()`, `FileReference.download()`, or
		`FileReferenceList.browse()` session can be performed at a time on a
		FileReferenceList object (because only one dialog box can be opened at
		a time).

		@return Returns `true` if the parameters are valid and the
				file-browsing dialog box opens.
		@throws ArgumentError         If the `typeFilter` array does not
									  contain correctly formatted FileFilter
									  objects, an exception is thrown. For
									  details on correct filter formatting,
									  see the FileFilter documentation.
		@throws Error                 If the method is not called in response
									  to a user action, such as a mouse event
									  or keypress event.
		@throws IllegalOperationError Thrown for the following reasons: 1)
									  Another FileReference or
									  FileReferenceList browse session is in
									  progress; only one file browsing session
									  may be performed at a time. 2) A setting
									  in the user's mms.cfg file prohibits
									  this operation.
		@event cancel Invoked when the user dismisses the dialog box by
					  clicking Cancel or by closing it.
		@event select Invoked when the user has successfully selected an item
					  for upload from the dialog box.
	**/
	public browse(typeFilter: Array<FileFilter> = null): boolean
	{
		// return __backend.browse(typeFilter);
		return false;
	}

	// Get & Set Methods

	/**
		An array of `FileReference` objects.
		When the `FileReferenceList.browse()` method is called and the user
		has selected one or more files from the dialog box that the `browse()`
		method opens, this property is populated with an array of
		FileReference objects, each of which represents the files the user
		selected. You can then use this array to upload each file with the
		`FileReference.upload()`method. You must upload one file at a time.

		The `fileList` property is populated anew each time browse() is called
		on that FileReferenceList object.

		The properties of `FileReference` objects are described in the
		FileReference class documentation.
	**/
	public get fileList(): Array<FileReference>
	{
		return this.__fileList;
	}
}
