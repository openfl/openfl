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
	@:noCompletion private var __base:_TextureBase;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Context3DTextureFormat;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __optimizeForRenderToTexture:Bool;
	@:noCompletion private var __streamingLevels:Int;
	@:noCompletion private var __width:Int;

	@:noCompletion private function new(context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool,
			streamingLevels:Int)
	{
		super();

		__context = context;
		__width = width;
		__height = height;
		__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
	}

	/**
		Frees all GPU resources associated with this texture. After disposal, calling
		`upload()` or rendering with this object fails.
	**/
	public function dispose():Void
	{
		__base.dispose();
	}
}
#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end
