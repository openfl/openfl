package openfl.display;


import openfl.utils.ByteArray;

#if (!cs || display) @:final #end


class ShaderData implements Dynamic {
	
	
	public var aAlpha:ShaderParameter<Float>;
	public var aPosition:ShaderParameter<Float>;
	public var aTexCoord:ShaderParameter<Float>;
	public var uImage0:ShaderInput<BitmapData>;
	public var uMatrix:ShaderParameter<Float>;
	
	
	public function new (byteArray:ByteArray) {
		
		
		
	}
	
	
}