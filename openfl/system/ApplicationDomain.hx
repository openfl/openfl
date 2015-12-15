package openfl.system;


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