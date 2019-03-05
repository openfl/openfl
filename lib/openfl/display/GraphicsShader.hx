package openfl.display;

import openfl.utils.ByteArray;

@:jsRequire("openfl/display/GraphicsShader", "default")
extern class GraphicsShader extends Shader
{
	public var bitmap:ShaderInput<BitmapData>;
	public function new(code:ByteArray = null):Void;
}
