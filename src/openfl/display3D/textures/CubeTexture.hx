package openfl.display3D.textures;

#if !flash
import haxe.Timer;
import openfl.display3D._internal.GLFramebuffer;
import openfl.display3D._internal.ATFReader;
import openfl.display._internal.SamplerState;
import openfl.utils._internal.ArrayBufferView;
import openfl.utils._internal.Log;
import openfl.utils._internal.UInt8Array;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.utils.ByteArray;

/**
	The CubeTexture class represents a cube texture uploaded to a rendering context.

	Defines a cube map texture for use during rendering. Cube mapping is used for many
	rendering techniques, such as environment maps, skyboxes, and skylight illumination.

	You cannot create a CubeTexture object directly; use the Context3D
	`createCubeTexture()` instead.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.events.Event)
@:final class CubeTexture extends TextureBase
{
	@:noCompletion private var __framebufferSurface:Int;
	@:noCompletion private var __size:Int;
	@:noCompletion private var __uploadedSides:Int;

	@:noCompletion private function new(context:Context3D, size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int)
	{
		super(context);

		__size = size;
		__width = __height = __size;
		// __format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;

		__textureTarget = __context.gl.TEXTURE_CUBE_MAP;
		__uploadedSides = 0;

		// if (optimizeForRenderToTexture) __getFramebuffer (true, 0, 0);
	}

	/**
		Uploads a cube texture in Adobe Texture Format (ATF) from a byte array.

		The byte array must contain all faces and mipmaps for the texture.

		@param	data	a byte array that containing a compressed cube texture including
		mipmaps. The ByteArray object must use the little endian format.
		@param	byteArrayOffset	an optional offset at which to start reading the texture
		data.
		@param	async	If `true`, this function returns immediately. Any draw method which
		attempts to use the texture will fail until the upload completes successfully. Upon
		successful upload, this Texture object dispatches `Event.TEXTURE_READY`. Default
		value: `false`.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Texture Decoding Failed: when the compression format of
		this object cannot be derived from the format of the compressed data in data.
		@throws	ArgumentError	Texture Needs To Be Square: when the decompressed texture
		does not have equal `width` and `height`.
		@throws	ArgumentError	Texture Size Does Not Match: when the width and height of
		the decompressed texture do not equal the length of the texture's edge.
		@throws	ArgumentError	Miplevel Too Large: if the mip level of the decompressed
		texture is greater than that implied by the length of the texture's edge.
		@throws	ArgumentError	Texture Format Mismatch: if the decoded ATF bytes don't
		contain a texture compatible with this texture's format or is not a cube texture.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	RangeError	Bad Input Size: when there is integer overflow of
		`byteArrayOffset` or if `byteArrayOffset` + 6 is greater than the length of `data`,
		or if the number of bytes available from `byteArrayOffset` to the end of the data
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
				event = Event.__pool.get(Event.TEXTURE_READY);
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
		Uploads a component of a cube map texture from a BitmapData object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromBitmapData()` as necessary to upload each mip level and face of the
		cube map.

		@param	source	a bitmap.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero being the top-level
		full-resolution image. The default value is zero.
		@throws	TypeError	Null Pointer Error: if source is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the the texture's dimensions.
		@throws	ArgumentError	Invalid Cube Side: if side is greater than 5.
		@throws	ArgumentError	Invalid BitmapData Error: if source if the BitmapData
		object does not contain a valid cube texture face. The image must be square, with
		sides equal to a power of two, and the correct size for the miplevel specified.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		`Context3DTextureFormat.COMPRESSED` or `Context3DTextureFormat.COMPRESSED_ALPHA`
		and the code is executing on a mobile platform where runtime texture compression
		is not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromBitmapData(source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void
	{
		#if lime
		if (source == null) return;
		var size = __size >> miplevel;
		if (size == 0) return;

		var image = __getImage(source);
		if (image == null) return;

		// TODO: Improve handling of miplevels with canvas src

		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			var gl = __context.gl;

			var size = __size >> miplevel;
			if (size == 0) return;

			var target = __sideToTarget(side);
			__context.__bindGLTextureCubeMap(__textureID);
			gl.texImage2D(target, miplevel, __internalFormat, __format, gl.UNSIGNED_BYTE, image.buffer.src);
			__context.__bindGLTextureCubeMap(null);

			__uploadedSides |= 1 << side;
			return;
		}
		#end

		uploadFromTypedArray(image.data, side, miplevel);
		#end
	}

	/**
		Uploads a component of a cube map texture from a ByteArray object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromByteArray()` as neccessary to upload each mip level and face of the
		cube map.

		@param	data	a byte array containing the image in the format specified when
		this CubeTexture object was created. The ByteArray object must use the little
		endian format.
		@param	byteArrayOffset	reading of the byte array starts there.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when data is null.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater than that implied by the Texture's dimensions.
		@throws	RangeError	Bad Input Size: if the number of bytes available from byteArrayOffset to the end of the data byte array is less than the amount of data required for a texture of this mip level or if byteArrayOffset is greater than or equal to the length of data.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and the code is executing on a mobile platform where runtime texture compression is not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void
	{
		#if lime
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b, side, miplevel);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset), side, miplevel);
		#end
	}

	/**
		Uploads a component of a cube map texture from an ArrayBufferView object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromTypedArray()` as necessary to upload each mip level and face of the
		cube map.

		@param	data	a typed array containing the image in the format specified when
		this CubeTexture object was created.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
	**/
	public function uploadFromTypedArray(data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void
	{
		if (data == null) return;

		var gl = __context.gl;

		var size = __size >> miplevel;
		if (size == 0) return;

		var target = __sideToTarget(side);

		__context.__bindGLTextureCubeMap(__textureID);
		gl.texImage2D(target, miplevel, __internalFormat, size, size, 0, __format, gl.UNSIGNED_BYTE, data);
		__context.__bindGLTextureCubeMap(null);

		__uploadedSides |= 1 << side;
	}

	@:noCompletion private override function __getGLFramebuffer(enableDepthAndStencil:Bool, antiAlias:Int, surfaceSelector:Int):GLFramebuffer
	{
		var gl = __context.gl;

		if (__glFramebuffer == null)
		{
			__glFramebuffer = gl.createFramebuffer();
			__framebufferSurface = -1;
		}

		if (__framebufferSurface != surfaceSelector)
		{
			__framebufferSurface = surfaceSelector;

			__context.__bindGLFramebuffer(__glFramebuffer);
			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_CUBE_MAP_POSITIVE_X + surfaceSelector, __textureID, 0);

			if (__context.__enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(gl.FRAMEBUFFER);

				if (code != gl.FRAMEBUFFER_COMPLETE)
				{
					Log.error('Error: Context3D.setRenderToTexture status:${code} width:${__width} height:${__height}');
				}
			}
		}

		return super.__getGLFramebuffer(enableDepthAndStencil, antiAlias, surfaceSelector);
	}

	@:noCompletion private override function __setSamplerState(state:SamplerState):Bool
	{
		if (super.__setSamplerState(state))
		{
			var gl = __context.gl;

			if (state.mipfilter != MIPNONE && !__samplerState.mipmapGenerated)
			{
				gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
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

				gl.texParameterf(gl.TEXTURE_CUBE_MAP, Context3D.__glTextureMaxAnisotropy, aniso);
			}

			return true;
		}

		return false;
	}

	@:noCompletion private function __sideToTarget(side:UInt):Int
	{
		var gl = __context.gl;

		return switch (side)
		{
			case 0: gl.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 1: gl.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 2: gl.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 3: gl.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 4: gl.TEXTURE_CUBE_MAP_POSITIVE_Z;
			case 5: gl.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			default: throw new IllegalOperationError();
		}
	}

	@:noCompletion private function __uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		var reader = new ATFReader(data, byteArrayOffset);
		var alpha = reader.readHeader(__size, __size, true);

		var gl = __context.gl;

		__context.__bindGLTextureCubeMap(__textureID);

		var hasTexture = false;

		#if lime
		reader.readTextures(function(side, level, gpuFormat, width, height, blockLength, bytes)
		{
			var format = alpha ? TextureBase.__compressedFormatsAlpha[gpuFormat] : TextureBase.__compressedFormats[gpuFormat];
			if (format == 0) return;

			hasTexture = true;
			var target = __sideToTarget(side);

			__format = format;
			__internalFormat = format;

			if (alpha && gpuFormat == 2)
			{
				var size = Std.int(blockLength / 2);

				gl.compressedTexImage2D(target, level, __internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));

				var alphaTexture = new CubeTexture(__context, __size, Context3DTextureFormat.COMPRESSED, __optimizeForRenderToTexture, __streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;

				__context.__bindGLTextureCubeMap(alphaTexture.__textureID);
				gl.compressedTexImage2D(target, level, alphaTexture.__internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, size, size));

				__alphaTexture = alphaTexture;
			}
			else
			{
				gl.compressedTexImage2D(target, level, __internalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
			}
		});

		if (!hasTexture)
		{
			for (side in 0...6)
			{
				var data = new UInt8Array(__size * __size * 4);
				gl.texImage2D(__sideToTarget(side), 0, __internalFormat, __size, __size, 0, __format, gl.UNSIGNED_BYTE, data);
			}
		}
		#end

		__context.__bindGLTextureCubeMap(null);
	}
}
#else
typedef CubeTexture = flash.display3D.textures.CubeTexture;
#end
