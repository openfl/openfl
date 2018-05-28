package openfl.display3D {
	
	
	// import lime.utils.ArrayBufferView;
	// import js.html.ArrayBufferView;
	import openfl.utils.ByteArray;
	// import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	final public class IndexBuffer3D {
		
		
		public function dispose ():void {}
		public function uploadFromByteArray (data:ByteArray, byteArrayOffset:int, startOffset:int, count:int):void {}
		public function uploadFromTypedArray (data:*):void {}
		public function uploadFromVector (data:Vector.<uint>, startOffset:int, count:int):void {}
		
		
	}
	
	
}