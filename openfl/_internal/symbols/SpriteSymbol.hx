package openfl._internal.symbols;


import openfl._internal.timeline.Frame;


class SpriteSymbol extends SWFSymbol {
	
	
	public var frames:Array<Frame>;
	
	
	public function new () {
		
		super ();
		
		frames = new Array<Frame> ();
		
	}
	
	
}