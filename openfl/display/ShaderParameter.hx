package openfl.display;


@:final class ShaderParameter implements Dynamic {
	
	
	public var index (default, null):Dynamic;
	public var type (default, null):ShaderParameterType;
	public var value:Array<Dynamic>;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
}