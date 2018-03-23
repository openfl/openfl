package openfl.display; #if (display || !flash)


import openfl.utils.ByteArray;


extern class GraphicsShader extends Shader {
	
	
	public var bitmap:ShaderInput<BitmapData>;
	
	public function new (code:ByteArray = null):Void;
	
	
}


#else


@:native("flash.display.Shader") extern class GraphicsShader extends Shader {
	
	
	public var bitmap (get, set):ShaderInput<BitmapData>;
	private inline function get_bitmap ():ShaderInput<BitmapData> { return null; }
	private inline function set_bitmap (value:ShaderInput<BitmapData>):ShaderInput<BitmapData> { return null; }
	
	public function new (code:ByteArray = null):Void;
	
	
}


#end