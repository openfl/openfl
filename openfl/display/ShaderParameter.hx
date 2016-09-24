package openfl.display;


@:final #if !js @:generic #end  class ShaderParameter<T> /*implements Dynamic*/ {
	
	
	public var index (default, null):Dynamic;
	@:noCompletion public var name:String;
	public var type (default, null):ShaderParameterType;
	public var value:Array<T>;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
}