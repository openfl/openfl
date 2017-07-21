package openfl.display3D.textures;


import haxe.Timer;
import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.Context3D)


@:final class CubeTexture extends TextureBase {
	
	
	private var __size:Int;
	private var __uploadedSides:Int;
	
	
	private function new (context:Context3D, size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context, GL.TEXTURE_CUBE_MAP);
		
		__size = size;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		__uploadedSides = 0;
		
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
	
	
	public function uploadFromBitmapData (source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		if (source == null) return;
		
		var size = __size >> miplevel;
		if (size == 0) return;
		
		//if (source.width != size || source.height != size) {
			//
			//var copy = new BitmapData (size, size, true, 0);
			//copy.draw (source);
			//source = copy;
			//
		//}
		
		var image = __getImage (source);
		
		uploadFromTypedArray (image.data, side, miplevel);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void {
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b, side);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset), side, miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void {
		
		if (data == null) return;
		
		var size = __size >> miplevel;
		if (size == 0) return;
		
		var target = switch (side) {
			
			case 0: GL.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 1: GL.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 2: GL.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 3: GL.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 4: GL.TEXTURE_CUBE_MAP_POSITIVE_Z;
			case 5: GL.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			default: throw new IllegalOperationError ();
			
		}
		
		GL.bindTexture (GL.TEXTURE_CUBE_MAP, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (target, miplevel, __internalFormat, size, size, 0, __format, GL.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		GLUtils.CheckGLError ();
		
		__uploadedSides |= 1 << side;
		
		var memUsage = (__size * __size) * 4;
		__trackMemoryUsage (memUsage);
		
	}
	
	
	private override function __setSamplerState (state:SamplerState) {
		
		if (!state.equals (__samplerState)) {
			
			if (state.minFilter != GL.NEAREST && state.minFilter != GL.LINEAR && !state.mipmapGenerated) {
				
				GL.generateMipmap (GL.TEXTURE_CUBE_MAP);
				GLUtils.CheckGLError ();
				
				state.mipmapGenerated = true;
				
			}
			
			if (state.maxAniso != 0.0) {
				
				GL.texParameterf (GL.TEXTURE_CUBE_MAP, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		super.__setSamplerState (state);
		
	}
	
	
	private function __uploadATFTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		//data.position = byteArrayOffset;
		//
		//var version = __getATFVersion (data);
		//var length = (version == 0) ? __readUInt24 (data) : __readUInt32 (data);
		//
		//if (cast ((byteArrayOffset + length), Int) > data.length) {
			//
			//throw new IllegalOperationError ("ATF length exceeds byte array length");
			//
		//}
		//
		//var tdata = data.readUnsignedByte();
		//var type:AtfType = cast (tdata >> 7);
		//
		//if (type != AtfType.NORMAL) {
			//
			//throw new IllegalOperationError ("ATF Cube maps are not supported");
			//
		//}
		//
		////Removing ATF format limitation to allow for multiple format support.
		////AtfFormat format = (AtfFormat)(tdata & 0x7f);	
		////if (format != AtfFormat.Block) {
		////	throw new NotImplementedException("Only ATF block compressed textures are supported");
		////}
		//
		//var width:Int = (1 << cast data.readUnsignedByte ());
		//var height:Int = (1 << cast data.readUnsignedByte ());
		//
		//if (width != __width || height != __height) {
			//
			//throw new IllegalOperationError ("ATF width and height dont match");
			//
		//}
		//
		//var mipCount:Int = cast data.readUnsignedByte ();
		//
		//for (level in 0...mipCount) {
			//
			//for (gpuFormat in 0...3) {
				//
				//var blockLength = (version == 0) ? __readUInt24 (data) : __readUInt32 (data);
				//
				///*
					////TODO: Figure out exceptions
					//if ((data.position + blockLength) > data.length) {
						//throw new System.IO.InvalidDataException("Block length exceeds ATF file length");
					//}*/
				//
				//if (blockLength > 0) {
					//
					//if (gpuFormat == 1) {
						//
						////TODO: Removed Monoplatform code
						//
					//} else if (gpuFormat == 2) {
						//
						////TODO: Removed Monoplatform code
						//
					//}
					//
					//// TODO handle other formats/platforms
					//
				//}
				//
				//data.position += blockLength;
				//
			//}
			//
		//}
		
	}
	
	
}