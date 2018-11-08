package openfl.net; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class FileFilter {
	
	
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
	
	
	public function new (description:String, extension:String, macType:String = null) {
		
		this.description = description;
		this.extension = extension;
		this.macType = macType;
		
	}
	
	
}


#else
typedef FileFilter = flash.net.FileFilter;
#end