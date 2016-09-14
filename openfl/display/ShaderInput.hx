package openfl.display;


@:final class ShaderInput implements Dynamic {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Dynamic;
	public var input:Dynamic;
	public var width:Int;
	
	
	public function new () {
		
		channels = 0;
		height = 0;
		index = 0;
		width = 0;
		
	}
	
	
}