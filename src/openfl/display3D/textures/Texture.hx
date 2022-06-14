package openfl.display3D.textures;

#if !flash
import haxe.io.Bytes;
import haxe.Timer;
import openfl.utils._internal.ArrayBufferView;
import openfl.utils._internal.UInt8Array;
import openfl.display3D._internal.ATFReader;
import openfl.display._internal.SamplerState;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.utils.ByteArray;

/**
	The Texture class represents a 2-dimensional texture uploaded to a rendering context.

	Defines a 2D texture for use during rendering.

	Texture cannot be instantiated directly. Create instances by using Context3D
	`createTexture()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.events.Event)
@:final class Texture extends TextureBase
{
	@:noCompletion private static var __lowMemoryMode:Bool = false;

	@:noCompletion private function new(context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool,
			streamingLevels:Int)
	{
		super(context);

		__width = width;
		__height = height;
		// __format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;

		var gl = __context.gl;

		__textureTarget = gl.TEXTURE_2D;

		__context.__bindGLTexture2D(__textureID);
		gl.texImage2D(__textureTarget, 0, __internalFormat, __width, __height, 0, __format, gl.UNSIGNED_BYTE, null);
		__context.__bindGLTexture2D(null);

		if (optimizeForRenderToTexture) __getGLFramebuffer(true, 0, 0);
	}

	/**
		Uploads a compressed texture in Adobe Texture Format (ATF) from a ByteArray
		object. ATF file version 2 requires SWF version 21 or newer and ATF file version 3
		requires SWF version 29 or newer. For ATF files created with png image without
		alpha the format string given during Context3DObject `createTexture` should be
		`"COMPRESSED"` and for ATF files created with png image with alpha the format
		string given during Context3DObject `createTexture` should be `"COMPRESSED_ALPHA"`.

		@param	data	a byte array that contains a compressed texture including mipmaps.
		The ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array at which to start reading
		the texture data.
		@param	async	If true, this function returns immediately. Any draw method which
		attempts to use the texture will fail until the upload completes successfully.
		Upon successful upload, this CubeTexture object dispatches `Event.TEXTURE_READY`.
		Default value: `false`.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Texture Decoding Failed: when the compression format of
		this object cannot be derived from the format of the compressed data in data or
		when the SWF version is incompatible with the ATF file version.
		@throws	ArgumentError	Texture Size Does Not Match: when the width and height of
		the decompressed texture do not equal the dimensions of this Texture object.
		@throws	ArgumentError	Miplevel Too Large: if the mip level of the decompressed
		texture is greater than that implied by the size of the texture.
		@throws	ArgumentError	Texture Format Mismatch: if the decoded ATF bytes don't
		contain a texture compatible with this texture's format.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	RangeError	Bad Input Size: when there is integer overflow of
		`byteArrayOffset` or if `byteArrayOffset` + 6 is greater than the length of `data`,
		or if the number of bytes available from `byteArrayOffset` to the end of the `data`
		byte array is less than the amount of data required for ATF texture.
	**/
	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void
	{
		if (!async)
		{
			__uploadCompressedTextureFromByteArray(data, byteArrayOffset);
		}
		else
		{
			Timer.delay(function()
			{
				__uploadCompressedTextureFromByteArray(data, byteArrayOffset);

				var event:Event = null;

				#if openfl_pool_events
				event = Event.__pool.get();
				event.type = Event.TEXTURE_READY;
				#else
				event = new Event(Event.TEXTURE_READY);
				#end

				dispatchEvent(event);

				#if openfl_pool_events
				Event.__pool.release(event);
				#end
			}, 1);
		}
	}

	/**
		Uploads a texture from a BitmapData object.

		@param	source	a bitmap.
		@param	miplevel	the mip level to be loaded, level zero being the top-level
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when `source` is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the larger of the Texture's dimensions.
		@throws	ArgumentError	Invalid BitmapData Error: if `source` if the BitmapData
		object does not contain a valid cube texture face. The image must have sides equal
		to a power of two, and the correct size for the miplevel specified.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and
		the code is executing on a mobile platform where runtime texture compression is
		not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void
	{
		#if lime
		/* TODO
			if (LowMemoryMode) {
				// shrink bitmap data
				source = source.shrinkToHalfResolution();
				// shrink our dimensions for upload
				width = source.width;
				height = source.height;
			}
		**/

		if (source == null) return;

		var width = __width >> miplevel;
		var height = __height >> miplevel;

		if (width == 0 && height == 0) return;

		if (width == 0) width = 1;
		if (height == 0) height = 1;

		if (source.width != width || source.height != height)
		{
			var copy = new BitmapData(width, height, true, 0);
			copy.draw(source);
			source = copy;
		}

		var image = __getImage(source);
		if (image == null) return;

		// TODO: Improve handling of miplevels with canvas src

		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			var gl = __context.gl;

			var width = __width >> miplevel;
			var height = __height >> miplevel;

			if (width == 0 && height == 0) return;

			if (width == 0) width = 1;
			if (height == 0) height = 1;

			__context.__bindGLTexture2D(__textureID);
			gl.texImage2D(__textureTarget, miplevel, __internalFormat, __format, gl.UNSIGNED_BYTE, image.buffer.src);
			__context.__bindGLTexture2D(null);

			return;
		}
		#end

		uploadFromTypedArray(image.data, miplevel);
		#end
	}

	/**
		Uploads a texture from a ByteArray.

		@param	data	a byte array that is contains enough bytes in the textures
		internal format to fill the texture. rgba textures are read as bytes per texel
		component (1 or 4). float textures are read as floats per texel component (1 or 4).
		The ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array object at which to start
		reading the texture data.
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the larger of the Texture's dimensions.
		@throws	RangeError	Bad Input Size: if the number of bytes available from
		`byteArrayOffset` to the end of the data byte array is less than the amount of data
		required for a texture of this mip level or if `byteArrayOffset` is greater than or
		equal to the length of data.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and
		the code is executing on a mobile platform where runtime texture compression is not
		supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void
	{
		#if lime
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b, miplevel);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset), miplevel);
		#end
	}

	/**
		Uploads a texture from an ArrayBufferView.

		@param	data	a typed array that contains enough bytes in the textures
		internal format to fill the texture. rgba textures are read as bytes per texel
		component (1 or 4). float textures are read as floats per texel component (1 or 4).
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
	**/
	public function uploadFromTypedArray(data:ArrayBufferView, miplevel:UInt = 0):Void
	{
		if (data == null) return;

		var gl = __context.gl;

		var width = __width >> miplevel;
		var height = __height >> miplevel;

		if (width == 0 && height == 0) return;

		if (width == 0) width = 1;
		if (height == 0) height = 1;

		__context.__bindGLTexture2D(__textureID);
		gl.texImage2D(__textureTarget, miplevel, __internalFormat, width, height, 0, __format, gl.UNSIGNED_BYTE, data);
		__context.__bindGLTexture2D(null);
	}

	@:noCompletion private override function __setSamplerState(state:SamplerState):Bool
	{
		if (super.__setSamplerState(state))
		{
			var gl = __context.gl;

			if (state.mipfilter != MIPNONE && !__samplerState.mipmapGenerated)
			{
				gl.generateMipmap(gl.TEXTURE_2D);
				__samplerState.mipmapGenerated = true;
			}

			if (Context3D.__glMaxTextureMaxAnisotropy != 0)
			{
				var aniso = switch (state.filter)
				{
					case ANISOTROPIC2X: 2;
					case ANISOTROPIC4X: 4;
					case ANISOTROPIC8X: 8;
					case ANISOTROPIC16X: 16;
					default: 1;
				}

				if (aniso > Context3D.__glMaxTextureMaxAnisotropy)
				{
					aniso = Context3D.__glMaxTextureMaxAnisotropy;
				}

				gl.texParameterf(gl.TEXTURE_2D, Context3D.__glTextureMaxAnisotropy, aniso);
			}

			return true;
		}

		return false;
	}

	@:noCompletion private function __uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		var reader = new ATFReader(data, byteArrayOffset);
		var alpha = reader.readHeader(__width, __height, false);

		var context = __context;
		var gl = context.gl;

		__context.__bindGLTexture2D(__textureID);

		var hasTexture = false;

		#if lime
		reader.readTextures(function(target, level, gpuFormat, width, height, blockLength, bytes:Bytes)
		{
			var format = alpha ? TextureBase.__compressedFormatsAlpha[gpuFormat] : TextureBase.__compressedFormats[gpuFormat];
			if (format == 0) return;

			hasTexture = true;
			__format = format;
			__internalFormat = format;

			if (alpha && gpuFormat == 2)
			{
				var size = Std.int(blockLength / 2);

				gl.compressedTexImage2D(__textureTarget, level, __internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));

				var alphaTexture = new Texture(__context, __width, __height, Context3DTextureFormat.COMPRESSED, __optimizeForRenderToTexture,
					__streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;

				__context.__bindGLTexture2D(alphaTexture.__textureID);
				gl.compressedTexImage2D(alphaTexture.__textureTarget, level, alphaTexture.__internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, size, size));

				__alphaTexture = alphaTexture;
			}
			else
			{
				gl.compressedTexImage2D(__textureTarget, level, __internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
			}
		});

		if (!hasTexture)
		{
			var data = new UInt8Array(__width * __height * 4);
			gl.texImage2D(__textureTarget, 0, __internalFormat, __width, __height, 0, __format, gl.UNSIGNED_BYTE, data);
		}
		#end

		__context.__bindGLTexture2D(null);
	}
}
#else
typedef Texture = flash.display3D.textures.Texture;
#end
