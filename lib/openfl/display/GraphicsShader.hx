package openfl.display;

import openfl.utils.ByteArray;

#if !openfl_global
@:jsRequire("openfl/display/GraphicsShader", "default")
#end
extern class GraphicsShader extends Shader
{
	public var bitmap:ShaderInput<BitmapData>;
	public function new(code:ByteArray = null):Void;
}
