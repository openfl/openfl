package openfl._internal.symbols;


import openfl._internal.swf.ShapeCommand;


class FontSymbol extends SWFSymbol {
	
	
	public var advances:Array<Int>;
	public var bold:Bool;
	public var codes:Array<Int>;
	public var glyphs:Array<Array<ShapeCommand>>;
	public var italic:Bool;
	public var leading:Int;
	public var name:String;
	
	
	public function new () {
		
		super ();
		
	}
	
	
}