package openfl.display;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if !js @:generic #end


@:final class ShaderParameter<T> /*implements Dynamic*/ {
	
	
	public var index (default, null):Dynamic;
	@:noCompletion public var name:String;
	public var type (default, null):ShaderParameterType;
	public var value:Array<T>;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
}