package openfl.display3D._internal.assembler;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Opcode
{
	public var a:FS;
	public var b:FS;
	public var dest:String;
	public var flags:Flags;
	public var opcode:Int;

	public function new(dest:String, aformat:String, asize:Int, bformat:String, bsize:Int, opcode:Int, simple:Bool, horizontal:Bool = false,
			fragonly:Bool = false, matrix:Bool = false)
	{
		this.a = new FS();
		this.b = new FS();
		this.flags = new Flags();
		this.dest = dest;
		this.a.format = aformat;
		this.a.size = asize;
		this.b.format = bformat;
		this.b.size = bsize;
		this.opcode = opcode;
		this.flags.simple = simple;
		this.flags.horizontal = horizontal;
		this.flags.fragonly = fragonly;
		this.flags.matrix = matrix;
	}
}
