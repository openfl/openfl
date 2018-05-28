package flash.system {
	
	
	import flash.utils.ByteArray;
	// import flash.utils.Object;
	
	
	/**
	 * @externs
	 */
	final public class ApplicationDomain {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
		// #end
		
		public static function get currentDomain ():ApplicationDomain { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
		// #end
		
		public function get parentDomain ():ApplicationDomain { return null; }
		
		
		public function ApplicationDomain (parentDomain:ApplicationDomain = null) {}
		public function getDefinition (name:String):Object { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_3) function getQualifiedDefinitionNames() : flash.Vector;
		// #end
		
		public function hasDefinition (name:String):Boolean { return false; }
		
		
	}
	
	
}