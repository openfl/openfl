package flash.net;

#if flash
@:final extern class FileFilter
{
	public var description:String;
	public var extension:String;
	public var macType:String;
	public function new(description:String, extension:String, macType:String = null);
}
#else
typedef FileFilter = openfl.net.FileFilter;
#end
