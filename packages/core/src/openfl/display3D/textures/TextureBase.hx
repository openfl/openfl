package openfl.display3D.textures;

#if !flash
import openfl.events.EventDispatcher;

/**
	The TextureBase class is the base class for Context3D texture objects.

	**Note:** You cannot create your own texture classes using TextureBase. To add
	functionality to a texture class, extend either Texture or CubeTexture instead.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TextureBase extends EventDispatcher
{
	@:noCompletion private function new(context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool,
			streamingLevels:Int)
	{
		if (_ == null)
		{
			_ = new _TextureBase(this, context, width, height, format, optimizeForRenderToTexture, streamingLevels);
		}

		super();
	}

	/**
		Frees all GPU resources associated with this texture. After disposal, calling
		`upload()` or rendering with this object fails.
	**/
	public function dispose():Void
	{
		(_ : _TextureBase).dispose();
	}
}
#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end
