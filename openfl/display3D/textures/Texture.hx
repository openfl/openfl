package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.GLUtils;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import haxe.Timer;


@:final class Texture extends TextureBase {
	
	
	private static var __lowMemoryMode:Bool = false;
	
	//private var __format:Context3DTextureFormat;
	private var __height:Int;
	private var __miplevel:Int;
	private var __optimizeForRenderToTexture:Bool;
	private var __streamingLevels:Int;
	private var __width:Int;
	
	
	private function new (context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context, GL.TEXTURE_2D);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
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
		
		__miplevel = miplevel;
		
		var image = source.image;
		
		if (!image.premultiplied && image.transparent) {
			
			image = image.clone ();
			image.premultiplied = true;
			
		}
		
		uploadFromTypedArray (image.data);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void {
		
		__miplevel = miplevel;
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GL.bindTexture (__textureTarget, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (__textureTarget, 0, __internalFormat, __width, __height, 0, __format, GL.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		GLUtils.CheckGLError ();
		
		var memUsage = (__width * __height) * 4;
		__trackMemoryUsage (memUsage);
		
	}
	
	
	private static function __getATFVersion (data:ByteArray):UInt {
		
		var signature = data.readUTFBytes (3);
		
		if (signature != "ATF") {
			
			throw new IllegalOperationError ("ATF signature not found");
			
		}
		
		var position = data.position;
		var version = 0;
		
		if (data.bytesAvailable >= 5) {
			
			var sig = __readUInt32 (data);
			
			if (sig == 0xff) {
				
				version = data.readUnsignedByte ();
				
			} else {
				
				data.position = position;
				
			}
			
		}
		
		return version;
		
	}
	
	
	private static function __readUInt24 (data:ByteArray):UInt {
		
		var value:UInt;
		value = (data.readUnsignedByte () << 16);
		value |= (data.readUnsignedByte () << 8);
		value |= data.readUnsignedByte ();
		return value;
		
	}
	
	
	private static function __readUInt32 (data:ByteArray):UInt {
		
		var value:UInt;
		value = (data.readUnsignedByte () << 24);
		value |= (data.readUnsignedByte () << 16);
		value |= (data.readUnsignedByte () << 8);
		value |= data.readUnsignedByte ();
		return value;
		
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