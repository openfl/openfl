package openfl.filters; #if !openfl_legacy


import openfl._internal.renderer.opengl.utils.RenderTexture;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.filters.commands.*;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.ImageData;
#end

@:access(openfl.display.BitmapData)
@:access(openfl.geom.Rectangle)


class BitmapFilter {
	
	private var __dirty:Bool = true;
	private var __passes:Int = 0;
	
	public function new () {
		
		
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	#if (js && html5)
	public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
	}
	#end
		
		
	private static function __applyFilters (filters:Array<BitmapFilter>, renderSession:RenderSession, bitmap:BitmapData) {
		
		if (!bitmap.__usingPingPongTexture) {
			throw ":TODO: unsupported mode";
		}
	
	
		for (filter in filters) {
			var useLastFilter = false;
		
			var commands = filter.__getCommands (bitmap);
		
			for (command in commands) {
				switch (command) {
					case Blur1D (target, source, blur, horizontal, strength, distance, angle) :
						Blur1DCommand.apply (renderSession, target, source, blur, horizontal, strength, distance, angle);

					case Colorize (target, source, color, alpha) :
						ColorizeCommand.apply (renderSession, target, source, color, alpha);
	
					case Combine (target, source1, source2) :
						CombineCommand.apply (renderSession, target, source1, source2);

					default :
				}
			
			}
			
		}
		
		
	}
	
	
	private static function __expandBounds (filters:Array<BitmapFilter>, rect:Rectangle, matrix:Matrix) {
		
		var r = Rectangle.__temp;
		r.setEmpty ();
		
		for (filter in filters) {
			
			filter.__growBounds (r);
			
		}
		
		r.__transform (r, matrix);
		rect.__expand (r.x, r.y, r.width, r.height);
		
	}
	
	
	private function __growBounds (rect:Rectangle) {
		
		
		
	}
	
	
	private function __getCommands (bitmap:BitmapData):Array<CommandType> {
		
		return [];
		
	}
	
	// :TODO: remove me
	private function __preparePass (pass:Int):Shader { return null; }
	
}


#else
typedef BitmapFilter = openfl._legacy.filters.BitmapFilter;
#end
