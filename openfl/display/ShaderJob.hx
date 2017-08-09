package openfl.display;


import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class ShaderJob extends EventDispatcher {
	
	
	public var height:Int;
	public var progress (default, null):Float;
	public var shader:Shader;
	public var target:Dynamic;
	public var width:Int;
	
	
	public function new (shader:Shader = null, target:Dynamic = null, width:Int = 0, height:Int = 0) {
		
		super ();
		
		this.height = height;
		this.width = 0;
		
		progress = 0;
		
	}
	
	
	public function cancel ():Void {
		
		
		
	}
	
	
	public function start (waitForCompletion:Bool = false):Void {
		
		
		
	}
	
	
	
}