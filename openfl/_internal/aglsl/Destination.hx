package openfl._internal.aglsl;


class Destination {
	
	
	public var dim:Int;
	public var filter:Int;
	public var indexoffset:Int;
	public var indexregtype:Int;
	public var indexselect:Int;
	public var indirectflag:Int;
	public var lodbiad:Int; // sampler
	public var mask:Int;
	public var mipmap:Int;
	public var readmode:Int; // sampler
	public var regnum:Int;
	public var regtype:UInt;
	public var special:Int;
	public var swizzle:Int;
	public var wrap:Int;
	
	
	public function new () {
		
		mask = 0;
		regnum = 0;
		regtype = 0;
		dim = 0;
		
	}
	
	
}