package openfl.display3D.textures;

#if (display || !flash)
import openfl.events.EventDispatcher;

@:jsRequire("openfl/display3D/textures/TextureBase", "default")
extern class TextureBase extends EventDispatcher
{
	public function dispose():Void;
}
#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end
