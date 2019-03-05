package openfl.display;

import openfl.utils.ByteArray;

@:jsRequire("openfl/display/DisplayObjectShader", "default")
extern class DisplayObjectShader extends Shader
{
	public function new(code:ByteArray = null);
}
