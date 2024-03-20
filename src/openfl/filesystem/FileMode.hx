package openfl.filesystem;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
/**
	The FileMode enum defines string constants used in the `fileMode` parameter
	of the `open()` and `openAsync()` methods of the FileStream class. The
	`fileMode` parameter of these methods determines the capabilities available
	to the FileStream object once the file is opened.

	The following capabilities are available, in various combinations, based on
	the `fileMode` parameter value specified in the open method:

	- Reading — The FileStream object can read data from the file.
	- Writing — The FileStream object can write data to the file.
	- Creating — The FileStream object creates a nonexistent file upon opening.
	- Truncate upon opening — Data in the file is deleted upon opening (before any data is written).
	- Append written data — Data is always written to the end of the file (when any write method is called).

	@see `openfl.filesystem.FileStream.open()`
	@see `openfl.filesystem.FileStream.openAsync()`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FileMode(String) from String to String

{
	/**
		Used for a file to be opened in write mode, with all written data
		appended to the end of the file. Upon opening, any nonexistent file is
		created.
	**/
	var APPEND:String = "append";

	/**
		Used for a file to be opened in read-only mode. The file must exist
		(missing files are not created).
	**/
	var READ:String = "read";

	/**
		Used for a file to be opened in read/write mode. Upon opening, any
		nonexistent file is created.
	**/
	var UPDATE:String = "update";

	/**
		Used for a file to be opened in write-only mode. Upon opening, any
		nonexistent file is created, and any existing file is truncated (its
		data is deleted).
	**/
	var WRITE:String = "write";
}
#else
#if air
typedef FileMode = flash.filesystem.FileMode;
#end
#end
