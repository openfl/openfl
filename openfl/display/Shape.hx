package openfl.display;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)


class Shape extends DisplayObject implements IShaderDrawable {
	
	
	public var graphics (get, never):Graphics;
	@:beta public var shader:Shader;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Shape.prototype, "graphics", { get: untyped __js__ ("function () { return this.get_graphics (); }") });
		
	}
	#end
	
	
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