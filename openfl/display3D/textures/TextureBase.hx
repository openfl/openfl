package openfl.display3D.textures;


import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;
import openfl.utils.ByteArray.ByteArrayData;


class TextureBase extends EventDispatcher {
	
	public var context:Context3D;
	public var height:Int;
	public var frameBuffer:GLFramebuffer;
	public var glTexture:GLTexture;
	public var width:Int;
	
	
	public function new (context:Context3D, glTexture:GLTexture, width:Int = 0, height:Int = 0) {
		
		super ();
		
		this.context = context;
		this.width = width;
		this.height = height;
		this.glTexture = glTexture;
		
	}
	
	
	public function dispose ():Void {
		
		context.__deleteTexture (this);
		
	}
	
	private function flipPixels (inData:ArrayBufferView, _width:Int, _height:Int):UInt8Array {
		
		#if native
		if (inData == null) {
			
			return null;
			
		}
		
		var data = getUInt8ArrayFromArrayBufferView (inData);
		var data2 = new UInt8Array (data.length);
		var bpp = 4;
		var bytesPerLine = _width * bpp;
		var srcPosition = (_height - 1) * bytesPerLine;
		var dstPosition = 0;
		
		for (i in 0 ... _height) {
			
			data2.set (data.subarray (srcPosition, srcPosition + bytesPerLine), dstPosition);
			srcPosition -= bytesPerLine;
			dstPosition += bytesPerLine;
			
		}
		
		return data2;
		#else
		return null;
		#end
		
	}
	
	private function getUInt8ArrayFromByteArray (data:ByteArray, byteArrayOffset:Int):UInt8Array {
		
		#if js
		return byteArrayOffset == 0 ? @:privateAccess (data:ByteArrayData).b : new UInt8Array (data.toArrayBuffer (), byteArrayOffset);
		#else
		return new UInt8Array (data.toArrayBuffer (), byteArrayOffset);
		#end
		
	}
	
	private function getUInt8ArrayFromArrayBufferView (data:ArrayBufferView):UInt8Array {
		
		return new UInt8Array (data.buffer, data.byteOffset, data.byteLength);
		
	}
	
	private function getSizeForMipLevel (miplevel:Int): {width:Int, height:Int} {
		
		var _width = width;
		var _height = height;
		var lv = miplevel;
		
		while (lv > 0) {
			
			_width >>= 1;
			_height >>= 1;
			lv >>= 1;
			
		}
		
		return {width:_width, height:_height};
		
	}
}