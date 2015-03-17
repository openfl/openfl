package openfl._legacy.gl; #if openfl_legacy


class GLObject {
	
	
	public var id (default, null):Dynamic;
	public var invalidated (get, null):Bool;
	public var valid (get, null):Bool;
	
	private var version:Int;
	
	
	private function new (version:Int, id:Dynamic) {
		
		this.version = version;
		this.id = id;
		
	}
	
	
	private function getType ():String {
		
		return "GLObject";
		
	}
	
	
	public function invalidate ():Void {
		
		id = null;
		
	}
	
	
	public function isValid ():Bool {
		
		return id != null && version == GL.version;
		
	}
	
	
	public function isInvalid ():Bool {
		
		return !isValid ();
		
	}
	
	
	public function toString ():String {
		
		return getType () + "(" + id + ")";
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_invalidated ():Bool {
		
		return isInvalid ();
		
	}
	
	
	private function get_valid ():Bool {
		
		return isValid ();
		
	}
	
	
}


#end