package openfl._internal.symbols;


import openfl._internal.swf.SWFLite;
import openfl._internal.timeline.Frame;
import openfl.display.MovieClip;

@:access(openfl.display.MovieClip)


class SpriteSymbol extends SWFSymbol {
	
	
	public var frames:Array<Frame>;
	
	
	public function new () {
		
		super ();
		
		frames = new Array<Frame> ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):MovieClip {
		
		var movieClip:MovieClip = null;
		
		MovieClip.__initSWF = swf;
		MovieClip.__initSymbol = this;
		
		if (className != null) {
			
			var symbolType = Type.resolveClass (className);
			
			if (symbolType != null) {
				
				movieClip = Type.createInstance (symbolType, []);
				
			} else {
				
				//Log.warn ("Could not resolve class \"" + className + "\"");
				
			}
			
		}
		
		if (movieClip == null) {
			
			movieClip = new MovieClip ();
			
		}
		
		return movieClip;
		
	}
	
	
}