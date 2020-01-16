package openfl.display;

import openfl.utils.ByteArray;

#if !openfl_global
@:jsRequire("openfl/display/DisplayObjectShader", "default")
#end
extern class DisplayObjectShader extends Shader
{
	public function new(code:ByteArray = null);
}
