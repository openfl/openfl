package flash.display;

#if flash
import openfl.utils.ByteArray;

@:require(flash10)
@:final extern class ShaderData implements Dynamic
{
	public function new(byteArray:ByteArray):Void;
}
#else
typedef ShaderData = openfl.display.ShaderData;
#end
