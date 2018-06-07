package flash.display3D.textures {
	
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	final public class CubeTexture extends TextureBase {
		
		
		public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:uint, async:Boolean = false):void {}
		public function uploadFromBitmapData (source:BitmapData, side:uint, miplevel:uint = 0):void {}
		public function uploadFromByteArray (data:ByteArray, byteArrayOffset:uint, side:uint, miplevel:uint = 0):void {}
		
		
	}
	
	
}