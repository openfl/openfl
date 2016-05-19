package openfl.net;


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