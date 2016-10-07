package openfl.display;


#if !js @:generic #end


@:final class ShaderInput<T> /*implements Dynamic*/ {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Dynamic;
	public var input:T;
	@:noCompletion public var name:String;
	public var smoothing:Bool;
	public var width:Int;
	
	
	public function new () {
		
		channels = 0;
		height = 0;
		index = 0;
		width = 0;
		
	}
	
	
}