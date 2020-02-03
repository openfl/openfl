package openfl.display;

import openfl.display.Shader;
import openfl.utils.ByteArray;

@:jsRequire("openfl/filters/BitmapFilterShader", "default")
extern class BitmapFilterShader extends Shader
{
	public function new(code:ByteArray = null);
}
