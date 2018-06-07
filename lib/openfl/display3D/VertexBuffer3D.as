package openfl.display3D {
	
	
	// import lime.utils.ArrayBufferView;
	// import js.html.ArrayBufferView;
	import openfl.utils.ByteArray;
	// import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	public class VertexBuffer3D {
		
		
		public function dispose ():void {}
		public function uploadFromByteArray (data:ByteArray, byteArrayOffset:int, startVertex:int, numVertices:int):void {}
		public function uploadFromTypedArray (data:*):void {}
		public function uploadFromVector (data:Vector.<Number>, startVertex:int, numVertices:int):void {}
		
		
	}
	
	
}