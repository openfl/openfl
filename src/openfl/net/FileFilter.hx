package openfl.net;

#if !flash
/**
	The FileFilter class is used to indicate what files on the user's system
	are shown in the file-browsing dialog box that is displayed when the
	`FileReference.browse()` method, the `FileReferenceList.browse()` method
	is called or a browse method of a File, FileReference, or
	FileReferenceList object is called. FileFilter instances are passed as a
	value for the optional `typeFilter` parameter to the method. If you use a
	FileFilter instance, extensions and file types that aren't specified in
	the FileFilter instance are filtered out; that is, they are not available
	to the user for selection. If no FileFilter object is passed to the
	method, all files are shown in the dialog box.
	You can use FileFilter instances in one of two ways:

	* A description with file extensions only
	* A description with file extensions and Macintosh file types

	The two formats are not interchangeable within a single call to the browse
	method. You must use one or the other.

	You can pass one or more FileFilter instances to the browse method, as
	shown in the following:

	```haxe
	var imagesFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
	var docFilter = new FileFilter("Documents", "*.pdf;*.doc;*.txt");
	var myFileReference = new FileReference();
	myFileReference.browse([imagesFilter, docFilter]);
	```

	Or in an AIR application:

	```haxe
	var imagesFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
	var docFilter = new FileFilter("Documents", "*.pdf;*.doc;*.txt");
	var myFile = new File();
	myFile.browseForOpen("Open", [imagesFilter, docFilter]);
	```

	The list of extensions in the `FileFilter.extension` property is used to
	filter the files shown in the file browsing dialog. The list is not
	actually displayed in the dialog box; to display the file types for users,
	you must list the file types in the description string as well as in the
	extension list. The description string is displayed in the dialog box in
	Windows and Linux. (It is not used on the Macintosh<sup>?/sup>.) On the
	Macintosh, if you supply a list of Macintosh file types, that list is used
	to filter the files. If not, the list of file extensions is used.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class FileFilter
{
	/**
		The description string for the filter. The description is visible to
		the user in the dialog box that opens when `FileReference.browse()` or
		`FileReferenceList.browse()` is called. The description string
		contains a string, such as `"Images (*.gif, *.jpg, *.png)"`, that
		can help instruct the user on what file types can be uploaded or
		downloaded. Note that the actual file types that are supported by this
		FileReference object are stored in the `extension` property.
	**/
	public var description:String;

	/**
		A list of file extensions. This list indicates the types of files that
		you want to show in the file-browsing dialog box. (The list is not
		visible to the user; the user sees only the value of the `description`
		property.) The `extension` property contains a semicolon-delimited
		list of file extensions, with a wildcard (*) preceding each
		extension, as shown in the following string: `"*.jpg;*.gif;*.png"`.
	**/
	public var extension:String;

	/**
		A list of Macintosh file types. This list indicates the types of files
		that you want to show in the file-browsing dialog box. (This list
		itself is not visible to the user; the user sees only the value of the
		`description` property.) The `macType` property contains a
		semicolon-delimited list of Macintosh file types, as shown in the
		following string: `"JPEG;jp2_;GIFF"`.
	**/
	public var macType:String;

	/**
		Creates a new FileFilter instance.

		@param description The description string that is visible to users
						   when they select files for uploading.
		@param extension   A list of file extensions that indicate which file
						   formats are visible to users when they select files
						   for uploading.
		@param macType     A list of Macintosh file types that indicate which
						   file types are visible to users when they select
						   files for uploading. If no value is passed, this
						   parameter is set to `null`.
	**/
	public function new(description:String, extension:String, macType:String = null)
	{
		this.description = description;
		this.extension = extension;
		this.macType = macType;
	}
}
#else
typedef FileFilter = flash.net.FileFilter;
#end
