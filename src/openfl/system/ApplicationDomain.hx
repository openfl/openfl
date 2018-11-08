package openfl.system; #if !flash


import openfl.utils.Object;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class ApplicationDomain {
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
	
	public static var currentDomain (default, null) = new ApplicationDomain (null);
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
	
	public var parentDomain (default, null):ApplicationDomain;
	
	
	public function new (parentDomain:ApplicationDomain = null) {
		
		if (parentDomain != null) {
			
			this.parentDomain = parentDomain;
			
		} else {
			
			this.parentDomain = currentDomain;
			
		}
		
	}
	
	
	public function getDefinition (name:String):Class<Dynamic> {
		
		return Type.resolveClass (name);
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash11_3) function getQualifiedDefinitionNames() : flash.Vector<String>;
	
	
	public function hasDefinition (name:String):Bool {
		
		return (Type.resolveClass (name) != null);
		
	}
	
	
}


#else
typedef ApplicationDomain = flash.system.ApplicationDomain;
#end