package flash.display3D.textures;

#if flash
import openfl.events.EventDispatcher;

extern class TextureBase extends EventDispatcher
{
	public function dispose():Void;
}
#else
typedef TextureBase = openfl.display3D.textures.TextureBase;
#end
