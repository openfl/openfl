package openfl._v2.text; #if lime_legacy


import openfl.display.BitmapData;
import openfl.Lib;


class AbstractFont {
	
	
	private static var factories = new Map<String, FontFactory> ();
	private static var registered:Bool;
	
	private var ascent:Int;
	private var descent:Int;
	private var height:Int;
	private var isRGB:Bool;
	
	
	private function new (height:Int, ascent:Int, descent:Int, isRGB:Bool) {
		
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.isRGB = isRGB;
		
	}
	
	
	private static function createFont (definition:FontDefinition):AbstractFont {
		
		if (factories.exists (definition.name)) {
			
			return factories.get (definition.name) (definition);
			
		}
		
		return null;
		
	}
	
	
	public function getGlyphInfo (char:Int):GlyphInfo {
		
		trace ("Warning: You should override getGlyphInfo");
		
		return null;
		
	}
	
	
	public static function registerFont (name:String, factory:FontFactory):Void {
		
		factories.set (name, factory);
		
		if (!registered) {
			
			var register = Lib.load ("lime", "lime_font_set_factory", 1);
			register (createFont);
			registered = true;
			
		}
		
	}
	
	
	public function renderGlyph (char:Int):BitmapData {
		
		trace ("Warning: You should override renderGlyph");
		
		return new BitmapData (1, 1);
		
	}
	
	
	private function renderGlyphInternal (char:Int):Dynamic {
		
		var result = renderGlyph (char);
		
		if (result != null) {
			
			return result.__handle;
			
		}
		
		return null;
		
	}
	
	
}


typedef FontDefinition = {
	
	name:String,
	height:Int,
	bold:Bool,
	italic:Bool,
	
};


typedef FontFactory = FontDefinition -> AbstractFont;


typedef GlyphInfo = {
	
	width:Int,
	height:Int,
	advance:Int,
	offsetX:Int,
	offsetY:Int,
	
};


#end