package openfl.display;

import openfl.display.Shader;
import openfl.utils.ByteArray;

#if !openfl_global
@:jsRequire("openfl/filters/BitmapFilterShader", "default")
#end
extern class BitmapFilterShader extends Shader
{
	public function new(code:ByteArray = null);
}
