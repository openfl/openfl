package openfl.display {
	
	
	// import openfl.display3D.Context3DMipFilter;
	// import openfl.display3D.Context3DTextureFilter;
	// import openfl.display3D.Context3DWrapMode;
	
	
	/**
	 * @externs
	 */
	final public class ShaderInput /*implements Dynamic*/ {
		
		
		public function get channels ():int { return 0; }
		public var filter:String;
		public var height:int;
		public function get index ():int { return 0; }
		public var input:Object;
		public var mipFilter:String;
		public var width:int;
		public var wrap:String;
		
		
		public function ShaderInput () {}
		
		
	}
	
	
}
