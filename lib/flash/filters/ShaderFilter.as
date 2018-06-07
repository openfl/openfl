package flash.filters {
	
	
	// import flash.display.BlendMode;
	import flash.display.Shader;
	
	
	/**
	 * @externs
	 */
	public class ShaderFilter extends BitmapFilter {
		
		
		/*@:beta*/ public var blendMode:String;
		public var bottomExtension:int;
		public var leftExtension:int;
		public var rightExtension:int;
		public var shader:Shader;
		public var topExtension:int;
		
		public function ShaderFilter (shader:Shader) {}
		
		
	}
	
	
}