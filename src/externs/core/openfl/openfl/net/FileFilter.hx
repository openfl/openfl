package openfl.net; #if (display || !flash)


@:final extern class FileFilter {
	
	
	/**
	 * The description string for the filter.
	 */
	public var description:String;
	
	/**
	 * A list of file extensions.
	 */
	public var extension:String;
	
	/**
	 * A list of Macintosh file types.
	 */
	public var macType:String;
	
	
	public function new (description:String, extension:String, macType:String = null);
	
	
}


#else
typedef FileFilter = flash.net.FileFilter;
#end