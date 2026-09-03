package openfl.display;

#if !flash
#if lime
import openfl.utils.ByteArray;
import lime.graphics.Image;
#end

interface IEncoderOptions
{
	#if lime
	private function encode(image:#if lime Image #else Dynamic #end, byteArray:ByteArray):ByteArray;
	#end
}
#end