package openfl.system; #if (!display && !flash)


import openfl.utils.Object;


@:final class ApplicationDomain {
	
	
	public static var currentDomain (default, null) = new ApplicationDomain (null);
	
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
	
	
	public function hasDefinition (name:String):Bool {
		
		return (Type.resolveClass (name) != null);
		
	}
	
	
}


#else


import openfl.utils.ByteArray;
import openfl.utils.Object;

#if flash
@:native("flash.system.ApplicationDomain")
#end


@:final extern class ApplicationDomain {
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
	#end
	
	public static var currentDomain (default, null):ApplicationDomain;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
	#end
	
	public var parentDomain (default, null):ApplicationDomain;
	
	
	public function new (parentDomain:ApplicationDomain = null);
	public function getDefinition (name:String):Dynamic;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) function getQualifiedDefinitionNames() : flash.Vector<String>;
	#end
	
	public function hasDefinition (name:String):Bool;
	
	
}


#end