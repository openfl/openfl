package openfl.display;


@:final @:generic class ShaderParameter<T> /*implements Dynamic*/ {
	
	
	public var index (default, null):Dynamic;
	public var type (default, null):ShaderParameterType;
	public var value:Array<T>;
	
	private var __isUniform:Bool;
	private var __name:String;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
}