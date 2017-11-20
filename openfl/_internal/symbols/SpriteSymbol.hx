package openfl._internal.symbols;


import haxe.Log;
import openfl._internal.swf.SWFLite;
import openfl._internal.timeline.Frame;
import openfl.display.MovieClip;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.MovieClip)


class SpriteSymbol extends SWFSymbol {
	
	
	public var baseClassName:String;
	public var frames:Array<Frame>;
	
	
	public function new () {
		
		super ();
		
		frames = new Array<Frame> ();
		
	}
	

	@:access(openfl._internal.swf.SWFLiteLibrary.rootPath)
	@:access(openfl.display.MovieClip.__initialEnterFrame)
	private override function __createObject (swf:SWFLite):MovieClip {
		
		#if !macro
		MovieClip.__initSWF = swf;
		MovieClip.__initSymbol = this;
		#end
		
		var symbolType = null;
		
		if (className != null) {
			
			symbolType = Type.resolveClass (className);
			
			if (symbolType == null) {
				
				//Log.trace ("Could not resolve class \"" + className + "\"");
				
			}
			
		}
		if (symbolType == null && baseClassName != null) {
			
			symbolType = Type.resolveClass (baseClassName);
			
			if (symbolType == null) {
				
				Log.trace ("SWF Symbol \""+ className +"\" in library \""+ (swf.library.rootPath) +"\" has baseClassname \"" + baseClassName + "\" but no class by that name has been defined.");
				
			}
			
		}
		
		var movieClip:MovieClip = null;
		
		if (symbolType != null) {
			
			movieClip = Type.createInstance (symbolType, []);
			
		} else {
			
			movieClip = new MovieClip ();
			
		}

		// now that all symbols have been constructed and framescripts have been added, run the initial enterFrame to set up initial children and call the first framescript
		movieClip.__initialEnterFrame();

		return movieClip;
		
	}
	
	
}