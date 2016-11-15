package format.swf.lite.symbols;


import format.swf.lite.timeline.Frame;


class SpriteSymbol extends SWFSymbol {
	
	
	public var frames:Array<Frame>;
	public var scalingGridRect:flash.geom.Rectangle;
	
	public function new () {
		
		super ();
		
		frames = new Array<Frame> ();
		
	}
	
	
}
