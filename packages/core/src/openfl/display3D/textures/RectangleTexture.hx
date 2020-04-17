package openfl.display3D.textures;

#if !flash
import lime.utils.ArrayBufferView;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
	The Rectangle Texture class represents a 2-dimensional texture uploaded to a rendering
	context.

	Defines a 2D texture for use during rendering.

	Texture cannot be instantiated directly. Create instances by using Context3D
	`createRectangleTexture()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class RectangleTexture extends TextureBase
{
	@:noCompletion private var _:_RectangleTexture;

	@:noCompletion private function new(context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool)
	{
		super(context, width, height, format, optimizeForRenderToTexture, 0);

		_ = new _RectangleTexture(this);
		__base = _;
	}

	/**
		Uploads a texture from a BitmapData object.

		@param	source	a bitmap.
		@throws	TypeError	Null Pointer Error: when `source` is `null`.
		@throws	ArgumentError	Invalid BitmapData Error: when `source` does not contain a
		valid texture. The maximum allowed size in any dimension is 4096 or the size of the
		backbuffer, whichever is greater.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromBitmapData(source:BitmapData):Void
	{
		_.uploadFromBitmapData(source);
	}

	/**
		Uploads a texture from a ByteArray.

		@param	data	a byte array that is contains enough bytes in the textures internal
		format to fill the texture. rgba textures are read as bytes per texel component (1
		or 4). float textures are read as floats per texel component (1 or 4). The
		ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array object at which to start
		reading the texture data.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	RangeError	Bad Input Size: if the number of bytes available from
		`byteArrayOffset` to the end of data byte array is less than the amount of data
		required for a texture, or if `byteArrayOffset` is greater than or equal to the
		length of data.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		_.uploadFromByteArray(data, byteArrayOffset);
	}

	/**
		Uploads a texture from an ArrayBufferView.

		@param	data	a typed array that contains enough bytes in the textures internal
		format to fill the texture. rgba textures are read as bytes per texel component (1
		or 4). float textures are read as floats per texel component (1 or 4).
	**/
	public function uploadFromTypedArray(data:ArrayBufferView):Void
	{
		_.uploadFromTypedArray(data);
	}
}
#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end
