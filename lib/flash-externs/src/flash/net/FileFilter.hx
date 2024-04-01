package flash.net;

#if flash
@:final extern class FileFilter
{
	#if (haxe_ver < 4.3)
	public var description:String;
	public var extension:String;
	public var macType:String;
	#else
	@:flash.property var description(get, set):String;
	@:flash.property var extension(get, set):String;
	@:flash.property var macType(get, set):String;
	#end

	public function new(description:String, extension:String, macType:String = null);

	#if (haxe_ver >= 4.3)
	private function get_description():String;
	private function get_extension():String;
	private function get_macType():String;
	private function set_description(value:String):String;
	private function set_extension(value:String):String;
	private function set_macType(value:String):String;
	#end
}
#else
typedef FileFilter = openfl.net.FileFilter;
#end
