package openfl.display;


@:final class ShaderInput implements Dynamic {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Dynamic;
	public var input (get, set):Dynamic;
	public var width:Int;
	
	private var __bitmapData:BitmapData;
	private var __isUniform:Bool;
	private var __name:String;
	
	
	public function new () {
		
		channels = 0;
		height = 0;
		index = 0;
		width = 0;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_input ():Dynamic {
		
		return __bitmapData;
		
	}
	
	
	private function set_input (value:Dynamic):Dynamic {
		
		return __bitmapData = cast (value, BitmapData);
		
	}
	
	
}