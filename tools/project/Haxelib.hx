package;


class Haxelib {
	
	
	public var name:String;
	public var version:String;
	
	
	public function new (name:String, version:String = "") {
		
		this.name = name;
		this.version = version;
		
	}
	
	
	public function clone ():Haxelib {
		
		var haxelib = new Haxelib (name, version);
		return haxelib;
		
	}
	
	
}