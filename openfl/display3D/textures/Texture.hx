package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import haxe.Timer;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.Context3D)


@:final class Texture extends TextureBase {
	
	
	private static var __lowMemoryMode:Bool = false;
	
	
	private function new (context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context, GL.TEXTURE_2D);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		GL.bindTexture (__textureTarget, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (__textureTarget, 0, __internalFormat, width, height, 0, __format, GL.UNSIGNED_BYTE, 0);
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		
		uploadFromTypedArray (null);
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {
		
		data.position = byteArrayOffset;
		var signature:String = data.readUTFBytes (3);
		data.position = byteArrayOffset;
		
		if (signature == "ATF") {
			
			GL.bindTexture (__textureTarget, __textureID);
			GLUtils.CheckGLError ();
			
			__uploadATFTextureFromByteArray (data, byteArrayOffset);
			
			GL.bindTexture (__textureTarget, null);
			GLUtils.CheckGLError ();
			
		} else {
			
			// trackCompressedMemoryUsage(dataLength); // TODO: Figure out where dataLength comes from
			
			GL.bindTexture (__textureTarget, null);
			GLUtils.CheckGLError ();
			
		}
		
		if (async) {
			
			Timer.delay (function () {
				
				dispatchEvent (new Event (Event.TEXTURE_READY));
				
			}, 1);
			
		}
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		/* TODO
			if (LowMemoryMode) {
				// shrink bitmap data
				source = source.shrinkToHalfResolution();
				// shrink our dimensions for upload
				width = source.width;
				height = source.height;
			}
			*/
		
		if (source == null) return;
		
		var width = __width >> miplevel;
		var height = __height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		if (source.width != width || source.height != height) {
			
			var copy = new BitmapData (width, height, true, 0);
			copy.draw (source);
			source = copy;
			
		}
		
		var image = __getImage (source);
		
		uploadFromTypedArray (image.data, miplevel);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void {
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset), miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, miplevel:UInt = 0):Void {
		
		if (data == null) return;
		
		var width = __width >> miplevel;
		var height = __height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		GL.bindTexture (__textureTarget, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (__textureTarget, miplevel, __internalFormat, width, height, 0, __format, GL.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		GLUtils.CheckGLError ();
		
		var memUsage = (width * height) * 4;
		__trackMemoryUsage (memUsage);
		
	}
	
	
	private override function __setSamplerState (state:SamplerState) {
		
		if (!state.equals (__samplerState)) {
			
			if ((state.minFilter == GL.LINEAR_MIPMAP_LINEAR || state.minFilter == GL.NEAREST_MIPMAP_NEAREST) && !state.mipmapGenerated) {
				
				GL.generateMipmap (GL.TEXTURE_2D);
				GLUtils.CheckGLError ();
				
				state.mipmapGenerated = true;
				
			}
			
			if (state.maxAniso != 0.0) {
				
				GL.texParameterf (GL.TEXTURE_2D, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		super.__setSamplerState (state);
		
	}
	
	
	private function __uploadATFTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		data.position = byteArrayOffset;
		
		var version = __getATFVersion (data);
		var length = (version == 0) ? __readUInt24 (data) : __readUInt32 (data);
		
		if (cast ((byteArrayOffset + length), Int) > data.length) {
			
			throw new IllegalOperationError ("ATF length exceeds byte array length");
			
		}
		
		var tdata = data.readUnsignedByte();
		var type:AtfType = cast (tdata >> 7);
		
		if (type != AtfType.NORMAL) {
			
			throw new IllegalOperationError ("ATF Cube maps are not supported");
			
		}
		
		//Removing ATF format limitation to allow for multiple format support.
		//AtfFormat format = (AtfFormat)(tdata & 0x7f);	
		//if (format != AtfFormat.Block) {
		//	throw new NotImplementedException("Only ATF block compressed textures are supported");
		//}
		
		var width:Int = (1 << cast data.readUnsignedByte ());
		var height:Int = (1 << cast data.readUnsignedByte ());
		
		if (width != __width || height != __height) {
			
			throw new IllegalOperationError ("ATF width and height dont match");
			
		}
		
		var mipCount:Int = cast data.readUnsignedByte ();
		
		for (level in 0...mipCount) {
			
			for (gpuFormat in 0...3) {
				
				var blockLength = (version == 0) ? __readUInt24 (data) : __readUInt32 (data);
				
				/*
					//TODO: Figure out exceptions
					if ((data.position + blockLength) > data.length) {
						throw new System.IO.InvalidDataException("Block length exceeds ATF file length");
					}*/
				
				if (blockLength > 0) {
					
					if (gpuFormat == 1) {
						
						//TODO: Removed Monoplatform code
						
					} else if (gpuFormat == 2) {
						
						//TODO: Removed Monoplatform code
						
					}
					
					// TODO handle other formats/platforms
					
				}
				
				data.position += blockLength;
				
			}
			
		}
		
	}
	
	
}


@:enum private abstract AtfType(Int) {
	
	public var NORMAL = 0;
	public var CUBE_MAP = 1;
	
}


@:enum private abstract AtfFormat(Int) {
	
	public var RGB888 = 0;
	public var RGBA8888 = 1;
	public var COMPRESSED = 2;
	public var BLOCK = 5;
	
}