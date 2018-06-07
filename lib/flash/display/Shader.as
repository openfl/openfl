package flash.display {
	
	
	import flash.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	public class Shader {
		
		
		public function set byteCode (value:ByteArray):void {}
		
		public var data:ShaderData;
		
		protected function get_data ():ShaderData { return null; }
		protected function set_data (value:ShaderData):ShaderData { return null; }
		
		public var glFragmentSource:String;
		
		protected function get_glFragmentSource ():String { return null; }
		protected function set_glFragmentSource (value:String):String { return null; }
		
		public function get glProgram ():* { return null; }
		
		public var glVertexSource:String;
		
		protected function get_glVertexSource ():String { return null; }
		protected function set_glVertexSource (value:String):String { return null; }
		
		public var precisionHint:String;
		
		
		public function Shader (code:ByteArray = null) {}
		
		
	}
	
	
}