package openfl.display3D._internal.assembler;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Reg
{
	public var code:Int;
	public var desc:String;

	public function new(code:Int, desc:String)
	{
		this.code = code;
		this.desc = desc;
	}
}
