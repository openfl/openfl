package openfl.display;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)


class Shape extends DisplayObject implements IShaderDrawable {
	
	
	public var graphics (get, never):Graphics;
	@:beta public var shader:Shader;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics (this);
			
		}
		
		return __graphics;
		
	}
	
	
}