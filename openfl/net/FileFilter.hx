package openfl.net; #if (!display && !flash) #if !openfl_legacy


@:final class FileFilter {
	
	
	public var description:String;
	public var extension:String;
	public var macType:String;
	
	
	public function new (description:String, extension:String, macType:String = null) {
		
		this.description = description;
		this.extension = extension;
		this.macType = macType;
		
	}
	
	
}


#else
#end
#else


#if flash
@:native("flash.net.FileFilter")
#end

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


#end