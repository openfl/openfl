package openfl._internal.symbols;


import openfl._internal.swf.SWFLite;
import openfl.display.SimpleButton;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.SimpleButton)


class ButtonSymbol extends SWFSymbol {
	
	
	public var downState:SpriteSymbol;
	public var hitState:SpriteSymbol;
	public var overState:SpriteSymbol;
	public var upState:SpriteSymbol;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):SimpleButton {
		
		var simpleButton:SimpleButton = null;
		
		SimpleButton.__initSWF = swf;
		SimpleButton.__initSymbol = this;
		
		if (className != null) {
			
			var symbolType = Type.resolveClass (className);
			
			if (symbolType != null) {
				
				simpleButton = Type.createInstance (symbolType, []);
				
			} else {
				
				//Log.warn ("Could not resolve class \"" + symbol.className + "\"");
				
			}
			
		}
		
		if (simpleButton == null) {
			
			simpleButton = new SimpleButton ();
			
		}
		
		return simpleButton;
		
	}
	
	
}