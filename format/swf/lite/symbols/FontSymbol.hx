package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;


class FontSymbol extends SWFSymbol {


	@:s public var advances:Array<Int>;
	@:s public var bold:Bool;
	@:s public var codes:Array<Int>;
	public var glyphs:Array<Array<ShapeCommand>>;
	@:s public var italic:Bool;
	@:s public var leading:Int;
	@:s public var name:String = "";


	public function new () {

		super ();

	}


}