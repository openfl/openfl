package openfl.filesystem;

#if (!flash && sys)
@:enum
abstract FileMode(String) from String to String
{
	/**
		Used for a file to be opened in write mode, with all written data appended to the end of the file.
		Upon opening, any nonexistent file is created. .
	**/
	var APPEND:String = "append";

	/**
		Used for a file to be opened in read-only mode. The file must exist (missing files are not created). 
	**/
	var READ:String = "read";

	/**
		Used for a file to be opened in read/write mode. Upon opening, any nonexistent file is created. 
	**/
	var UPDATE:String = "update";

	/**
		Used for a file to be opened in write-only mode. Upon opening, any nonexistent file is created, and 
		any existing file is truncated (its data is deleted). 
	**/
	var WRITE:String = "write";
}
#else
#if air
typedef FileMode = flash.filesystem.FileMode;
#end
#end
