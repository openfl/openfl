package openfl.display3D.textures {
	
	
	import openfl.display.BitmapData;
	import openfl.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	final public class Texture extends TextureBase {
		
		
		public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:uint, async:Boolean = false):void {}
		public function uploadFromBitmapData (source:BitmapData, miplevel:uint = 0):void {}
		public function uploadFromByteArray (data:ByteArray, byteArrayOffset:uint, miplevel:uint = 0):void {}
		
		
	}
	
	
}