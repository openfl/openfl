package openfl.net;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class FileFilter
{
	public var description:String;
	public var extension:String;
	public var macType:String;

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
